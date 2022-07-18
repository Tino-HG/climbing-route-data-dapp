// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
pragma experimental ABIEncoderV2;

contract RouteData {
  // Define limited user choices
  enum Discipline { FREE, BOULDER }
  enum Scale { YDS, FRENCH, HUECO, FB }

  // GPS coordinates struct
  struct Location {
    bytes11 latitude;
    bytes11 longitude;
  }

  // Discipline and difficulty scale data struct
  struct Grade {
    Discipline discipline;
    Scale scale;
    uint8 grade;
  }

  // Route Info core - the basic info all routes registered into the blockchain should have
  struct Info {
    bytes32 name;        // Route name
    Grade grade;        // Proposed discipline:scale:grade
    Location location;  // GPS location
  }

  // Complete Route data
  struct Data {
    Info info;
    string description;
  }

  Data data;
  address owner;

  constructor(bytes memory _name, uint8 _discipline, uint8 _scale, uint8 _grade, bytes memory _latitude, bytes memory _longitude) {
    require(_name.length <= 32,"Route name too long! Max length: 32");
    owner = msg.sender;
    data.info.name = bytes32(_name);
    data.info.grade = Grade(Discipline(_discipline),Scale(_scale),_grade);
    data.info.location = Location(bytes11(_latitude),bytes11(_longitude));
    data.description = "";
  }

  modifier isOwner() {
    require( msg.sender == owner
    ,"You don't have permissions to execute this function");
    _;
  }

  // Set/Replace Route Description. Max 256 characters.
  function setDescription(string memory _newd) public isOwner() {
    require(bytes(_newd).length <= 256 ,"String too long! Max length: 256");
    data.description = _newd;
  }

  function getInfo() public view returns (Info memory) {
    return data.info;
  }

  function getDescription() public view returns (string memory){
    return data.description;
  }

  function getAll() public view returns (Data memory) {
    return data;
  }
}
