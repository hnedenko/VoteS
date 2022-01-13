// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Helper.sol";
import "./safemath.sol";

/// @title User`s data and actions
/// @author @oleh
/// @notice User's personal data and actions to interact with Votes
/// @dev 
contract User is Helper {

    using SafeMath for uint;

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
    constructor(address _userAddres,
    string memory _name, string memory _citizenship, string memory _profession,
    bool _gender, bool _haveDriversLicense,
    uint16 _weight, uint8 _age, uint8 _height) {
        account = _userAddres;

        data = userData(_name, _citizenship, _profession, _gender, _haveDriversLicense, _weight, _age, _height);

        balance = 0;
    }

    /// @notice Added some VCE to user`s balance
    /// @param _nVCE Value in VCE to added to user`s balance
    function receiveVCE(uint _nVCE) external {
        require(_nVCE > 0);
        balance.add(_nVCE);
    }

    /// @notice Added some VCE to user`s balance
    /// @param _nVCE Value in VCE to added to user`s balance
    function subtractsVCE(uint _nVCE) external {
        require((_nVCE > 0) && (balance >= _nVCE));
        balance.sub(_nVCE);
    }

    /// @notice Returns current user`s balance if requests current user
    /// @return balance - current user`s balance
    function getBalance() external view returns (uint) {
        require(msg.sender == account);
        return balance;
    }
    
    /// @notice Function sent user`s voice to same possible answer
    /// @param voteId Id of vote on which user answered
    /// @param answer Number of user`s answer to Vote
    /// @return account User`s account for to take into account the one-time voting
    function toVote(uint voteId, uint8 answer) external returns (address) {
        return account;
    }
}
