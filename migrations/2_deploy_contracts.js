var ScalesData = artifacts.require("./ScalesData.sol");
var climbingScalesData = artifacts.require("./ClimbingScalesData.sol");
var climbingScalesDataBytes = artifacts.require("./ClimbingScalesDataBytes.sol");

module.exports = function(deployer) {
  deployer.deploy(ScalesData);
  deployer.deploy(climbingScalesData);
  deployer.deploy(climbingScalesDataBytes);
};
