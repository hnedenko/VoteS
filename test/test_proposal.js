const {expectEvent, expectRevert, BN} = require('@openzeppelin/test-helpers');
const Proposal = artifacts.require("Proposal");
const {expect} = require('chai');
const GAS_LIMIT = 200000;

contract("Proposal", (accounts) => {

    let [alice, bob, carol, dave] = accounts;
    const proposals = ["Do you like green trees?", "Do you like blue sky?", "Do you like sun shine?"]

    beforeEach(async () => {
        this.contractInstance = await Proposal.new();
    })

    // Test createNewProposal()
    context ("createNewProposal() method", async () => {

        it("Positive status", async () => {
            const rezult = await this.contractInstance.createNewProposal(proposals[0], {from: alice});
            expect(rezult.receipt.status).to.be.true;
        })
        it("Expense gas", async () => {
            const rezult = await this.contractInstance.createNewProposal(proposals[0], {from: alice});
            expect(rezult.receipt.gasUsed).to.be.lessThan(GAS_LIMIT);
        })
        it("Emit events", async () => {
            const rezult = await this.contractInstance.createNewProposal(proposals[0], {from: alice});
            await expectEvent.inTransaction(rezult.tx, this.contractInstance, "NewProposalCreated");
        })
        it("Several votes for user created", async () => {
            await this.contractInstance.createNewProposal(proposals[0], {from: alice});
            await this.contractInstance.createNewProposal(proposals[1], {from: alice});
            await this.contractInstance.createNewProposal(proposals[2], {from: alice});
            expect(await this.contractInstance.proposalsCounter()).to.be.bignumber.equal(new BN(3));
        })
    })

    // Test getUsersVoicePro()
    context ("getUsersVoicePro() method", async () => {
        
        it("Positive status", async () => {
            await this.contractInstance.createNewProposal(proposals[0], {from: alice});
            const rezult = await this.contractInstance.getUsersVoicePro(1, {from: alice});
            expect(rezult.receipt.status).to.be.true;
        })
        it("Expense gas", async () => {
            await this.contractInstance.createNewProposal(proposals[0], {from: alice});
            const rezult = await this.contractInstance.getUsersVoicePro(1, {from: alice});
            expect(rezult.receipt.gasUsed).to.be.lessThan(GAS_LIMIT);
        })
        it("Emit events", async () => {
            await this.contractInstance.createNewProposal(proposals[0], {from: alice});
            const rezult = await this.contractInstance.getUsersVoicePro(1, {from: alice});
            await expectEvent.inTransaction(rezult.tx, this.contractInstance, "UserVoted");
        })
    })

    // Test getUserVoiceContra()
    context ("getUserVoiceContra() method", async () => {

        it("Positive status", async () => {
            await this.contractInstance.createNewProposal(proposals[0], {from: alice});
            const rezult = await this.contractInstance.getUserVoiceContra(1, {from: alice});
            expect(rezult.receipt.status).to.be.true;
        })
        it("Expense gas", async () => {
            await this.contractInstance.createNewProposal(proposals[0], {from: alice});
            const rezult = await this.contractInstance.getUserVoiceContra(1, {from: alice});
            expect(rezult.receipt.gasUsed).to.be.lessThan(GAS_LIMIT);
        })
        it("Emit events", async () => {
            await this.contractInstance.createNewProposal(proposals[0], {from: alice});
            const rezult = await this.contractInstance.getUserVoiceContra(1, {from: alice});
            await expectEvent.inTransaction(rezult.tx, this.contractInstance, "UserVoted");
        })
    })
})