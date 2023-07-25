// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title This is a NFT Contract
 * @author Olusanya Ayodeji
 * @notice This contract uses Openzeppelin
 */
contract NFT_A is ERC721, ERC721URIStorage {
    error NFTA__OnlyOwner();

    using Counters for Counters.Counter;

    /** State Variable */
    address private immutable i_owner;
    Counters.Counter private _tokenIdCounter;

    /** Events */
    event TokenMinted(address indexed to, uint256 tokenId, string uri);
    event TokenBurnt(uint indexed tokenId);

    /** Modifier */
    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert NFTA__OnlyOwner();
        }
        _;
    }

    constructor(address owner) ERC721("NFT_A", "MTK") {
        i_owner = owner;
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        emit TokenMinted(to, tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
        emit TokenBurnt(tokenId);
    }

    function burn(uint tokenId) external onlyOwner {
        _burn(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
