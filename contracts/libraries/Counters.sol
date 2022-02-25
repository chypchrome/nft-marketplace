// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./SafeMath.sol";

library Counters {
    using SafeMath for uint256; 

    //Structs in Sol allows use to access data types as properties.
    struct Counter {
     uint256 _value; 
    }   

    function current(Counter storage counter) internal view returns(uint256) {
        return counter._value;
    }

    //Always decrements by one. 
    function decrement(Counter storage counter) internal {
        counter._value = counter._value.subtraction(1);
    }

    //Always adds by one. 
    function increment(Counter storage counter) internal {
        counter._value += 1;
    }
}
//Mechanism to keep track of arithmetic changes in code. 


