pragma solidity ^0.4.19; #I use exact same example.sol from ethereumbook ch.13

contract example {

  address contractOwner;

  function example() {
    contractOwner = msg.sender;
  }
}
