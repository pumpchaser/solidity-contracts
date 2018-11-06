pragma solidity ^0.4.24;

import { Safemath } from "./Safemath.sol";

library ERC20Transfer {
  using Safemath for uint;

  struct UserBalance{
    mapping(address => uint256) balance;
  }

  function transferTokens(UserBalance storage self, address _from, address _to, uint _amount) public returns(bool) {
    require(self.balance[_from] >= _amount);

    self.balance[_from] = self.balance[_from].subtract(_amount);
    self.balance[_to]   = self.balance[_to].add(_amount);
    return true;
  }
}
