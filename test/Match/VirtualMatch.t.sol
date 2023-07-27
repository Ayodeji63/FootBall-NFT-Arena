// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployVirtualMatch} from "../../script/Match/DeployVirtualMatch.s.sol";
import {VirtualMatch} from "../../src/Match/VirtualMatch.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract VirtualMatchTest is Test {
    VirtualMatch virtualMatch;
    address private platformAdmin;
    address public teamA = makeAddr("teamA");
    address public teamB = makeAddr("teamB");
    uint _startTime = block.timestamp + 5;
    uint _endTime = _startTime + 30;

    uint private deployerKey;
    uint256[] public teamAPlayers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
    address[] public teamAPlayersAddress = [
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209
    ];

    uint256[] public teamBPlayers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

    address[] public teamBlayersAddress = [
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209,
        0xC3a4a1C0B5FC7cbe6c6f4D2506fFb5D459fb1209
    ];

    /** Events  */
    event MatchCreated(
        uint256 indexed matchId,
        uint256 startTime,
        uint256 endTime
    );

    function setUp() external {
        DeployVirtualMatch deployVirtualMatch = new DeployVirtualMatch();
        HelperConfig helperConfig = new HelperConfig();
        (platformAdmin, deployerKey) = helperConfig.activeNetworkConfig();
        virtualMatch = deployVirtualMatch.run();
    }

    function testPlatformAdminShouldBeCorrect() external {
        address _platformAdmin = virtualMatch.getPlatformAdmin();
        assertEq(_platformAdmin, platformAdmin);
    }

    function testProposeMatch() external {
        // Arrange
        vm.startPrank(teamA);
        vm.expectEmit(true, false, false, false, address(virtualMatch));

        // Act / Assert
        emit MatchCreated(0, _startTime, _endTime);
        virtualMatch.proposeMatch(
            _startTime,
            _endTime,
            teamAPlayers,
            teamAPlayersAddress
        );
    }
}
