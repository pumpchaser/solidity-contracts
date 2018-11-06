pragma solidity ^0.4.24;

import { Safemath } from "./Safemath.sol";

library ERC20Transfer {
  using Safemath for uint;

  struct UserBalance{
    mapping(address => uint256) balances;
  }

  function transferTokens(UserBalance storage self, address _from, address _to, uint _amount) public returns(bool) {
    require(self.balances[_from] >= _amount);

    self.balances[_from] = self.balances[_from].subtract(_amount);
    self.balances[_to]   = self.balances[_to].add(_amount);
    return true;
  }
}
