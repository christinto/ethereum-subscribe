var DateTime = artifacts.require("./DateTime.sol");
var MonthlySubscriptions = artifacts.require("./MonthlySubscriptions.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(DateTime).then(function() {
      deployer.link(DateTime, MonthlySubscriptions);
      return deployer.deploy(MonthlySubscriptions, accounts[0], DateTime.address);
  });
};
