// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";
import "../src/ZeroStart.sol";

contract DeployZeroStart is Script {
    function run() external {
        vm.startBroadcast();
        ZeroStart token = ZeroStart(0x0E5cf4661Bc46dA84Efb649Ce2f5c0Ee3C47c3B2);
        token.mint(msg.sender, 1000 ether);
        vm.stopBroadcast();
    }
}
