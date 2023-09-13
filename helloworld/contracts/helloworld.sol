// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.18;

contract Helloworld {
  
  function sayHello(string memory name) public pure returns (string memory) {
    return string.concat("Hello:", name);
  }
}
