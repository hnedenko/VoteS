// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Helper.sol";

/// @title User`s data and actions
/// @author @oleh
/// @notice User's personal data and actions to interact with Votes
/// @dev 
contract User is Helper {

    struct userData{
        string name;

        string citizenship;
        string profession;

        bool gender;
        bool haveDriversLicense;

        uint16 weight;
        uint8 age;
        uint8 height;
    }

    address public account;
    userData public data;
    uint private balance;

    /// @notice Created new user in system with gived address, random data end empty balance
    /// @param _userAddres The user`s public address
    constructor(address _userAddres) {
        account = _userAddres;

        string memory rndName;
        string memory rndCitizenship;
        string memory rndProfession;
        bool rndGender;
        bool rndHaveDriversLicense;
        uint16 rndWeight = getRandomUint(10);
        uint8 rndAge;
        uint8 rndHeight;
        data = userData();

        balance = 0;
    }
    
    /// @notice Function sent user`s voice to same possible answer
    /// @param answer Number of user`s answer to votes question
    function toVote(uint8 answer) external {

    }
}
