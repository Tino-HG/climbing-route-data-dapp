var climbingScalesDataBytes = artifacts.require("./ClimbingScalesDataBytes.sol");
var RouteCatalog = artifacts.require("./RouteCatalog.sol");
var RouteFactory = artifacts.require("./RouteFactory.sol");

module.exports = function(deployer) {
    deployer.deploy(climbingScalesDataBytes).then(async () => {
        const scaleInstance = await climbingScalesDataBytes.deployed();
        await deployer.deploy(RouteCatalog, scaleInstance.address);
        await deployer.deploy(RouteFactory, scaleInstance.address);
    }).then(async () => {
        let catalogInstance = await RouteCatalog.deployed();
    });
};