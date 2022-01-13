// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/// @title Vote`s data and actions
/// @author @oleh
/// @notice 
/// @dev 
contract Vote {
    uint voteId;

    uint maxRespondents;
    uint nRespondents;

    uint voiceCost;

    string question;
    string[] answers;

    uint balance;
}
