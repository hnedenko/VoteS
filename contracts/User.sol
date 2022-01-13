// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./safemath.sol";

/// @title User`s data and actions
/// @author @oleh
/// @notice User's personal data and actions to interact with Votes
/// @dev 
contract User {

    event NewUserCreated(string name, address account);

    using SafeMath for uint;

    struct UserData{
        string name;

        string citizenship;
        string profession;

        bool gender;
        bool haveDriversLicense;

        uint16 weight;
        uint8 age;
        uint8 height;
    }

    address account;
    UserData data;
    uint private balance;

    /// @notice Created new user in system with gived address, random data end empty balance
    /// @param _userAddres The user`s public address
    constructor(address _userAddres,
    string memory _name, string memory _citizenship, string memory _profession,
    bool _gender, bool _haveDriversLicense,
    uint16 _weight, uint8 _age, uint8 _height) {
        // Set address to account value and new user balance to 0
        account = _userAddres;
        balance = 0;

        // Set new user data
        data = UserData(_name, _citizenship, _profession, _gender, _haveDriversLicense, _weight, _age, _height);

        // Emit event, info about new user in VoteS
        emit NewUserCreated(data.name, account);
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
}
