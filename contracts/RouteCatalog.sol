pragma solidity ^0.8.0;

import "./ScalesData.sol";
import "./RouteFactory.sol";
import "./SimpleRouteData.sol";

contract RouteCatalog {
    struct FactoryWrapper {
        RouteFactory instance;
        bool restricted;
    }

    struct RouteWrapper {
        SimpleRouteData instance;
        address addedBy;
        uint nameIndex;
    }

    address owner;
    mapping(address => bool) admin;
    mapping(address => bool) access;

    ScalesData public scalesData;
    FactoryWrapper factory;
    RouteWrapper[] public route;
    mapping(address => uint) public routeIndex;
    mapping(bytes32 => address[]) routesNamed;
    bool publicWrite;

    constructor(address _scales){
        owner = msg.sender;
        scalesData = ScalesData(_scales);
        //publicWrite = true;               // PUBLIC WRITE ACCESS - If publicWrite != access[addr] => addr has access
    }

    modifier isOwner() {
        require(msg.sender == owner,
            "You don't have permissions to do this.");
        _;
    }

    modifier isAdmin() {
        require(msg.sender == owner || admin[msg.sender],
            "You don't have permissions to do this.");
        _;
    }

    modifier restrictedAccess() {
        require( (msg.sender == owner || admin[msg.sender]) ||
            ( publicWrite != access[msg.sender] ),
            "You don't have permissions to do this.");
        _;
    }

    modifier factoryRestricted(){
        require( (msg.sender == owner || admin[msg.sender]) ||
        (factory.restricted && address(factory.instance) == msg.sender)
            || !factory.restricted,
            "This Catalog is Factory Restricted");
        _;
    }

    function assignAdmin(address _user) external isOwner() {
        require(!admin[_user],
            "This address already has admin privileges");
        admin[_user] = true;
    }

    function removeAdmin(address _user) external isOwner() {
        require(admin[_user],
            "This address does not have admin privileges");
        admin[_user] = false;
    }

    function assignFactory(address _factory, bool _restrict) external isAdmin() {
        require( RouteFactory(_factory).getScalesAddress() == address(scalesData),
            "Incompatible factory - SCALE DISCREPANCY");
        admin[address(factory.instance)] = publicWrite;
        factory.instance = RouteFactory(_factory);
        factory.restricted = _restrict;
        admin[_factory] = !publicWrite;
    }

    function toggleRestrictFactory() public isAdmin() {
        factory.restricted = !factory.restricted;
    }

    function toggleUserAccess(address _user) public isAdmin() {
        access[_user] = !(access[_user]);
    }

    function newEntry(address _routeData) external restrictedAccess() factoryRestricted() {
        // check if route already in database
        require(routeIndex[_routeData] == 0,
            "This route already exists");
        SimpleRouteData entry = SimpleRouteData(_routeData);
        (int24 _lat,)=entry.getLocation();
        // check route has location
        require(_lat != 0,
            "Invalid route. No location");

        bytes32 routeName = entry.getName();
        routesNamed[routeName].push(_routeData);
        route.push(RouteWrapper(entry, tx.origin, routesNamed[routeName].length-1));
        routeIndex[_routeData] = route.length;
    }

    function newFactoryEntry(bytes memory _name, uint8 _discipline, uint8 _scale, uint8 _grade, int24 _latitude, int32 _longitude) external restrictedAccess() {
        factory.instance.newCatalogEntry(_name, _discipline, _scale, _grade, _latitude, _longitude, address(this));
    }

    function delEntry(address _routeData) external  {
        require(routeIndex[_routeData] > 0,
            "Route not found in catalog");
        uint index = routeIndex[_routeData] - 1;
        require( route[index].addedBy == tx.origin || msg.sender == owner || admin[msg.sender],
            "You don't have permissions to do this");
        RouteWrapper memory old = route[index];
        bytes32 oldName = old.instance.getName();
        if(route.length-1 == index){
            route.pop();
            routeIndex[_routeData] = 0;
        } else{
            route[index] = route[route.length-1];
            route.pop();
            routeIndex[_routeData] = 0;
            routeIndex[address(route[index].instance)] = index+1;
        }

        if(old.nameIndex == routesNamed[oldName].length-1){
            routesNamed[oldName].pop();
        } else {
            routesNamed[oldName][old.nameIndex] = routesNamed[oldName][routesNamed[oldName].length-1];
            routesNamed[oldName].pop();
            route[index].nameIndex = old.nameIndex;
        }
    }

    function getRoutesByName(bytes memory _name) external view returns (address[] memory){
        require(routesNamed[bytes32(_name)].length > 0,
            "There are no routes with this name in this Catalog");
        return routesNamed[bytes32(_name)];
    }

    function findRoute(address _route) public view returns (bool){
        require(routeIndex[_route] != 0, "Route not found in catalog");
        return true;
    }
}
