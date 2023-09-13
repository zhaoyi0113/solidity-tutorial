// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.18;

contract Inbox {
    string private message;
    address private owner;

    event Sent(uint256 amount);
    event SentFailed(uint256 amount);
    event ReceiveFund();

    constructor() {
        owner = msg.sender;
    }
    
    function setMessage(string memory newMessage) public {
        message = newMessage;
    }

    function getMessage() public view returns (string memory) {
        return message;
    }

    function getContactBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getSenderBalance() public view returns (uint256) {
        return address(msg.sender).balance;
    }

    function transfer(address payable recipient, uint256 amount) public payable {
        require(address(owner).balance >= amount, "Insufficient balance");
        recipient.transfer(amount);
    }

    receive() external payable {
        emit ReceiveFund();
    }

    // fallback() external payable {
    // }

    function sendEth() public payable {
        require(address(msg.sender).balance >= msg.value, "Insufficient balance");
        bool sent = payable(address(this)).send(msg.value);
        if (sent) {
            emit Sent(msg.value);
        } else {
            emit SentFailed(msg.value);
        }
    }
}
