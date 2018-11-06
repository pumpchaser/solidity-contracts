pragma solidity ^0.4.24;

import { ERC20Transfer } from "./ERC20Transfer.sol";
import { Safemath } from "./Safemath.sol";

// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
contract ERC20 {
  struct UserBalance{
    mapping(address => uint256) balances;
  }

  using ERC20Transfer for UserBalance;
  using Safemath for uint;

  UserBalance userBalance;

  string public name;
  string public symbol;
  uint8 public decimals;
  uint256 public totalSupply;

  address public owner;

  event Transfer(address indexed _from, address indexed _to, uint256 amount);

  constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
    owner       = msg.sender;
    name        = _name;
    symbol      = _symbol;
    decimals    = _decimals;
    totalSupply = _totalSupply.multiply(10**uint(decimals));
    userBalance.balances[owner] = totalSupply;
  }

  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }

  modifier notOwner {
    require(msg.sender != owner);
    _;
  }

  function withdrawalEth() public onlyOwner returns(bool) {
    owner.transfer(address(this).balance);
    return true;
  }

  function tokenSale() public payable notOwner returns(bool) {
    require(msg.value > 0);

    // 1eth = 1000coin
    uint256 tokenAmount = ((msg.value / 1 ether).multiply(1000)).multiply(10**uint(decimals));

    // userBalance.transferTokens(address(this), msg.sender, tokenAmount);
    ERC20Transfer.transferTokens(userBalance, address(this), msg.sender, tokenAmount);
    emit Transfer(address(this), msg.sender, tokenAmount);
    return true;
  }

  function transfer(address _to, uint256 _amount) public returns(bool) {
    uint adjustedAmount = _amount.multiply(10**uint(decimals));

    ERC20Transfer.transferTokens(userBalance, msg.sender, _to, adjustedAmount);

    emit Transfer(msg.sender, _to, adjustedAmount);
    return true;
  }

  function balanceOf(address _owner) public view returns(uint256) {
    return userBalance.balances[_owner];
  }
}
