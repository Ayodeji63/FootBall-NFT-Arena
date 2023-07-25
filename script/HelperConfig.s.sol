// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address owner;
        uint256 deployerKey;
    }

    /** State Variable */
    uint256 private deployerKey;
    uint256 private constant DEFAULT_ANVIL_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    address private constant DEFAULT_ANVIL_OWNER =
        0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 31337) {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public view returns (NetworkConfig memory) {
        return
            NetworkConfig({
                owner: vm.envAddress("owner"),
                deployerKey: vm.envUint("PRIVATE_KEY")
            });
    }

    function getAnvilEthConfig() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                owner: DEFAULT_ANVIL_OWNER,
                deployerKey: DEFAULT_ANVIL_KEY
            });
    }

    function getDeployerKey() external view returns (uint256) {
        return deployerKey;
    }
}
