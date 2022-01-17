// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./safemath.sol";
import "./ownable.sol";

/// @title User`s data and actions
/// @author @oleh
/// @notice User's personal data and actions to interact with Votes
/// @dev 
contract User is Ownable {

    event NewUserCreated(string name, address indexed account);

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

    /// @notice Created new user in system with gived address, data end with 2000 EVC in balance
    /// @param _userAddres The user`s public address
    constructor(address _userAddres, UserData memory _userData) {
        // Set address to account value and new user balance to 0
        account = _userAddres;
        balance = 2000;

        // Set new user data
        data = _userData;

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
    /// @return current user`s balance
    function getBalance() external view returns (uint) {
        require(msg.sender == account);
        return balance;
    }

    /// @notice Returns user`s data
    /// @return User`s data
    function getData() external view returns (UserData memory) {
        return data;        
    }

    /// @notice Test function deleted this contract
    function kill() public onlyOwner {
        address payable payableOwnerAddress = payable(address(owner));
        selfdestruct(payableOwnerAddress);
    }
}
