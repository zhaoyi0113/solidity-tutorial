const Inbox = artifacts.require("inbox");

module.exports = function(deployer) {
  deployer.deploy(Inbox);
};
