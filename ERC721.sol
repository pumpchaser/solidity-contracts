pragma solidity ^0.4.24;

contract ERC721 {
  mapping(uint => address) public tokenOwners;
  uint tokenCounter;

  uint public tokenPrice;
  address public owner;

  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }

  modifier exactAmount {
    require(msg.value == tokenPrice);
    _;
  }

  modifier noOverflow {
    require(tokenCounter + 1 > tokenCounter);
    _;
  }

  constructor (uint _tokenPrice) public payable {
    owner = msg.sender;
    tokenPrice = _tokenPrice;
  }

  function withdrawalEth() public onlyOwner returns(bool) {
    owner.transfer(address(this).balance);
    return true;
  }

  function buyToken() public payable exactAmount noOverflow returns(uint) {
    uint currentToken = tokenCounter;
    tokenOwners[currentToken] = msg.sender;

    tokenCounter += 1;

    return currentToken;
  }

  function transferToken(uint _tokenId, address _to) public returns(bool) {
    require(tokenOwners[_tokenId] == msg.sender);

    tokenOwners[_tokenId] = _to;

    return true;
  }
}
