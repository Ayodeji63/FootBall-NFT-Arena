// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {NFT_A} from "../../src/NFTs/NFT_A.sol";
import {HelperConfig} from "../HelperConfig.s.sol";

contract DeployNFT_A is Script {
    function run(address owner) external returns (NFT_A nftA) {
        HelperConfig helperConfig = new HelperConfig();
        vm.startBroadcast();
        nftA = new NFT_A(owner);
        vm.stopBroadcast();
        return nftA;
    }
}
