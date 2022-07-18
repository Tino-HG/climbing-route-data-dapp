// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
pragma experimental ABIEncoderV2;
/*  This Contract contains free climbing and bouldering grading system scales and is intended
    as a public interface exposing readable data to user facing components
*/
contract ScalesData {
    // SCALES DATA
    // Yosemite Decimal System
    bytes5[34] YDS = [
    bytes5("5.0"),
    bytes5("5.1"),
    bytes5("5.2"),
    bytes5("5.3"),
    bytes5("5.4"),
    bytes5("5.5"),
    bytes5("5.6"),
    bytes5("5.7"),
    bytes5("5.8"),
    bytes5("5.9"),
    bytes5("5.10a"),
    bytes5("5.10b"),
    bytes5("5.10c"),
    bytes5("5.10d"),
    bytes5("5.11a"),
    bytes5("5.11b"),
    bytes5("5.11c"),
    bytes5("5.11d"),
    bytes5("5.12a"),
    bytes5("5.12b"),
    bytes5("5.12c"),
    bytes5("5.12d"),
    bytes5("5.13a"),
    bytes5("5.13b"),
    bytes5("5.13c"),
    bytes5("5.13d"),
    bytes5("5.14a"),
    bytes5("5.14b"),
    bytes5("5.14c"),
    bytes5("5.14d"),
    bytes5("5.15a"),
    bytes5("5.15b"),
    bytes5("5.15c"),
    bytes5("5.15d")
    ];

    // French Numerical Grading
    bytes3[20] FRENCH = [
    bytes3("1"),
    bytes3("2"),
    bytes3("3"),
    bytes3("3+"),
    bytes3("4a"),
    bytes3("4b"),
    bytes3("4c"),
    bytes3("5a"),
    bytes3("5b"),
    bytes3("5c"),
    bytes3("6a"),
    bytes3("6a+"),
    bytes3("6b"),
    bytes3("6b+"),
    bytes3("6c"),
    bytes3("6c+"),
    bytes3("7a"),
    bytes3("7a+"),
    bytes3("7b"),
    bytes3("7b+")
    ];

    // Hueco System / V-Scale
    bytes3[19] HUECO = [
    bytes3("VB"),
    bytes3("V0"),
    bytes3("V1"),
    bytes3("V2"),
    bytes3("V3"),
    bytes3("V4"),
    bytes3("V5"),
    bytes3("V6"),
    bytes3("V7"),
    bytes3("V8"),
    bytes3("V9"),
    bytes3("V10"),
    bytes3("V11"),
    bytes3("V12"),
    bytes3("V13"),
    bytes3("V14"),
    bytes3("V15"),
    bytes3("V16"),
    bytes3("V17")
    ];

    // FontaineBleau / French Bouldering Scale
    bytes3[23] FB = [
    bytes3("3"),
    bytes3("4"),
    bytes3("5"),
    bytes3("5+"),
    bytes3("6a"),
    bytes3("6a+"),
    bytes3("6b"),
    bytes3("6b+"),
    bytes3("6c"),
    bytes3("6c+"),
    bytes3("7a"),
    bytes3("7a+"),
    bytes3("7b"),
    bytes3("7b+"),
    bytes3("7c"),
    bytes3("7c+"),
    bytes3("8a"),
    bytes3("8a+"),
    bytes3("8b"),
    bytes3("8b+"),
    bytes3("8c"),
    bytes3("8c+"),
    bytes3("9a")
    ];

    function bytes5ToString(bytes5 _bytes5) public pure returns (string memory) {
        uint8 i = 0;
        while(i < 5 && _bytes5[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 5 && _bytes5[i] != 0; i++) {
            bytesArray[i] = _bytes5[i];
        }
        return string(bytesArray);
    }

    function bytes3ToString(bytes3 _bytes3) public pure returns (string memory) {
        uint8 i = 0;
        while(i < 3 && _bytes3[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 3 && _bytes3[i] != 0; i++) {
            bytesArray[i] = _bytes3[i];
        }
        return string(bytesArray);
    }

    function getDiscipline(uint8 q) public pure returns (string memory) {
        uint8 discipline = q>>7;
        if(discipline == 0){
            return "Free Climbing";
        } else if(discipline == 1){
            return "Bouldering";
        } else{
            revert("error");
        }
    }

    function getScale(uint8 q) public pure returns (string memory) {
        uint8 discipline = q>>7;
        uint8 scale = q<<1>>7;
        if(discipline == 0){
            if(scale == 0){
                return "YDS";
            } else if(scale == 1) {
                return "French";
            } else {
                revert("error");
            }
        } else if(discipline == 1){
            if(scale == 0){
                return "Hueco";
            } else if(scale == 1) {
                return "French";
            } else {
                revert("error");
            }
        } else {
            revert("error");
        }
    }

    function getGrade(uint8 q) public view returns (string memory) {
        uint8 discipline = q>>7;
        uint8 scale = q<<1>>7;
        uint8 grade = q<<2>>2;
        if(discipline == 0){
            if(scale == 0){
                require(grade < YDS.length ,"");
                return bytes5ToString(YDS[grade]);
            } else if(scale == 1) {
                require(grade < FRENCH.length ,"");
                return bytes3ToString(FRENCH[grade]);
            } else {
                revert("error");
            }
        } else if(discipline == 1){
            if(scale == 0){
                require(grade < HUECO.length ,"");
                return bytes3ToString(HUECO[grade]);
            } else if(scale == 1) {
                require(grade < FB.length ,"");
                return bytes3ToString(FB[grade]);
            } else {
                revert("error");
            }
        } else {
            revert("error");
        }
    }

    function getAll(uint8 q) public view returns (string memory,string memory,string memory) {
        return(getDiscipline(q),getScale(q),getGrade(q));
    }
}