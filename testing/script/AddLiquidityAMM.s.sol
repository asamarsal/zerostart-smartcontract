// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";
import "../src/DEXAMMPool.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract AddLiquidityScript is Script {
    
    // Contract addresses
    address constant DEX_POOL = 0x91EB5Dd37767925c7E764F9DC08ecBbe3Ed56f88;
    address constant ZEROSTART_TOKEN = 0x0E5cf4661Bc46dA84Efb649Ce2f5c0Ee3C47c3B2;
    address constant USDT_TOKEN = 0x2728DD8B45B788e26d12B13Db5A244e5403e7eda;
    
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        DEXAMMPool dexPool = DEXAMMPool(DEX_POOL);
        IERC20 zeroStartToken = IERC20(ZEROSTART_TOKEN);
        IERC20 usdtToken = IERC20(USDT_TOKEN);
        
        console.log("=== Add Liquidity to DEX Pool ===");
        console.log("Deployer:", deployer);
        console.log("DEX Pool:", DEX_POOL);
        
        // Check balances before
        uint256 zeroStartBalance = zeroStartToken.balanceOf(deployer);
        uint256 usdtBalance = usdtToken.balanceOf(deployer);
        
        console.log("ZeroStart Balance:", zeroStartBalance);
        console.log("USDT Balance:", usdtBalance);
        
        require(zeroStartBalance > 0, "No ZeroStart tokens");
        require(usdtBalance > 0, "No USDT tokens");
        
        // Define amounts (adjust these values based on your tokens)
        uint256 zeroStartAmount = 1 * 1e18; // 0 ZeroStart tokens
        uint256 usdtAmount = 100 * 1e18;        // 1 USDT
        
        // Ensure we have enough balance
        if (zeroStartAmount > zeroStartBalance) {
            zeroStartAmount = zeroStartBalance;
        }
        if (usdtAmount > usdtBalance) {
            usdtAmount = usdtBalance;
        }
        
        console.log("Adding liquidity:");
        console.log("ZeroStart Amount:", zeroStartAmount);
        console.log("USDT Amount:", usdtAmount);
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Step 1: Approve tokens
        console.log("Approving tokens...");
        zeroStartToken.approve(DEX_POOL, zeroStartAmount);
        usdtToken.approve(DEX_POOL, usdtAmount);
        
        // Step 2: Add liquidity
        console.log("Adding liquidity...");
        (uint256 amountA, uint256 amountB, uint256 liquidity) = dexPool.addLiquidity(
            zeroStartAmount,  // amountADesired
            usdtAmount,       // amountBDesired
            0,                // amountAMin (0 for first liquidity)
            0                 // amountBMin (0 for first liquidity)
        );
        
        vm.stopBroadcast();
        
        console.log("=== Liquidity Added Successfully ===");
        console.log("ZeroStart Amount Used:", amountA);
        console.log("USDT Amount Used:", amountB);
        console.log("LP Tokens Received:", liquidity);
        
        // Check pool info
        (uint256 reserveA, uint256 reserveB, uint256 totalSupply, uint256 totalStaked) = dexPool.getPoolInfo();
        console.log("=== Pool Info After Addition ===");
        console.log("Reserve A (ZeroStart):", reserveA);
        console.log("Reserve B (USDT):", reserveB);
        console.log("Total LP Supply:", totalSupply);
        console.log("Total Staked:", totalStaked);
        
        // Show prices
        uint256 priceA = dexPool.getTokenAPrice();
        uint256 priceB = dexPool.getTokenBPrice();
        console.log("ZeroStart Price (in USDT):", priceA);
        console.log("USDT Price (in ZeroStart):", priceB);
    }
}