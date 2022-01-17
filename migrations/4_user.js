const User = artifacts.require("User");
const address = "0x75519ce68a4B90Aea36dF8A95D13A38983E7049E";
const UserData = ["Alex", "Ukrainian", "Developer", true, false, 16, 27, 182];

module.exports = function (deployer) {
  deployer.deploy(User, address, UserData);
};
