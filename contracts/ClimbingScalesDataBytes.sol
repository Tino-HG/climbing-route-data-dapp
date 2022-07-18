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
contract ClimbingScalesDataBytes {
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
    function getGrade(GradingQuery memory q) external view
    checkInput( q )
    returns (bytes5 r) {
        // YDS
        if ( uint8(q.scale) == 0 ){
            return r = YDS[q.grade];
        }
        // French Numerical Grading
        else if ( uint8(q.scale) == 1 ){
            return r = bytes5(FRENCH[q.grade]);
        }
        // HUECO V Scale
        else if ( uint8(q.scale) == 2 ){
            return r = bytes5(HUECO[q.grade]);
        }
        // FontaineBleau
        else if( uint8(q.scale) == 3 ){
            return r = bytes5(FB[q.grade]);
        }
    }
}