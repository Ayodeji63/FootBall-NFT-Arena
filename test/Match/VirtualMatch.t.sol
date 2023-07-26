// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployVirtualMatch} from "../../script/Match/DeployVirtualMatch.s.sol";
import {VirtualMatch} from "../../src/Match/VirtualMatch.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract VirtualMatchTest is Test {
    VirtualMatch virtualMatch;
    address private platformAdmin;
    uint private deployerKey;
    uint256[] public teamAPlayers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
    uint256[] public teamBPlayers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

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
}
