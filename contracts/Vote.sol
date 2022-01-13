// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./safemath.sol";

/// @title Vote`s data and actions
/// @author @oleh
/// @notice 
/// @dev 
contract Vote {

    using SafeMath for uint;

    struct Core {
        string question;
        string[] answers;
    }

    struct RespondentsInfo {
        uint maxRespondents;
        uint nRespondents;
        uint voiceCost;
        uint balance;
    }

    Core core;
    RespondentsInfo respondentsInfo;
    address owner;
    address[] interviewedUsers;

    /// @notice Created new vote in system
    /// @param _question Text of vote`s question
    /// @param _answers Texts of all vote`s answer options
    /// @param _maxRespondents Number of respondents to vote
    /// @param _voiceCost Reward for one respondent for voting
    /// @param _owner Vote owner address
    constructor(string memory _question, string[] memory _answers, uint _maxRespondents, uint _voiceCost, address _owner) {
        core = Core(_question,_answers);
        respondentsInfo = RespondentsInfo(_maxRespondents, 0, _voiceCost, _maxRespondents.mul(_voiceCost));

        owner = _owner;
    }
}
