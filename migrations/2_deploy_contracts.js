var DateTime = artifacts.require("./DateTime.sol");
var Subscriptions = artifacts.require("./Subscriptions.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(DateTime).then(function() {
      deployer.link(DateTime, Subscriptions);
      return deployer.deploy(Subscriptions, accounts[0], DateTime.address);
  });
};
