// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/// @title The contract allows you to create proposals and vote pro / contra them
/// @author @oleh
contract Proposal {

  event NewProposalCreated(address indexed user, uint proposalNumber, string proposal);
  event UserTryVoting(address indexed user, uint proposalNumber, bool answer);
  event UserVoted(address indexed user, uint proposalNumber, bool answer);
  
  uint public proposalsCounter;
  string[] public proposals;

  mapping (address=>uint[]) public addressToProposalNumbers;
  mapping (uint=>uint) public numberProposalToAllVoices;
  mapping (uint=>uint) public numberProposalToProVoices;
  mapping (bytes32=>bool) public voiceHashToVotedFact;

  /// @notice Ccreate proposal by sender
  /// @param _proposal The text of proposal
  function createNewProposal(string memory _proposal) external {
    proposalsCounter++;
    proposals.push(_proposal);
    addressToProposalNumbers[msg.sender].push(proposalsCounter);
    emit NewProposalCreated(msg.sender, proposalsCounter, _proposal);
  }

  /// @notice Send users voice "pro" if he did not vote for this proposal
  /// @param _proposalNumber Number of proposal, which voting
  function getUsersVoicePro(uint _proposalNumber) external {
    emit UserTryVoting(msg.sender, _proposalNumber, true);

    bytes32 voiceHash = keccak256(abi.encode(_proposalNumber, msg.sender));
    require(voiceHashToVotedFact[voiceHash] != true);

    numberProposalToAllVoices[_proposalNumber]++;
    numberProposalToProVoices[_proposalNumber]++;
    voiceHashToVotedFact[voiceHash] = true;
    emit UserVoted(msg.sender, _proposalNumber, true);
  }

  /// @notice Send users voice "contra" if he did not vote for this proposal
  /// @param _proposalNumber Number of proposal, which voting
  function getUserVoiceContra(uint _proposalNumber) external {
    emit UserTryVoting(msg.sender, _proposalNumber, false);

    bytes32 voiceHash = keccak256(abi.encode(_proposalNumber, msg.sender));
    require(voiceHashToVotedFact[voiceHash] != true);

    numberProposalToAllVoices[_proposalNumber]++;
    voiceHashToVotedFact[voiceHash] = true;
    emit UserVoted(msg.sender, _proposalNumber, false);
  }
}
