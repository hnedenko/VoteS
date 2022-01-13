// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./User.sol";
import "./Vote.sol";
import "./safemath.sol";

/// @title Main contract in DApp, contains all the logic of user interaction, votes, VCE
/// @author @oleh
/// @notice 
/// @dev 
contract VoteS {

    using SafeMath for uint;

    // Config info
    // TODO: realize as *.config file
    uint COMMISSION_PERCENTAGE = 2;
    address SYSTEM_CREATOR_ADDRESS = msg.sender;

    // Users and Votes data
    User[] private users;
    Vote[] private votes;
    
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
    /// @return user - new created user
    function createNewUser(string memory _name, string memory _citizenship, string memory _profession,
    bool _gender, bool _haveDriversLicense,
    uint16 _weight, uint8 _age, uint8 _height) external returns (User) {
        // Checking if a user is not register in system
        require(addresToInitialized[msg.sender] == false);

        // Creating user
        User user = new User(msg.sender, _name, _citizenship, _profession, _gender, _haveDriversLicense, _weight, _age, _height);

        // Seting new user address in mappings for further use
        addresToInitialized[msg.sender] = true;
        addressToUser[msg.sender] = user;

        return user;
    }

    /// @notice Created new vote by current user address
    /// @return vote - new created vote
    function createNewVoteByUser(string memory _question, string[] memory _answers,
    uint _maxRespondents, uint _voiceCost) external returns (Vote) {
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
        Vote vote = new Vote(_question, _answers, _maxRespondents, _voiceCost);

        // Seting new vote ID in mappings for further use
        uint voteId = uint(keccak256(abi.encode(vote)));
        voteIdToVote[voteId] = vote;
        voteIdToOwner[voteId] = msg.sender;
        voteIdToVoiceCost[voteId] = _voiceCost;
        ownerAddressToHisVotes[msg.sender].push(vote);

        return vote;
    }

    /// @notice Write all info about user`s voting
    /// @param _userId Address of respondent user
    /// @param _voteId Voting vote
    /// @param _answer Answer option
    function voting(address _userId, uint _voteId, string memory _answer) external {
        // Checking what user does not respond to own vote
        require(keccak256(abi.encode(_userId)) != keccak256(abi.encode(voteIdToOwner[_voteId])));

        // Added answer to vote`s statistics and add VCE to user`s balance
        voteIdToVote[_voteId].addRespondentAnswer(_answer, COMMISSION_PERCENTAGE);
        addressToUser[_userId].receiveVCE(voteIdToVoiceCost[_voteId]);
    }
}
