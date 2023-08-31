pragma solidity ^0.8.13;

contract Inbox {
    string private message;
    
    function setMessage(string memory newMessage) public {
        message = newMessage;
    }

    function getMessage() public view returns (string memory) {
        return message;
    }
}