// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/// @title Has useful functions to another contracts
/// @author @oleh
contract Helper {
    function getRandomUint(uint8 _stringLenght) view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp))) % (10**_stringLenght);
    }
}
