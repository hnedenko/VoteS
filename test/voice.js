const Voice = artifacts.require("Voice");
contract("Voice", (accounts) => {
    let [alice, bob] = accounts;

    it("Should be able to test addad two numbers", async () => {
        const contractInstance = await Voice.new();
        const result = await contractInstance.totalSupply(1, 2, {from: alice});
        assert.equal(result.receipt.status, true);
    })
})
