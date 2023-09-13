// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract CrowdfundingEscrow {
    address public projectOwner;
    uint256 public fundingGoal;
    uint256 public deadline;
    uint256 public totalFunds;
    mapping(address => uint256) public contributions;
    bool public fundingGoalReached;
    bool public deadlineReached;

    event FundingReceived(address indexed contributor, uint256 amount);
    event FundingGoalReached(uint256 totalFunds);
    event FundsTransferred(address projectOwner, uint256 amountTransferred);
    event FundsRefunded(address contributor, uint256 amountRefunded);

    constructor(uint256 _goalInEther, uint256 _durationInMinutes) {
        projectOwner = msg.sender;
        fundingGoal = _goalInEther * 1 ether;
        deadline = block.timestamp + (_durationInMinutes * 1 minutes);
    }

    modifier onlyOwner() {
        require(msg.sender == projectOwner, "Only the project owner can perform this action");
        _;
    }

    modifier goalNotReached() {
        require(!fundingGoalReached, "The funding goal has already been reached");
        _;
    }

    modifier afterDeadline() {
        require(block.timestamp >= deadline, "The deadline has not yet been reached");
        _;
    }

    function contribute() public payable goalNotReached afterDeadline {
        require(msg.value > 0, "Contribution amount must be greater than zero");
        
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;

        emit FundingReceived(msg.sender, msg.value);

        if (totalFunds >= fundingGoal) {
            fundingGoalReached = true;
            emit FundingGoalReached(totalFunds);
        }
    }

    function withdrawFunds() public onlyOwner goalNotReached {
        require(block.timestamp >= deadline, "The deadline has not yet been reached");

        uint256 amountToTransfer = totalFunds;
        totalFunds = 0;
        fundingGoalReached = false;

        payable(projectOwner).transfer(amountToTransfer);
        emit FundsTransferred(projectOwner, amountToTransfer);
    }

    function refundContributors() public goalNotReached afterDeadline {
        require(contributions[msg.sender] > 0, "You have not contributed to this project");
        
        uint256 refundAmount = contributions[msg.sender];
        contributions[msg.sender] = 0;
        
        payable(msg.sender).transfer(refundAmount);
        emit FundsRefunded(msg.sender, refundAmount);
    }

    function getRefundAmount() public view returns (uint256) {
        return contributions[msg.sender];
    }
}
