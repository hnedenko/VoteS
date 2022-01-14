// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./User.sol";
import "./Vote.sol";
import "./safemath.sol";
import "./ownable.sol";

/// @title Main contract in DApp, contains all the logic of user interaction, votes, VCE
/// @author @oleh
/// @notice 
/// @dev 
contract VoteS is Ownable {

    event FoundMatchPoll(address indexed usedId, uint voteId);

    using SafeMath for uint;

    // Config info
    // TODO: realize as *.config file
    uint COMMISSION_PERCENTAGE = 2;
    address SYSTEM_CREATOR_ADDRESS = msg.sender;

    // Users and Votes data
    User[] private users;
    Vote[] private votes;
    uint[] private voteIds;
    
    // User`s mappings
    mapping (address => bool) private addresToInitialized;
    mapping (address => User) private addressToUser;
    mapping (address => Vote[]) private addressToPassedVotes;
 
    // Vote`s mappings
    mapping (uint => Vote) private voteIdToVote;
    mapping (uint => address) private voteIdToOwner;
    mapping (uint => uint) private voteIdToVoiceCost;
    mapping (address => Vote[]) private ownerAddressToHisVotes;

    /// @notice Created new user if system hasn`t it
    /// @return new created user
    function createNewUser(User.UserData memory _userData) external returns (User) {
        // Checking if a user is not register in system
        require(addresToInitialized[msg.sender] == false);

        User user = new User(msg.sender, _userData);

        // Seting new user address in mappings for further use
        addresToInitialized[msg.sender] = true;
        addressToUser[msg.sender] = user;
        users.push(user);

        return user;
    }

    /// @notice Created new vote by current user address
    /// @param _core Text of vote`s question and all vote`s answer options
    /// @param _maxRespondents Number of respondents to vote
    /// @param _voiceCost Reward for one respondent for voting
    /// @param _filters Filters which new vote will using for users
    /// @return new created vote
    function createNewVoteByUser(Vote.Core memory _core,
    uint _maxRespondents, uint _voiceCost,
    Vote.Filters memory _filters) external returns (Vote) {
        // Checking the availability of the necessary VCE in the creator's account
        uint userBalace = addressToUser[msg.sender].getBalance();
        uint respondentsRewards = _maxRespondents.mul(_voiceCost);
        uint commission = respondentsRewards.mul(COMMISSION_PERCENTAGE)/100;
        uint necessaryBalance = respondentsRewards + commission;

        require(userBalace >= necessaryBalance);

        // Subtracting VCE from creator's account
        addressToUser[msg.sender].subtractsVCE(necessaryBalance);

        // Sending commission to VoteS system creator
        addressToUser[SYSTEM_CREATOR_ADDRESS].receiveVCE(commission);

        // Creating vote
        Vote vote = new Vote(_core, _maxRespondents, _voiceCost, _filters);

        // Seting new vote ID in mappings for further use
        uint voteId = uint(keccak256(abi.encode(vote)));
        voteIdToVote[voteId] = vote;
        voteIdToOwner[voteId] = msg.sender;
        voteIdToVoiceCost[voteId] = _voiceCost;
        ownerAddressToHisVotes[msg.sender].push(vote);
        votes.push(vote);
        voteIds.push(voteId);

        return vote;
    }

    /// @notice Write all info about user`s voting
    /// @param _userId Address of respondent user
    /// @param _voteId Voting vote
    /// @param _answer Answer option
    function voting(address _userId, uint _voteId, string memory _answer) external {
        // Checking what user does not respond to own vote
        require(keccak256(abi.encode(_userId)) != keccak256(abi.encode(voteIdToOwner[_voteId])));
        require(_checkUsersDataForVoteRequirements(_userId, _voteId));

        // Added answer to vote`s statistics and add VCE to user`s balance
        voteIdToVote[_voteId].addRespondentAnswer(_answer);
        addressToUser[_userId].receiveVCE(voteIdToVoiceCost[_voteId]);
    }

    /// @notice Search and return all votes which filters match with user`s info
    /// @param _userId Address of user
    function getAllVoteIdsForUser(address _userId) external {
        uint nVotes = voteIds.length;
        for (uint i = 0; i < nVotes; i.add(1)) {
            if (_checkUsersDataForVoteRequirements(_userId, voteIds[i])) {
                emit FoundMatchPoll(_userId, voteIds[i]);
            }
        }
    }

    /// @notice Checks if the user matches the voting requirements
    /// @param _userId Address of respondent user
    /// @param _voteId Voting vote
    /// @return true when user can voting this vote, false in another case
    function _checkUsersDataForVoteRequirements(address _userId, uint _voteId) private view returns (bool) {
        bool conclusion = true;

        // Set info about vote`s requirements
        Vote.Filters memory filters = voteIdToVote[_voteId].getFilters();

        // Set user`s info
        User.UserData memory userData = addressToUser[_userId].getData();

        // Check all requirements
        if (filters.isCheckedCitizenship) {
            if (keccak256(abi.encode(filters.citizenship)) != keccak256(abi.encode(userData.citizenship))) {
                conclusion = false;
            }
        }
        if (filters.isCheckedProfession) {
            if (keccak256(abi.encode(filters.profession)) != keccak256(abi.encode(userData.profession))) {
                conclusion = false;
            }
        }
        if (filters.isCheckedGender) {
            if (filters.gender != userData.gender) {
                conclusion = false;
            }
        }
        if (filters.isCheckedDriversLicense) {
            if (filters.haveDriversLicense != userData.haveDriversLicense) {
                conclusion = false;
            }
        }
        if (filters.isCheckedWeight) {
            if (filters.minWeight > userData.weight || userData.weight > filters.maxWeight) {
                conclusion = false;
            }
        }
        if (filters.isCheckedAge) {
            if (filters.minAge > userData.age || userData.age > filters.maxAge) {
                conclusion = false;
            }
        }
        if (filters.isCheckedHeight) {
            if (filters.minHeight > userData.height || userData.height > filters.maxHeight) {
                conclusion = false;
            }
        }

        return conclusion;
    }

    /// @notice Test function deleted this contract
    function kill() public onlyOwner {
        address payable payableOwnerAddress = payable(address(owner));
        selfdestruct(payableOwnerAddress);
    }
}
