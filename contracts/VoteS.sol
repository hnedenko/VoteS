// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./User.sol";

/// @title Main contract in DApp, contains all the logic of user interaction, votes, VCE
/// @author @oleh
/// @notice 
/// @dev 
contract VoteS {
    User[] users;
    mapping (address => bool) private addresToInitialized;

    /// @notice Created new user if system hasn`t it
    /// @return user - new created user
    function createUser(string memory _name, string memory _citizenship, string memory _profession,
    bool _gender, bool _haveDriversLicense,
    uint16 _weight, uint8 _age, uint8 _height) external returns (User) {
        require(addresToInitialized[msg.sender] == false);

        User user = new User(msg.sender, _name, _citizenship, _profession, _gender, _haveDriversLicense, _weight, _age, _height);
        addresToInitialized[msg.sender] = true;
        return user;
    }
}
