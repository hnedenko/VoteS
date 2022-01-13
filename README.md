# VoteS
Ethereum DApp for secure creation and participation in votes

## VoteS contract realize functions:
- createNewUser
- createNewVoteByUser
- voting
- getAllVoteIdsForUser

## Prospect:
- realize ERC20 token
- realize buying VCE for ETH
- set some events arguments indexed
- add function kill() public onlyOwner {
    selfdestruct(owner());
    } to each contract