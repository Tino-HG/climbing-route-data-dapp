// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
pragma experimental ABIEncoderV2;

contract SimpleRouteData {

    bytes32 name;
    uint8 diff;
    int24 lat;     // 5 decimals ; 11 cm accuracy ; [-83.88608,83.88608] (within northernmost and southernmost continental points range)
    int32 long;   // 5 decimals ; 11 cm accuracy ; [-180.00000,180.00000]


    constructor(bytes memory _name, uint8 _discipline, uint8 _scale, uint8 _grade, int24 _latitude, int32 _longitude) {
        require(_name.length <= 32,"Route name too long! Max length: 32");

        name = bytes32(_name);

        uint8 temp_diff = _discipline<<7;
        temp_diff |= _scale<<6;
        temp_diff |= _grade;
        diff = temp_diff;

        lat = _latitude;
        long = _longitude;
    }

    /*function bytes32ToString(bytes32 _bytes32) public pure returns (string memory) {
        uint8 i = 0;
        while(i < 32 && _bytes32[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && _bytes32[i] != 0; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    }*/

    function getName() external view returns (bytes32){
        return name;
    }

    function getDiscipline() external view returns (uint8) {
        return diff>>7;
    }

    function getScale() external view returns (uint8) {
        return diff<<1>>7;
    }

    function getGrade() external view returns (uint8) {
        return diff<<2>>2;
    }

    function getLocation() external view returns(int24,int32) {
        return (lat,long);
    }
}

