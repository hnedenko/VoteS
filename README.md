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
- add
function kill() public onlyOwner {
    selfdestruct(owner());
    } to each contract