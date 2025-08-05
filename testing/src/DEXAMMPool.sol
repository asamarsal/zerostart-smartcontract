// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title DEX AMM Pool Contract for Lisk Sepolia (FIXED VERSION)
 * @dev Simple AMM DEX with staking functionality
 * ZeroStart Token: 0x0E5cf4661Bc46dA84Efb649Ce2f5c0Ee3C47c3B2
 * USDT: 0x2728DD8B45B788e26d12B13Db5A244e5403e7eda
 */
contract DEXAMMPool is ERC20, ReentrancyGuard, Ownable {
    
    // State variables
    IERC20 public immutable tokenA; // ZeroStart Token
    IERC20 public immutable tokenB; // USDT
    
    uint256 public reserveA;
    uint256 public reserveB;
    
    // Fee configuration (30 = 0.3%)
    uint256 public tradingFee = 30;
    uint256 public constant FEE_DENOMINATOR = 10000;
    
    // Minimum liquidity - burn to dead address instead of address(0)
    uint256 public constant MINIMUM_LIQUIDITY = 1000;
    address private constant DEAD_ADDRESS = 0x000000000000000000000000000000000000dEaD;
    
    // Staking
    mapping(address => uint256) public stakedAmount;
    mapping(address => uint256) public stakeTimestamp;
    mapping(address => uint256) public rewardDebt;
    
    uint256 public totalStaked;
    uint256 public rewardRate = 1000; // 10% APR
    
    // Events
    event LiquidityAdded(address indexed user, uint256 amountA, uint256 amountB, uint256 lpTokens);
    event LiquidityRemoved(address indexed user, uint256 amountA, uint256 amountB, uint256 lpTokens);
    event TokenSwapped(address indexed user, address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut);
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);
    
    constructor(
        address _tokenA,
        address _tokenB
    ) ERC20("DEX LP Token", "DEX-LP") Ownable(msg.sender) {
        require(_tokenA != address(0) && _tokenB != address(0), "Invalid token addresses");
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }
    
    // =========================
    // LIQUIDITY FUNCTIONS
    // =========================
    
    function addLiquidity(
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin
    ) external nonReentrant returns (uint256 amountA, uint256 amountB, uint256 liquidity) {
        require(amountADesired > 0 && amountBDesired > 0, "Invalid amounts");
        
        (amountA, amountB) = _calculateAmounts(amountADesired, amountBDesired, amountAMin, amountBMin);
        
        // Transfer tokens
        require(tokenA.transferFrom(msg.sender, address(this), amountA), "Transfer A failed");
        require(tokenB.transferFrom(msg.sender, address(this), amountB), "Transfer B failed");
        
        // Calculate LP tokens
        liquidity = _calculateLiquidity(amountA, amountB);
        _mint(msg.sender, liquidity);
        
        _updateReserves();
        emit LiquidityAdded(msg.sender, amountA, amountB, liquidity);
    }
    
    function removeLiquidity(
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin
    ) external nonReentrant returns (uint256 amountA, uint256 amountB) {
        require(liquidity > 0, "Invalid liquidity");
        require(balanceOf(msg.sender) >= liquidity, "Insufficient LP tokens");
        
        uint256 totalSupply_ = totalSupply();
        require(totalSupply_ > 0, "No total supply");
        
        amountA = (liquidity * reserveA) / totalSupply_;
        amountB = (liquidity * reserveB) / totalSupply_;
        
        require(amountA >= amountAMin && amountB >= amountBMin, "Insufficient amounts");
        
        _burn(msg.sender, liquidity);
        require(tokenA.transfer(msg.sender, amountA), "Transfer A failed");
        require(tokenB.transfer(msg.sender, amountB), "Transfer B failed");
        
        _updateReserves();
        emit LiquidityRemoved(msg.sender, amountA, amountB, liquidity);
    }
    
    // =========================
    // SWAP FUNCTIONS
    // =========================
    
    function swapAToB(uint256 amountIn, uint256 amountOutMin) external nonReentrant returns (uint256 amountOut) {
        require(amountIn > 0, "Invalid input");
        require(reserveA > 0 && reserveB > 0, "No liquidity");
        
        amountOut = getAmountOut(amountIn, reserveA, reserveB);
        require(amountOut >= amountOutMin, "Insufficient output");
        require(amountOut <= reserveB, "Insufficient liquidity");
        
        require(tokenA.transferFrom(msg.sender, address(this), amountIn), "Transfer failed");
        require(tokenB.transfer(msg.sender, amountOut), "Transfer failed");
        
        _updateReserves();
        emit TokenSwapped(msg.sender, address(tokenA), address(tokenB), amountIn, amountOut);
    }
    
    function swapBToA(uint256 amountIn, uint256 amountOutMin) external nonReentrant returns (uint256 amountOut) {
        require(amountIn > 0, "Invalid input");
        require(reserveA > 0 && reserveB > 0, "No liquidity");
        
        amountOut = getAmountOut(amountIn, reserveB, reserveA);
        require(amountOut >= amountOutMin, "Insufficient output");
        require(amountOut <= reserveA, "Insufficient liquidity");
        
        require(tokenB.transferFrom(msg.sender, address(this), amountIn), "Transfer failed");
        require(tokenA.transfer(msg.sender, amountOut), "Transfer failed");
        
        _updateReserves();
        emit TokenSwapped(msg.sender, address(tokenB), address(tokenA), amountIn, amountOut);
    }
    
    // =========================
    // STAKING FUNCTIONS
    // =========================
    
    function stake(uint256 amount) external nonReentrant {
        require(amount > 0, "Invalid amount");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        
        _updateRewards(msg.sender);
        
        _transfer(msg.sender, address(this), amount);
        stakedAmount[msg.sender] += amount;
        totalStaked += amount;
        stakeTimestamp[msg.sender] = block.timestamp;
        
        emit Staked(msg.sender, amount);
    }
    
    function unstake(uint256 amount) external nonReentrant {
        require(amount > 0, "Invalid amount");
        require(stakedAmount[msg.sender] >= amount, "Insufficient staked");
        
        _updateRewards(msg.sender);
        
        stakedAmount[msg.sender] -= amount;
        totalStaked -= amount;
        _transfer(address(this), msg.sender, amount);
        
        emit Unstaked(msg.sender, amount);
    }
    
    function claimRewards() external nonReentrant {
        _updateRewards(msg.sender);
        
        uint256 reward = rewardDebt[msg.sender];
        require(reward > 0, "No rewards");
        
        rewardDebt[msg.sender] = 0;
        _mint(msg.sender, reward);
        
        emit RewardsClaimed(msg.sender, reward);
    }
    
    // =========================
    // VIEW FUNCTIONS
    // =========================
    
    function getTokenAPrice() external view returns (uint256) {
        if (reserveA == 0 || reserveB == 0) return 0;
        return (reserveB * 1e18) / reserveA;
    }
    
    function getTokenBPrice() external view returns (uint256) {
        if (reserveA == 0 || reserveB == 0) return 0;
        return (reserveA * 1e18) / reserveB;
    }
    
    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public view returns (uint256) {
        require(amountIn > 0 && reserveIn > 0 && reserveOut > 0, "Invalid input");
        
        uint256 amountInWithFee = amountIn * (FEE_DENOMINATOR - tradingFee);
        uint256 numerator = amountInWithFee * reserveOut;
        uint256 denominator = (reserveIn * FEE_DENOMINATOR) + amountInWithFee;
        
        return numerator / denominator;
    }
    
    function getPoolInfo() external view returns (
        uint256 _reserveA,
        uint256 _reserveB,
        uint256 _totalSupply,
        uint256 _totalStaked
    ) {
        return (reserveA, reserveB, totalSupply(), totalStaked);
    }
    
    function getUserInfo(address user) external view returns (
        uint256 lpBalance,
        uint256 _stakedAmount,
        uint256 pendingRewards
    ) {
        return (
            balanceOf(user),
            stakedAmount[user],
            _calculatePendingRewards(user)
        );
    }
    
    function getAPR() external view returns (uint256) {
        return rewardRate;
    }
    
    // =========================
    // INTERNAL FUNCTIONS
    // =========================
    
    function _calculateAmounts(
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin
    ) internal view returns (uint256 amountA, uint256 amountB) {
        if (reserveA == 0 && reserveB == 0) {
            return (amountADesired, amountBDesired);
        }
        
        uint256 amountBOptimal = (amountADesired * reserveB) / reserveA;
        if (amountBOptimal <= amountBDesired) {
            require(amountBOptimal >= amountBMin, "Insufficient B");
            return (amountADesired, amountBOptimal);
        } else {
            uint256 amountAOptimal = (amountBDesired * reserveA) / reserveB;
            require(amountAOptimal <= amountADesired && amountAOptimal >= amountAMin, "Insufficient A");
            return (amountAOptimal, amountBDesired);
        }
    }
    
    // FIXED: Burn minimum liquidity to dead address instead of address(0)
    function _calculateLiquidity(uint256 amountA, uint256 amountB) internal returns (uint256) {
        uint256 totalSupply_ = totalSupply();
        
        if (totalSupply_ == 0) {
            uint256 liquidity = _sqrt(amountA * amountB);
            require(liquidity > MINIMUM_LIQUIDITY, "Insufficient liquidity");
            // FIXED: Mint to dead address instead of address(0)
            _mint(DEAD_ADDRESS, MINIMUM_LIQUIDITY);
            return liquidity - MINIMUM_LIQUIDITY;
        } else {
            return _min(
                (amountA * totalSupply_) / reserveA,
                (amountB * totalSupply_) / reserveB
            );
        }
    }
    
    function _updateReserves() internal {
        reserveA = tokenA.balanceOf(address(this));
        reserveB = tokenB.balanceOf(address(this));
        
        // Adjust for staked LP tokens
        if (totalStaked > 0) {
            uint256 stakedLPBalance = balanceOf(address(this));
            if (stakedLPBalance > 0) {
                uint256 totalSupply_ = totalSupply();
                if (totalSupply_ > 0) {
                    reserveA -= (stakedLPBalance * reserveA) / totalSupply_;
                    reserveB -= (stakedLPBalance * reserveB) / totalSupply_;
                }
            }
        }
    }
    
    function _updateRewards(address user) internal {
        if (stakedAmount[user] > 0) {
            uint256 pending = _calculatePendingRewards(user);
            rewardDebt[user] += pending;
            stakeTimestamp[user] = block.timestamp;
        }
    }
    
    function _calculatePendingRewards(address user) internal view returns (uint256) {
        if (stakedAmount[user] == 0) return 0;
        
        uint256 timeStaked = block.timestamp - stakeTimestamp[user];
        uint256 yearlyReward = (stakedAmount[user] * rewardRate) / FEE_DENOMINATOR;
        
        return (yearlyReward * timeStaked) / 365 days;
    }
    
    // Utility functions
    function _sqrt(uint256 x) internal pure returns (uint256) {
        if (x == 0) return 0;
        uint256 z = (x + 1) / 2;
        uint256 y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }
    
    function _min(uint256 x, uint256 y) internal pure returns (uint256) {
        return x < y ? x : y;
    }
    
    // =========================
    // ADMIN FUNCTIONS
    // =========================
    
    function setTradingFee(uint256 _fee) external onlyOwner {
        require(_fee <= 1000, "Fee too high"); // Max 10%
        tradingFee = _fee;
    }
    
    function setRewardRate(uint256 _rate) external onlyOwner {
        require(_rate <= 5000, "Rate too high"); // Max 50%
        rewardRate = _rate;
    }
    
    function emergencyWithdraw(address token, uint256 amount) external onlyOwner {
        require(IERC20(token).transfer(owner(), amount), "Transfer failed");
    }
}