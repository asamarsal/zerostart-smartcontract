// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.20;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Deploytokena is ERC20 {
    address public deployer;

    constructor(uint256 initialSupply) ERC20("tokena", "tka") {
        deployer = msg.sender;

        // Total supply = initialSupply
        // Deployer gets 10%
        uint256 deployerShare = (initialSupply * 100) / 100;
        uint256 remaining = initialSupply - deployerShare;

        _mint(deployer, deployerShare);      // 10% to deployer
        _mint(address(this), remaining);     // 90% stays in contract (optional)
    }

    // Mint function if needed for users or DApp
    function mint(address to, uint256 amount) public {
        require(msg.sender == deployer, "Only deployer can mint");
        _mint(to, amount);
    }

    // Burn function if needed for users or DApp
    function burn(uint256 amount) public returns (bool) {
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to burn");
        
        _burn(msg.sender, amount);
        return true;
    }
}