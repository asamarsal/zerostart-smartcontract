// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";
import "../src/CustomLiquidity.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract AddLiquidity is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        address pool = vm.envAddress("POOL_ADDRESS");
        address tokenA = vm.envAddress("TOKEN_A");
        address tokenB = vm.envAddress("TOKEN_B");

        vm.startBroadcast(deployerKey);

        // Jangan approve lagi di sini
        CustomLiquidity(pool).addLiquidity(1e18, 1e18);

        vm.stopBroadcast();

        console.log("Liquidity added to pool:", pool);
    }
}
