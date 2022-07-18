// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
pragma experimental ABIEncoderV2;

contract SimpleRouteDatav1 {

    struct Data {
        bytes32 name;
        uint8 diff;
        bytes11 lat;        // 11 cm accuracy
        bytes11 long;       //
    }

    Data data;

    constructor(bytes memory _name, uint8 _discipline, uint8 _scale, uint8 _grade, bytes memory _latitude, bytes memory _longitude) {
        require(_name.length <= 32,"Route name too long! Max length: 32");

        data.name = bytes32(_name);

        uint8 temp_diff = _discipline<<7;
        temp_diff |= _scale<<6;
        temp_diff |= _grade;
        data.diff = temp_diff;

        data.lat = bytes11(_latitude);
        data.long = bytes11(_longitude);
    }

    function getDiscipline() public view returns (bool) {
        return data.diff>>7 == 1;
    }

    function getScale() public view returns (bool) {
        return data.diff<<1>>7 == 1;
    }

    function getGrade() public view returns (uint8) {
        return data.diff<<2>>2;
    }

    function getAll() public view returns (Data memory) {
        return data;
    }
}

