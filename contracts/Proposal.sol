// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/// @title The contract allows you to create proposals and vote pro / contra them
/// @author @oleh
contract Proposal {

  event NewProposalCreated(address indexed user, uint proposalNumber, string proposal);
  event UserVoted(address indexed user, uint proposalNumber, bool answer);
  
  uint proposalsCounter;
  string[] proposals;

  mapping (address=>uint) public addressToProposalNumber;
  mapping (uint=>uint) public numberProposalToAllVoices;
  mapping (uint=>uint) public numberProposalToProVoices;

  /// @notice If senders user has no proposal create them
  /// @param _proposal The text of proposal
  /// @dev Now one user cannot create more than one proposal (is it worth changing?
  function createNewProposal(string memory _proposal) external {
    require(addressToProposalNumber[msg.sender] == 0);
    proposalsCounter++;
    proposals.push(_proposal);
    addressToProposalNumber[msg.sender] = proposalsCounter;
    emit NewProposalCreated(msg.sender, proposalsCounter, _proposal);
  }

  /// @notice Send users voice "pro" if he did not vote for this proposal
  /// @param _proposalNumber Number of proposal, which voting
  /// @dev Now one user can voting more then once (is it worth changing?)
  function getUsersVoicePro(uint _proposalNumber) external {
    numberProposalToAllVoices[_proposalNumber]++;
    numberProposalToProVoices[_proposalNumber]++;
    emit UserVoted(msg.sender, _proposalNumber, true);
  }

  /// @notice Send users voice "contra" if he did not vote for this proposal
  /// @param _proposalNumber Number of proposal, which voting
  /// @dev Now one user can voting more then once (is it worth changing?)
  function getUserVoiceContra(uint _proposalNumber) external {
    numberProposalToAllVoices[_proposalNumber]++;
    emit UserVoted(msg.sender, _proposalNumber, false);
  }
}
