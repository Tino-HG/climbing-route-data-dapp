pragma solidity ^0.8.8;
import "./ScalesData.sol";
import "./RouteCatalog.sol";
import "./SimpleRouteData.sol";

contract RouteFactory {
    address owner;
    ScalesData public scalesData;

    constructor(address _scales){
        owner = msg.sender;
        scalesData = ScalesData(_scales);
    }

    function getScalesAddress() external view returns (address){
        return address(scalesData);
    }

    function newRoute(bytes memory _name, uint8 _discipline, uint8 _scale, uint8 _grade, int24 _latitude, int32 _longitude) external returns (address) {
        SimpleRouteData myRoute = new SimpleRouteData(_name,_discipline, _scale, _grade, _latitude, _longitude);
        return address(myRoute);
    }

    function newCatalogEntry(bytes memory _name, uint8 _discipline, uint8 _scale, uint8 _grade, int24 _latitude, int32 _longitude, address _catalog) external {
        SimpleRouteData entry = new SimpleRouteData(_name,_discipline, _scale, _grade, _latitude, _longitude);
        RouteCatalog targetCatalog = RouteCatalog(_catalog);
        targetCatalog.newEntry(address(entry));
    }


}