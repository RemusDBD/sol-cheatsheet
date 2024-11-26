// I use the exact same "example.sol" from ethereumbook Ch.13
pragma solidity ^0.4.19; 

contract example {

  address contractOwner;

  function example() {
    contractOwner = msg.sender;
  }
}
