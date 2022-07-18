// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
pragma experimental ABIEncoderV2;
/*  This Contract contains free climbing and bouldering grading system scales and is intended
    as a public interface exposing readable data to user facing components

    Deployment costs could be distributed with an off-chain interface which
    offsets/distributes costs to users interacting with the interface by
    creating a new (uint => string) pairing in a mapping when a grade that isn't on
    said mapping is used.
*/
contract ClimbingScalesData {
    // Define limited user choices
    enum Discipline { FREE, BOULDER }
    enum Scale { YOSEMITE, FRENCH, HUECO, FONTAINEBLEAU }

    struct GradingQuery {
        Discipline discipline;
        Scale scale;
        uint8 grade;
    }

    // SCALES DATA
    // Yosemite Decimal System
    string[34] YDS = [
        "5.0",
        "5.1",
        "5.2",
        "5.3",
        "5.4",
        "5.5",
        "5.6",
        "5.7",
        "5.8",
        "5.9",
        "5.10a",
        "5.10b",
        "5.10c",
        "5.10d",
        "5.11a",
        "5.11b",
        "5.11c",
        "5.11d",
        "5.12a",
        "5.12b",
        "5.12c",
        "5.12d",
        "5.13a",
        "5.13b",
        "5.13c",
        "5.13d",
        "5.14a",
        "5.14b",
        "5.14c",
        "5.14d",
        "5.15a",
        "5.15b",
        "5.15c",
        "5.15d"
    ];

    // French Numerical Grading
    string[20] FRENCH = [
        "1",
        "2",
        "3",
        "3+",
        "4a",
        "4b",
        "4c",
        "5a",
        "5b",
        "5c",
        "6a",
        "6a+",
        "6b",
        "6b+",
        "6c",
        "6c+",
        "7a",
        "7a+",
        "7b",
        "7b+"
    ];

    // Hueco System / V-Scale
    string[19] HUECO = [
        "VB",
        "V0",
        "V1",
        "V2",
        "V3",
        "V4",
        "V5",
        "V6",
        "V7",
        "V8",
        "V9",
        "V10",
        "V11",
        "V12",
        "V13",
        "V14",
        "V15",
        "V16",
        "V17"
    ];

    // FontaineBleau / French Bouldering Scale
    string[23] FB = [
        "3",
        "4",
        "5",
        "5+",
        "6a",
        "6a+",
        "6b",
        "6b+",
        "6c",
        "6c+",
        "7a",
        "7a+",
        "7b",
        "7b+",
        "7c",
        "7c+",
        "8a",
        "8a+",
        "8b",
        "8b+",
        "8c",
        "8c+",
        "9a"
    ];

    // Input validation functions
    // Returns true if the chosen discipline is within the available range of choices
    function checkDiscipline(Discipline _discipline) private pure returns (bool) {
        return ( _discipline <= type(Discipline).max);
    }

    // Returns true if the given scale corresponds to the chosen discipline
    function checkScale(Discipline _discipline, Scale _scale) private pure returns (bool) {
        // Free Climbing Scales
        if ( uint8(_discipline) == 0 ) {
            // YDS Scale & French Scale
            if ( uint8(_scale) == 0 || uint8(_scale) == 1 ) return true;
        }
        // Boulder Scales
        else if ( uint8(_discipline) == 1) {
            // V Scale & FontaineBleau Scale
            if ( uint8(_scale) == 2 || uint8(_scale) == 3 ) return true;
        }
        return false;
    }

    // Returns true if the chosen grade is within the range of the chosen scale
    function checkGrade(Scale _scale, uint8 _grade) private view returns (bool) {
        // YDS
        if ( uint8(_scale) == 0 ){
            if ( _grade < YDS.length) return true;
        }
        // French Numerical Grading
        else if ( uint8(_scale) == 1 ){
            if (_grade < FRENCH.length) return true;
        }
        // HUECO V Scale
        else if ( uint8(_scale) == 2 ){
            if (_grade < HUECO.length) return true;
        }
        // FontaineBleau
        else if( uint8(_scale) == 3 ){
            if (_grade < FB.length) return true;
        }
        return false;
    }

    modifier checkInput(GradingQuery memory q) {
        require( checkDiscipline( q.discipline )
        ,'Invalid choice for DISCIPLINE' );
        require( checkScale( q.discipline, q.scale )
        ,'Invalid choice for SCALE' );
        require( checkGrade( q.scale, q.grade )
        ,'Invalid choice for GRADE' );
        _;
    }

    // Get user readable grade data (string) for a specified grade in a chosen scale corresponding to a chosen discipline
    function getGrade(GradingQuery memory q) public view
    checkInput( q )
    returns (string memory r) {
        // YDS
        if ( uint8(q.scale) == 0 ){
            return r = YDS[q.grade];
        }
        // French Numerical Grading
        else if ( uint8(q.scale) == 1 ){
            return r = FRENCH[q.grade];
        }
        // HUECO V Scale
        else if ( uint8(q.scale) == 2 ){
            return r = HUECO[q.grade];
        }
        // FontaineBleau
        else if( uint8(q.scale) == 3 ){
            return r = FB[q.grade];
        }
    }
}