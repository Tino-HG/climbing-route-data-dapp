pragma solidity >=0.4.21 <0.7.0;
pragma experimental ABIEncoderV2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RouteData.sol";

contract TestRouteData {

  function testData() public {
    RouteData myData = RouteData(DeployedAddresses.RouteData());

    RouteData.Data memory expected = RouteData.Data(
      RouteData.Info("The Nose", RouteData.Grade(RouteData.Discipline.FREE, RouteData.Scale.YDS ,24), RouteData.Location("37.73292", "-119.64025")), ""
    );

    RouteData.Data memory result = myData.getAll();

    Assert.equal(result.info.name, expected.info.name, "Stored name data is incorrect");
    Assert.equal( uint(result.info.grade.discipline), uint(expected.info.grade.discipline), "Stored discipline data is incorrect");
    Assert.equal( uint(result.info.grade.scale), uint(expected.info.grade.scale), "Stored scale data is incorrect");
    Assert.equal( uint(result.info.grade.grade), uint(expected.info.grade.grade), "Stored grade data is incorrect");
    Assert.equal(result.info.location.latitude, expected.info.location.latitude, "Stored location data is incorrect");
    Assert.equal(result.info.location.longitude, expected.info.location.longitude, "Stored location data is incorrect");
    Assert.equal(result.description, expected.description, "Stored description data is incorrect");
  }

}
