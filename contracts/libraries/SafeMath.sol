// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

library SafeMath {
    function addition(uint256 x, uint256 y) internal pure returns(uint256) {
        uint256 r = x + y;
        require(r >= x, "SafeMath: Addition Overflow");
        return r;
    }

    function subtraction(uint256 x, uint256 y) internal pure returns(uint256) {
        uint256 r = x - y;
        require(y <= x, "SafeMath: Subtraction Overflow");
        return r;
    }

     function multiplication(uint256 x, uint256 y) internal pure returns(uint256) {
        uint256 r = x * y;
        require(r / x == y, "SafeMath: Subtraction Overflow");
        return r;
    }

     function divide(uint256 x, uint256 y) internal pure returns(uint256) {
        uint256 r = x / y;
        require(y > 0 , "SafeMath: Division Overflow");
        return r;
    }

    function modulo(uint256 x, uint256 y) internal pure returns(uint256) {
        require(y != 0, "SafeMath: Subtraction Overflow");
        return x % y;
    }
}