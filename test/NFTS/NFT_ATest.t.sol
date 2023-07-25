// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployNFT_A} from "../../script/NFTS/DeployNFT_A.s.sol";
import {NFT_A} from "../../src/NFTs/NFT_A.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract NFT_ATest is Test {
    NFT_A nftA;
    address public to = makeAddr("to");
    address public notOwner = makeAddr("notOwner");
    address private owner;
    uint private deployerKey;
    string internal uri = "nft uri";

    /**Events  */
    event TokenMinted(address indexed to, uint256 tokenId, string uri);
    event TokenBurnt(uint indexed tokenId);

    function setUp() external {
        DeployNFT_A deployer = new DeployNFT_A();
        HelperConfig helperConfig = new HelperConfig();
        (owner, deployerKey) = helperConfig.activeNetworkConfig();
        nftA = deployer.run(owner);
    }

    function testShouldAllowMint() external {
        // Arrange
        vm.prank(owner);
        vm.expectEmit(true, false, false, false, address(nftA));
        emit TokenMinted(to, 0, "");
        nftA.safeMint(to, "");
    }

    function testShouldOnlyAllowOwnerToMint() external {
        // Arrange
        vm.prank(notOwner);
        // Act
        vm.expectRevert(NFT_A.NFTA__OnlyOwner.selector);
        nftA.safeMint(to, "");
    }

    function testShouldBurnNft() external {
        // Arrange
        vm.startPrank(owner);
        vm.expectEmit(true, false, false, false, address(nftA));
        // Act
        emit TokenBurnt(0);
        nftA.safeMint(to, "");
        nftA.burn(0);
        vm.stopPrank();
    }

    function testShouldGetTokenUri() external {
        // Arrange
        vm.startPrank(owner);
        nftA.safeMint(to, uri);

        // Act
        string memory _uri = nftA.tokenURI(0);

        // Assert
        assertEq(_uri, uri);
    }
}
