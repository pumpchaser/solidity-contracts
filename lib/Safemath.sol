pragma solidity ^0.4.24;

library Safemath {
  function add(uint _a, uint _b) public pure returns (uint){
    // require(2**256 - 1 - _a > _b);
    uint sum = _a + _b;
    require(sum >= _a && sum >= _b);
    return sum;
  }

  function subtract(uint _a, uint _b) public pure returns (uint){
    require( _a >= _b );
    return _a - _b;
  }

  function multiply(uint _a, uint _b) public pure returns (uint){
    uint product = _a * _b;
    require(product/_a == _b);

    return product;
  }

  function divide(uint _a, uint _b) public pure returns (uint){
    require( _b != 0 );
    return _a / _b;
  }
}
