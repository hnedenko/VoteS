// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./safemath.sol";

/// @title Vote`s data and actions
/// @author @oleh
/// @notice 
/// @dev 
contract Vote {

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
    /// @param _question Text of vote`s question
    /// @param _answers Texts of all vote`s answer options
    /// @param _maxRespondents Number of respondents to vote
    /// @param _voiceCost Reward for one respondent for voting
    constructor(string memory _question, string[] memory _answers, uint _maxRespondents, uint _voiceCost,
    bool _isCheckedCitizenship, string memory _citizenship,
    bool _isCheckedProfession, string memory _profession,
    bool _isCheckedGender, bool _gender,
    bool _isCheckedDriversLicense, bool _haveDriversLicense,
    bool _isCheckedWeight, uint16 _minWeight, uint16 _maxWeight,
    bool _isCheckedAge, uint8 _minAge, uint8 _maxAge,
    bool _isCheckedHeight, uint8 _minHeight, uint8 _maxHeight) {
        // Initialize vote data
        core = Core(_question,_answers);
        respondentsInfo = RespondentsInfo(_maxRespondents, 0, _voiceCost, _maxRespondents.mul(_voiceCost));
        filters = Filters(_isCheckedCitizenship, _citizenship,
            _isCheckedProfession, _profession,
            _isCheckedGender, _gender,
            _isCheckedDriversLicense, _haveDriversLicense, 
            _isCheckedWeight, _minWeight, _maxWeight, 
            _isCheckedAge, _minAge, _maxAge,
            _isCheckedHeight, _minHeight, _maxHeight);

        // Emit event about new vote in VoteS
        emit NewVoteCreated(_question, _voiceCost);
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
    function getFilters() external view returns (bool, string memory,
    bool, string memory,
    bool, bool,
    bool, bool,
    bool, uint16, uint16,
    bool, uint8, uint8,
    bool, uint8, uint8) {
        return (filters.isCheckedCitizenship, filters.citizenship,
            filters.isCheckedProfession, filters.profession,
            filters.isCheckedGender, filters.gender,
            filters.isCheckedDriversLicense, filters.haveDriversLicense,
            filters.isCheckedWeight, filters.minWeight, filters.maxWeight,
            filters.isCheckedAge, filters.minAge, filters.maxAge,
            filters.isCheckedHeight, filters.minHeight, filters.maxHeight);        
    }
}
