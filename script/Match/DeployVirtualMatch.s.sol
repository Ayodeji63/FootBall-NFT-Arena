// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {VirtualMatch} from "../../src/Match/VirtualMatch.sol";
import {HelperConfig} from "../HelperConfig.s.sol";

contract DeployVirtualMatch is Script {
    address private platformAdmin;
    uint private deployerKey;

    function run() external returns (VirtualMatch virtualMatch) {
        HelperConfig helperConfig = new HelperConfig();
        (platformAdmin, deployerKey) = helperConfig.activeNetworkConfig();
        vm.startBroadcast();
        virtualMatch = new VirtualMatch(platformAdmin);
        vm.stopBroadcast();
        return virtualMatch;
    }
}
