// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract CheckPoolTokensScript is Script {
    
    // Contract addresses
    address constant DEX_POOL = 0x91EB5Dd37767925c7E764F9DC08ecBbe3Ed56f88;
    address constant ZEROSTART_TOKEN = 0x0E5cf4661Bc46dA84Efb649Ce2f5c0Ee3C47c3B2;
    address constant USDT_TOKEN = 0x2728DD8B45B788e26d12B13Db5A244e5403e7eda;
    
    function run() external view {
        IERC20 zeroStartToken = IERC20(ZEROSTART_TOKEN);
        IERC20 usdtToken = IERC20(USDT_TOKEN);
        
        console.log("=== CHECKING POOL TOKEN BALANCES ===");
        console.log("Pool Address:", DEX_POOL);
        console.log("ZeroStart Token:", ZEROSTART_TOKEN);
        console.log("USDT Token:", USDT_TOKEN);
        
        // Check token balances in the pool
        uint256 poolZeroStartBalance = zeroStartToken.balanceOf(DEX_POOL);
        uint256 poolUsdtBalance = usdtToken.balanceOf(DEX_POOL);
        
        console.log("");
        console.log("=== RAW BALANCES ===");
        console.log("Pool ZeroStart Balance (wei):", poolZeroStartBalance);
        console.log("Pool USDT Balance (wei):", poolUsdtBalance);
        
        // Manual formatting with known decimals
        console.log("");
        console.log("=== FORMATTED BALANCES ===");
        
        // ZeroStart has 18 decimals
        if (poolZeroStartBalance > 0) {
            uint256 zeroStartWhole = poolZeroStartBalance / 1e18;
            uint256 zeroStartDecimal = poolZeroStartBalance % 1e18;
            console.log("ZeroStart Whole Part:", zeroStartWhole);
            console.log("ZeroStart Decimal Part:", zeroStartDecimal);
            console.log("ZeroStart Total (approx):", zeroStartWhole);
        } else {
            console.log("ZeroStart Balance: 0");
        }
        
        // USDT has 6 decimals
        if (poolUsdtBalance > 0) {
            uint256 usdtWhole = poolUsdtBalance / 1e6;
            uint256 usdtDecimal = poolUsdtBalance % 1e6;
            console.log("USDT Whole Part:", usdtWhole);
            console.log("USDT Decimal Part:", usdtDecimal);
            console.log("USDT Total (approx):", usdtWhole);
        } else {
            console.log("USDT Balance: 0");
        }
        
        // Token presence check
        console.log("");
        console.log("=== TOKEN PRESENCE CHECK ===");
        if (poolZeroStartBalance > 0) {
            console.log("[SUCCESS] ZeroStart tokens ARE present in pool");
        } else {
            console.log("[ERROR] ZeroStart tokens NOT present in pool");
        }
        
        if (poolUsdtBalance > 0) {
            console.log("[SUCCESS] USDT tokens ARE present in pool");
        } else {
            console.log("[ERROR] USDT tokens NOT present in pool");
        }
        
        // Detailed analysis
        console.log("");
        console.log("=== DETAILED ANALYSIS ===");
        
        if (poolUsdtBalance > 0) {
            console.log("USDT Analysis:");
            console.log("  Raw amount:", poolUsdtBalance);
            console.log("  In standard USDT units:", poolUsdtBalance / 1e6);
            console.log("  Fractional part:", poolUsdtBalance % 1e6);
            
            if (poolUsdtBalance < 1e6) {
                console.log("  NOTE: Less than 1 USDT - this might not show in some explorers");
            }
        }
        
        if (poolZeroStartBalance > 0) {
            console.log("ZeroStart Analysis:");
            console.log("  Raw amount:", poolZeroStartBalance);
            console.log("  In standard token units:", poolZeroStartBalance / 1e18);
        }
        
        // Price calculation
        if (poolZeroStartBalance > 0 && poolUsdtBalance > 0) {
            console.log("");
            console.log("=== PRICE CALCULATION ===");
            
            // Calculate price: 1 USDT = ? ZeroStart
            // poolZeroStartBalance (18 decimals) / poolUsdtBalance (6 decimals)
            // Need to adjust for decimal difference
            uint256 adjustedZeroStart = poolZeroStartBalance / 1e12; // Convert to 6 decimals
            uint256 priceZeroStartPerUsdt = adjustedZeroStart / poolUsdtBalance;
            
            console.log("Price: 1 USDT =", priceZeroStartPerUsdt, "ZeroStart (approx)");
            
            // Calculate reverse price if possible
            if (priceZeroStartPerUsdt > 0) {
                uint256 priceUsdtPerZeroStart = poolUsdtBalance / adjustedZeroStart;
                console.log("Price: 1 ZeroStart =", priceUsdtPerZeroStart, "micro-USDT");
            }
        }
        
        console.log("");
        console.log("=== CONCLUSION ===");
        if (poolUsdtBalance > 0) {
            console.log("RESULT: USDT tokens ARE in the pool!");
            console.log("Amount:", poolUsdtBalance, "wei");
            console.log("This equals approximately:", poolUsdtBalance / 1e6, "USDT");
            if (poolUsdtBalance < 1e6) {
                console.log("NOTE: Amount is less than 1 USDT, so it might not display prominently in block explorers");
            }
        } else {
            console.log("RESULT: USDT tokens are NOT in the pool");
        }
    }
}