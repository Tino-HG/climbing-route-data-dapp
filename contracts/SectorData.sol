// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
pragma experimental ABIEncoderV2;

import "./SimpleRouteData.sol";
import "./RouteCatalog.sol";

contract SectorData {
    mapping(address => uint256) routeIndex;

    mapping(address => bool) admin;

    bytes32 public name;

    SimpleRouteData[] public routes;
    address owner;
    address catalog;
    int32 long;
    int24 lat;


    modifier isOwner() {
        require(msg.sender == owner, "You don't have permissions to execute this function [owner]");
        _;
    }

    modifier isAdmin() {
        require(msg.sender == owner || admin[msg.sender], "You don't have permissions to execute this function [owner]");
        _;
    }
    /*
    modifier isCataloged(address _new) {
        require(RouteCatalog(catalog).routeIndex[_new] != 0, "This route could not be found in the linked catalog and and such cannot be added to this sector.");
        _;
    }
*/
    constructor(bytes memory _name, int24 _latitude, int32 _longitude, address _catalog) {
        require(_name.length <= 32,"Sector name too long! Max length: 32");
        owner = msg.sender;
        name = bytes32(_name);
        lat=_latitude;
        long=_longitude;
        catalog = _catalog;
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

    function addRoute(address _new) public isAdmin returns (uint256 n_routes){
        uint index = routeIndex[_new];
        require(index == 0, "This route is already in this Sector.");
        require(RouteCatalog(catalog).findRoute(_new), "This route could not be found in the linked catalog and as such cannot be added to this sector.");
        if (routes.length>0) require(address(routes[index]) != _new,"Route already in sector");
        routes.push(SimpleRouteData(_new));
        n_routes = routes.length;
        routeIndex[_new] = n_routes - 1;
        return n_routes;
    }

    function findRoute(address _target) public view returns (uint256 index) {
        index = routeIndex[_target];
        if (index == 0) require(address(routes[index]) == _target,"Route not found");
        return index;
    }

    function delRoute(address _rm) public isAdmin returns (uint256 n_routes){
        n_routes = routes.length;
        uint256 index = routeIndex[_rm];
        if ( index == 0 ) require(address(routes[0]) == _rm,"Route not found");
        routes[index] = routes[n_routes - 1];
        routeIndex[address(routes[index])] = index;
        routes.pop();
        n_routes--;
        return n_routes;
    }

    function delRoute_i(uint256 _index) public isOwner returns (uint256 n_routes){
        n_routes = routes.length;
        require(_index < n_routes,"Route not found");
        routes[_index] = routes[n_routes - 1];
        routeIndex[address(routes[_index])] = _index;
        routes.pop();
        n_routes--;
        return n_routes;
    }

    function getRoutes() public view returns (SimpleRouteData[] memory) {
        return routes;
    }
}
