const Vote = artifacts.require("Vote");

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

module.exports = function (deployer) {
  deployer.deploy(Vote, core, maxRespondents, voiceCost, filters);
};
