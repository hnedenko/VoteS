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
            const rezult = await this.contractInstance.createNewProposal(proposals[0], new BN(5), {from: alice});
            expect(rezult.receipt.status).to.be.true;
        })
        it("Expense gas", async () => {
            const rezult = await this.contractInstance.createNewProposal(proposals[0], new BN(5), {from: alice});
            expect(rezult.receipt.gasUsed).to.be.lessThan(GAS_LIMIT);
        })
        it("Emit events", async () => {
            const rezult = await this.contractInstance.createNewProposal(proposals[0], new BN(5), {from: alice});
            await expectEvent.inTransaction(rezult.tx, this.contractInstance, "NewProposalCreated");
        })
        it("Several votes for user created", async () => {
            await this.contractInstance.createNewProposal(proposals[0], new BN(5), {from: alice});
            await this.contractInstance.createNewProposal(proposals[1], new BN(5), {from: alice});
            await this.contractInstance.createNewProposal(proposals[2], new BN(5), {from: alice});
            expect(await this.contractInstance.proposalsCounter()).to.be.bignumber.equal(new BN(3));
        })
    })

    // Test getUsersVoicePro()
    context ("getUsersVoicePro() method", async () => {
        
        it("Positive status", async () => {
            await this.contractInstance.createNewProposal(proposals[0], new BN(5), {from: alice});
            const rezult = await this.contractInstance.getUsersVoicePro(1, {from: alice});
            expect(rezult.receipt.status).to.be.true;
        })
        it("Expense gas", async () => {
            await this.contractInstance.createNewProposal(proposals[0], new BN(5), {from: alice});
            const rezult = await this.contractInstance.getUsersVoicePro(1, {from: alice});
            expect(rezult.receipt.gasUsed).to.be.lessThan(GAS_LIMIT);
        })
        it("Emit events about voting", async () => {
            await this.contractInstance.createNewProposal(proposals[0], new BN(5), {from: alice});
            const rezult = await this.contractInstance.getUsersVoicePro(1, {from: alice});
            await expectEvent.inTransaction(rezult.tx, this.contractInstance, "UserTryVoting");
            await expectEvent.inTransaction(rezult.tx, this.contractInstance, "UserVoted");
        })
        it("First vote increases 'pro' and 'all' voices counters", async () => {
            await this.contractInstance.createNewProposal(proposals[0], new BN(5), {from: alice});
            await this.contractInstance.getUsersVoicePro(new BN(1), {from: alice});
            expect(await this.contractInstance.numberProposalToProVoices(new BN(1))).to.be.bignumber.equal(new BN(1));
            expect(await this.contractInstance.numberProposalToAllVoices(new BN(1))).to.be.bignumber.equal(new BN(1));
        })
        it("Second votes trying doesn`t increases 'pro' and 'all' voices counters", async () => {
            await this.contractInstance.createNewProposal(proposals[0], new BN(5), {from: alice});
            await this.contractInstance.getUsersVoicePro(new BN(1), {from: alice});
            try {
                await this.contractInstance.getUsersVoicePro(new BN(1), {from: alice});
            } catch {}
            
            expect(await this.contractInstance.numberProposalToProVoices(new BN(1))).to.be.bignumber.equal(new BN(1));
            expect(await this.contractInstance.numberProposalToAllVoices(new BN(1))).to.be.bignumber.equal(new BN(1));
        })
        it("Second vote for another user increases 'pro' and 'all' voices counters", async () => {
            await this.contractInstance.createNewProposal(proposals[0], new BN(5), {from: alice});
            await this.contractInstance.getUsersVoicePro(new BN(1), {from: alice});
            await this.contractInstance.getUsersVoicePro(new BN(1), {from: bob});
            
            expect(await this.contractInstance.numberProposalToProVoices(new BN(1))).to.be.bignumber.equal(new BN(2));
            expect(await this.contractInstance.numberProposalToAllVoices(new BN(1))).to.be.bignumber.equal(new BN(2));
        })
        it("Users can`t voting more then indicated in the vote", async () => {
            await this.contractInstance.createNewProposal(proposals[0], new BN(3), {from: alice});
            await this.contractInstance.getUsersVoicePro(new BN(1), {from: alice});
            await this.contractInstance.getUsersVoicePro(new BN(1), {from: bob});
            await this.contractInstance.getUsersVoicePro(new BN(1), {from: carol});
            expect(await this.contractInstance.numberProposalToAllVoices(new BN(1))).to.be.bignumber.equal(new BN(3));
            try {
                await this.contractInstance.getUsersVoicePro(new BN(1), {from: dave});
            } catch {

            }
            expect(await this.contractInstance.numberProposalToAllVoices(new BN(1))).to.be.bignumber.equal(new BN(3));
        })
        it("Emit event about finish proposal", async () => {
            await this.contractInstance.createNewProposal(proposals[0], new BN(3), {from: alice});
            await this.contractInstance.getUsersVoicePro(new BN(1), {from: alice});
            await this.contractInstance.getUsersVoicePro(new BN(1), {from: bob});
            const rezult = await this.contractInstance.getUsersVoicePro(new BN(1), {from: carol});
            await expectEvent.inTransaction(rezult.tx, this.contractInstance, "ProposalFinished");
        })
    })

    // Test getUserVoiceContra()
    context ("getUserVoiceContra() method", async () => {

        it("Positive status", async () => {
            await this.contractInstance.createNewProposal(proposals[0], new BN(5), {from: alice});
            const rezult = await this.contractInstance.getUserVoiceContra(1, {from: alice});
            expect(rezult.receipt.status).to.be.true;
        })
        it("Expense gas", async () => {
            await this.contractInstance.createNewProposal(proposals[0], new BN(5), {from: alice});
            const rezult = await this.contractInstance.getUserVoiceContra(1, {from: alice});
            expect(rezult.receipt.gasUsed).to.be.lessThan(GAS_LIMIT);
        })
        it("Emit events", async () => {
            await this.contractInstance.createNewProposal(proposals[0], new BN(5), {from: alice});
            const rezult = await this.contractInstance.getUserVoiceContra(1, {from: alice});
            await expectEvent.inTransaction(rezult.tx, this.contractInstance, "UserVoted");
        })
        it("First vote increases 'all' voices counter", async () => {
            await this.contractInstance.createNewProposal(proposals[0], new BN(5), {from: alice});
            await this.contractInstance.getUserVoiceContra(new BN(1), {from: alice});
            expect(await this.contractInstance.numberProposalToAllVoices(new BN(1))).to.be.bignumber.equal(new BN(1));
        })
        it("First vote doesn`t increases 'pro' voices counter", async () => {
            await this.contractInstance.createNewProposal(proposals[0], new BN(5), {from: alice});
            await this.contractInstance.getUserVoiceContra(new BN(1), {from: alice});
            expect(await this.contractInstance.numberProposalToProVoices(new BN(1))).to.be.bignumber.equal(new BN(0));
        })
        it("Second votes trying doesn`t increases 'pro' and 'all' voices counter", async () => {
            await this.contractInstance.createNewProposal(proposals[0], new BN(5), {from: alice});
            await this.contractInstance.getUserVoiceContra(new BN(1), {from: alice});
            try {
                await this.contractInstance.getUserVoiceContra(new BN(1), {from: alice});
            } catch {}
            
            expect(await this.contractInstance.numberProposalToProVoices(new BN(1))).to.be.bignumber.equal(new BN(0));
            expect(await this.contractInstance.numberProposalToAllVoices(new BN(1))).to.be.bignumber.equal(new BN(1));
        })
        it("Second vote for another user increases 'all' voices counter", async () => {
            await this.contractInstance.createNewProposal(proposals[0], new BN(5), {from: alice});
            await this.contractInstance.getUserVoiceContra(new BN(1), {from: alice});
            await this.contractInstance.getUserVoiceContra(new BN(1), {from: bob});
            
            expect(await this.contractInstance.numberProposalToAllVoices(new BN(1))).to.be.bignumber.equal(new BN(2));
        })
        it("Second vote for another user doesn`t increases 'pro' voices counter", async () => {
            await this.contractInstance.createNewProposal(proposals[0], new BN(5), {from: alice});
            await this.contractInstance.getUserVoiceContra(new BN(1), {from: alice});
            await this.contractInstance.getUserVoiceContra(new BN(1), {from: bob});
            
            expect(await this.contractInstance.numberProposalToProVoices(new BN(1))).to.be.bignumber.equal(new BN(0));
        })
        it("Users can`t voting more then indicated in the vote", async () => {
            await this.contractInstance.createNewProposal(proposals[0], new BN(3), {from: alice});
            await this.contractInstance.getUserVoiceContra(new BN(1), {from: alice});
            await this.contractInstance.getUserVoiceContra(new BN(1), {from: bob});
            await this.contractInstance.getUserVoiceContra(new BN(1), {from: carol});
            expect(await this.contractInstance.numberProposalToAllVoices(new BN(1))).to.be.bignumber.equal(new BN(3));
            try {
                await this.contractInstance.getUserVoiceContra(new BN(1), {from: dave});
            } catch {

            }
            expect(await this.contractInstance.numberProposalToAllVoices(new BN(1))).to.be.bignumber.equal(new BN(3));
        })
        it("Emit event about finish proposal", async () => {
            await this.contractInstance.createNewProposal(proposals[0], new BN(3), {from: alice});
            await this.contractInstance.getUserVoiceContra(new BN(1), {from: alice});
            await this.contractInstance.getUserVoiceContra(new BN(1), {from: bob});
            const rezult = await this.contractInstance.getUserVoiceContra(new BN(1), {from: carol});
            await expectEvent.inTransaction(rezult.tx, this.contractInstance, "ProposalFinished");
        })
    })
})