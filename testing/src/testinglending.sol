// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TestingLending is Ownable {
    IERC20 public tst;
    uint256 public feeRate = 5; // 5%

    struct Loan {
        uint256 amount;
        uint256 dueDate;
        bool repaid;
    }

    mapping(address => Loan) public loans;

    constructor(address _tst) Ownable(msg.sender) {
        tst = IERC20(_tst);
    }
    // Lender deposit ETH
    receive() external payable {}

    function borrow(uint256 amountInWei) 
    external {
        require(address(this).balance >= amountInWei, "Not enough ETH in pool");
        require(loans[msg.sender].amount == 0, "Already has loan");

        loans[msg.sender] = Loan(amountInWei, block.timestamp + 3 days, false);
        payable(msg.sender).transfer(amountInWei);
    }

    function repay() external payable {
        Loan storage loan = loans[msg.sender];
        require(!loan.repaid, "Already repaid");
        require(msg.value >= loan.amount + (loan.amount * feeRate / 100), "Insufficient repay");

        loan.repaid = true;
        tst.transfer(msg.sender, 10 * 1e18); // reward token
    }

    function withdrawLender(address payable to, uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient");
        to.transfer(amount);
    }

    function setFeeRate(uint256 _newFee) external onlyOwner {
        feeRate = _newFee;
    }
}
