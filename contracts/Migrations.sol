// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Proposal {
  uint proposalsCounter;
  string[] proposals;

  mapping (address=>uint) public addressToProposalNumber;
  mapping (uint=>uint) public numberProposalToAllVoices;
  mapping (uint=>uint) public numberProposalToProVoices;

  function createNewProposal(string memory _proposal) external {

  }

  function getUsersVoicePro() external {

  }

  function getUserVoiceContra() external {

  }
}
