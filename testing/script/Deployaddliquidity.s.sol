// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";
import "../src/CustomLiquidity.sol";

contract Deploy is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        address tokenA = vm.envAddress("TOKEN_A");
        address tokenB = vm.envAddress("TOKEN_B");

        vm.startBroadcast(deployerKey);
        CustomLiquidity pool = new CustomLiquidity(tokenA, tokenB);
        vm.stopBroadcast();

        console.log("Pool deployed at:", address(pool));
    }
}
