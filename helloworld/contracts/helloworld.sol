pragma solidity ^0.8.13;

contract Helloworld {
  function sayHello(string memory name) public pure returns (string memory) {
    return string.concat("Hello:", name);
  }
}