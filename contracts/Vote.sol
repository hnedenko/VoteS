// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./safemath.sol";
import "./ownable.sol";

/// @title Vote`s data and actions
/// @author @oleh
/// @notice 
/// @dev 
contract Vote is Ownable {

    event NewVoteCreated(string question, uint cost);
    event AnswerTaken(string question, string answers);
    event VoteFilled(string question);

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

    struct Filters{
        bool isCheckedCitizenship;
        string citizenship;

        bool isCheckedProfession;
        string profession;

        bool isCheckedGender;
        bool gender;

        bool isCheckedDriversLicense;
        bool haveDriversLicense;

        bool isCheckedWeight;
        uint16 minWeight;
        uint16 maxWeight;

        bool isCheckedAge;
        uint8 minAge;
        uint8 maxAge;

        bool isCheckedHeight;
        uint8 minHeight;
        uint8 maxHeight;
    }

    Core core;
    RespondentsInfo respondentsInfo;
    Filters filters;

    mapping (string => uint) answerToRespondentsQuantity;

    /// @notice Created new vote in system
    /// @param _core Text of vote`s question and all vote`s answer options
    /// @param _maxRespondents Number of respondents to vote
    /// @param _voiceCost Reward for one respondent for voting
    /// @param _filters Filters which new vote will using for users
    constructor(Core memory _core, uint _maxRespondents, uint _voiceCost, Filters memory _filters) {
        // Initialize vote data
        core = _core;
        respondentsInfo = RespondentsInfo(_maxRespondents, 0, _voiceCost, _maxRespondents.mul(_voiceCost));
        filters = _filters;

        // Emit event about new vote in VoteS
        emit NewVoteCreated(core.question, respondentsInfo.voiceCost);
    }

    /// @notice Change vote statistics: increment one of answer option counter
    /// @param _answer Incremented answer option
    function addRespondentAnswer(string memory _answer) external {
        if (respondentsInfo.nRespondents < respondentsInfo.maxRespondents) {
            // Registr new anwer and substruct VCE from vote balance
            respondentsInfo.nRespondents.add(1);
            respondentsInfo.balance.sub(respondentsInfo.voiceCost);
            answerToRespondentsQuantity[_answer].add(1);

            // Emit event about new answer
            emit AnswerTaken(core.question, _answer);
        } else {
            // Emit event about vote filling
            emit VoteFilled(core.question);
        }
    }

    /// @notice Returns vote requirements
    /// @return Vote requirements
    function getFilters() external view returns (Filters memory) {
        return filters;        
    }

    /// @notice Test function deleted this contract
    function kill() public onlyOwner {
        address payable payableOwnerAddress = payable(address(owner));
        selfdestruct(payableOwnerAddress);
    }
}
