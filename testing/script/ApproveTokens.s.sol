// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract ApproveTokens is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        address tokenA = vm.envAddress("TOKEN_A");
        address tokenB = vm.envAddress("TOKEN_B");
        address pool = vm.envAddress("POOL_ADDRESS");

        // jumlah yang diapprove (misalnya 1e24 = 1 juta token, biar tidak perlu approve berkali2)
        uint256 approveAmount = 1e24;

        vm.startBroadcast(deployerKey);

        IERC20(tokenA).approve(pool, approveAmount);
        IERC20(tokenB).approve(pool, approveAmount);

        vm.stopBroadcast();

        console.log("Approved", approveAmount, "for Pool:", pool);
    }
}
