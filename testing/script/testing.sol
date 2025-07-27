// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Testgan is ERC20 {
    address public deployer;

    constructor(uint256 initialSupply) ERC20("Testgan", "TST") {
        deployer = msg.sender;

        // Total supply = initialSupply
        // Deployer gets 10%
        uint256 deployerShare = (initialSupply * 10) / 100;
        uint256 remaining = initialSupply - deployerShare;

        _mint(deployer, deployerShare);      // 10% to deployer
        _mint(address(this), remaining);     // 90% stays in contract (optional)
    }

    // Optional: public mint function if needed for users or DApp
    function mint(address to, uint256 amount) public {
        require(msg.sender == deployer, "Only deployer can mint");
        _mint(to, amount);
    }
}
