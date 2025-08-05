// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";
import "../src/DEXAMMPool.sol";

/**
 * @title Remove Partial Liquidity Script
 * @dev Script untuk remove sebagian liquidity saja
 */
contract RemovePartialLiquidity is Script {
    
    address constant DEX_POOL = 0x91EB5Dd37767925c7E764F9DC08ecBbe3Ed56f88;
    
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        DEXAMMPool dexPool = DEXAMMPool(DEX_POOL);
        
        console.log("=== Remove Partial Liquidity ===");
        console.log("Deployer:", deployer);
        
        uint256 lpBalance = dexPool.balanceOf(deployer);
        console.log("Current LP Balance:", lpBalance);
        
        require(lpBalance > 0, "No LP tokens");
        
        // Remove 50% of liquidity (change this percentage as needed)
        uint256 removeAmount = lpBalance / 2;  // 50%
        // uint256 removeAmount = lpBalance / 4;  // 25%
        // uint256 removeAmount = lpBalance * 3 / 4;  // 75%
        
        console.log("Removing LP Amount:", removeAmount);
        console.log("Percentage:", (removeAmount * 100) / lpBalance, "%");
        
        vm.startBroadcast(deployerPrivateKey);
        
        (uint256 amountA, uint256 amountB) = dexPool.removeLiquidity(
            removeAmount,
            0,
            0
        );
        
        vm.stopBroadcast();
        
        console.log("=== Results ===");
        console.log("ZeroStart Received:", amountA);
        console.log("USDT Received:", amountB);
        console.log("Remaining LP:", dexPool.balanceOf(deployer));
    }
}