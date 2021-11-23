// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "hardhat/console.sol";

// We define that our contract is ERC721 i.e. an NFT
contract MyEpicNFT is ERC721URIStorage{
    // Every NFT in the collection has a unique number
    // We can assign ID to each NFT with Counters
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    // When creating NFT we need to pass two things
    // A name (SquareNFT) and a token symbol (SQUARE)
    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("Waddup");
    }

    // This is the mint function
    // It will be called by users when they hit "Mint NFT" on the website
    function makeAnEpicNFT() public {
        // Get current tokenId, starts at 0
        uint256 newTokenId = _tokenIds.current();
        // Mint the NFT and send to the user with msg.sender
        _safeMint(msg.sender, newTokenId);
        // set the data of the NFT, like an image or a video
        _setTokenURI(newTokenId, "https://jsonkeeper.com/b/C4HX");
        console.log("A new NFT w/ID %s has been minted to %s", newTokenId, msg.sender);
        // increment counter for the next NFT
        _tokenIds.increment();
    }
}