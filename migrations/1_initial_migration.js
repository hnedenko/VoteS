const Proposal = artifacts.require("Proposal");

module.exports = function (deployer) {
  deployer.deploy(Proposal);
};
