pragma solidity ^0.4.24;

import "./Safemath.sol";

library ERC20Transfer {
  using Safemath for uint;

  function transferTokens(address _from, address _to, uint _amount){
    balances[_from] = balances[_from].subtract(_amount);
    balances[_to] = balances[_to].add(_amount);
  }
}
