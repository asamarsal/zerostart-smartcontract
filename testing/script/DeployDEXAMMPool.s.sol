// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";
import "../src/DEXAMMPool.sol";

contract DeployDEXAMMPool is Script {
    
    // Token addresses untuk Lisk Sepolia
    address constant ZEROSTART_TOKEN = 0x0E5cf4661Bc46dA84Efb649Ce2f5c0Ee3C47c3B2;
    address constant USDT_TOKEN = 0x2728DD8B45B788e26d12B13Db5A244e5403e7eda;
    
    DEXAMMPool public dexPool;
    
    function run() external {
        // Ambil private key dari environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        console.log("=== FIXED DEX AMM Pool Deployment ===");
        console.log("Deployer address:", deployer);
        console.log("ZeroStart Token:", ZEROSTART_TOKEN);
        console.log("USDT Token:", USDT_TOKEN);
        console.log("Network: Lisk Sepolia");
        
        // Mulai broadcast transaksi
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy DEXAMMPool contract
        dexPool = new DEXAMMPool(ZEROSTART_TOKEN, USDT_TOKEN);
        
        // Stop broadcast
        vm.stopBroadcast();
        
        // Log deployment info
        console.log("=== Deployment Successful ===");
        console.log("DEXAMMPool deployed at:", address(dexPool));
        console.log("Owner:", dexPool.owner());
        console.log("Token A:", address(dexPool.tokenA()));
        console.log("Token B:", address(dexPool.tokenB()));
        console.log("Trading Fee:", dexPool.tradingFee(), "basis points");
        console.log("Reward Rate:", dexPool.getAPR(), "basis points");
        
        // Verification info
        console.log("=== Contract Verification Info ===");
        console.log("Contract Address:", address(dexPool));
        console.log("Constructor Args:");
        console.log("  _tokenA:", ZEROSTART_TOKEN);
        console.log("  _tokenB:", USDT_TOKEN);
    }
}