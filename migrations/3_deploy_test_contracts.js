var RouteData = artifacts.require("./RouteData.sol");
var SimpleRouteDatav1 = artifacts.require("./SimpleRouteDatav1.sol");
var SimpleRouteDatav2 = artifacts.require("./SimpleRouteData.sol");

module.exports = function(deployer) {
  deployer.deploy(RouteData,web3.utils.fromAscii("The Nose"), 0, 0 ,24, web3.utils.fromAscii("37.73292"), web3.utils.fromAscii("-119.64025"));
  deployer.deploy(SimpleRouteDatav1,web3.utils.fromAscii("The Nose"), 0, 0 ,24, web3.utils.fromAscii("37.73292"), web3.utils.fromAscii("-119.64025"));
  deployer.deploy(SimpleRouteDatav2,web3.utils.fromAscii("The Nose"), 0, 0 ,24, 3773292, -11964025);
};