const {expectEvent, expectRevert, BN} = require('@openzeppelin/test-helpers');
const VoteS = artifacts.require("VoteS");
const {expect} = require('chai');

contract("VoteS", (accounts) => {

    let [bob, alice] = accounts;

    const userData1 = ["Bob", "Englishman", "Driver", true, true, 82, 34, 178];
    const userData2 = ["Alice", "Englishman", "Princess", false, false, 35, 7, 124];

    const core = ["Нравится ли Вам наш сервис?", ["Да", "Нет", "Сам ты сервис!"]];
    const maxRespondents = 1000;
    const voiceCost = 1;
    const filters = [false, "",
        false, "",
        false, false,
        false, false,
        false, 0, 500,
        true, 18, 80,
        false, 0, 255];

    beforeEach(async () => {
        this.contractInstance = await VoteS.new();
    })

    // test .createNewUser() function
    xcontext ("VoteS API .createNewUser() tests", async () => {

        // Create one user
        it("Correct creating one user", async () => {
            const rezult = await this.contractInstance.createNewUser(userData1, {from: bob});
            expect(rezult.receipt.status).to.be.true;
        })

        // Create two users with different address
        it("Correct creating two users with different address", async () => {
            const rezult_bob = await this.contractInstance.createNewUser(userData1, {from: bob});
            const rezult_alice = await this.contractInstance.createNewUser(userData2, {from: alice});
            expect(rezult_bob.receipt.status).to.be.true;
            expect(rezult_alice.receipt.status).to.be.true;
        })
    })

    // test .createNewVoteByUser() function
    context ("VoteS API .createNewVoteByUser() tests", async () => {

        // test .createNewVoteByUser() function status
        it("Correct creating new vote", async () => {
            const rezult_bob = await this.contractInstance.createNewUser(userData1, {from: bob});
            const rezult = await this.contractInstance.createNewVoteByUser(core, maxRespondents, voiceCost, filters, {from: alice});
            expect(rezult.receipt.status).to.be.true;
        })
    })
})