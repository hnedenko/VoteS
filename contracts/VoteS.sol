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

    User[] private users;
    Vote[] private votes;
    mapping (address => bool) private addresToInitialized;
    mapping (address => User) private addressToUser;
 
    mapping (uint => Vote) private voteIdToVote;
    mapping (address => Vote[]) private userAddressToHisVotes;

    /// @notice Created new user if system hasn`t it
    /// @return user - new created user
    function createNewUser(string memory _name, string memory _citizenship, string memory _profession,
    bool _gender, bool _haveDriversLicense,
    uint16 _weight, uint8 _age, uint8 _height) external returns (User) {
        require(addresToInitialized[msg.sender] == false);

        User user = new User(msg.sender, _name, _citizenship, _profession, _gender, _haveDriversLicense, _weight, _age, _height);
        addresToInitialized[msg.sender] = true;
        addressToUser[msg.sender] = user;
        return user;
    }

    /// @notice Created new vote by current user address
    /// @return vote - new created vote
    function createNewVoteByUser(string memory _question, string[] memory _answers,
    uint _maxRespondents, uint _voiceCost) external returns (Vote) {
        uint userBalace = addressToUser[msg.sender].getBalance();
        uint necessaryBalance = _maxRespondents.mul(_voiceCost);

        require(userBalace >= necessaryBalance);

        Vote vote = new Vote(_question, _answers, _maxRespondents, _voiceCost);

        uint voteId = uint(keccak256(abi.encode(vote)));

        voteIdToVote[voteId] = vote;
        userAddressToHisVotes[msg.sender].push(vote);

        return vote;
    }
}
