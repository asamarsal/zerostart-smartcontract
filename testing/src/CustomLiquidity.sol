// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CustomLiquidity {
    IERC20 public tokenA;
    IERC20 public tokenB;

    uint256 public reserveA;
    uint256 public reserveB;
    mapping(address => uint256) public liquidity;

    uint256 public totalLiquidity;

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function addLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "invalid amounts");

        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        uint256 liquidityMinted;
        if (totalLiquidity == 0) {
            liquidityMinted = amountA + amountB;
        } else {
            liquidityMinted = (amountA * totalLiquidity) / reserveA;
        }

        liquidity[msg.sender] += liquidityMinted;
        totalLiquidity += liquidityMinted;

        reserveA += amountA;
        reserveB += amountB;
    }

    function removeLiquidity(uint256 amount) external {
        require(amount > 0 && liquidity[msg.sender] >= amount, "not enough LP");

        uint256 amountA = (amount * reserveA) / totalLiquidity;
        uint256 amountB = (amount * reserveB) / totalLiquidity;

        liquidity[msg.sender] -= amount;
        totalLiquidity -= amount;

        reserveA -= amountA;
        reserveB -= amountB;

        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);
    }

    function swapAforB(uint256 amountIn) external {
        require(amountIn > 0, "invalid input");
        tokenA.transferFrom(msg.sender, address(this), amountIn);

        // constant product formula: x * y = k
        uint256 amountOut = (reserveB * amountIn) / (reserveA + amountIn);

        reserveA += amountIn;
        reserveB -= amountOut;

        tokenB.transfer(msg.sender, amountOut);
    }
}
