// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public totalSupply = 50;
    uint256 public totalMinted = 0;

    string baseSVG = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base{fill: white;font-family: &apos;Helvetica&apos;;font-size: 18px;line-height: 24px;font-weight: 700;}</style><rect width='100%' height='100%' fill='url(#gradient-fill)'/><defs><linearGradient id='gradient-fill' x1='0' y1='0' x2='800' y2='0' gradientUnits='userSpaceOnUse'><stop offset='0' stop-color='#fc466b'/><stop offset='0.14285714285714285' stop-color='#fa377f'/><stop offset='0.2857142857142857' stop-color='#f22c94'/><stop offset='0.42857142857142855' stop-color='#e52cab'/><stop offset='0.5714285714285714' stop-color='#d135c1'/><stop offset='0.7142857142857142' stop-color='#b343d7'/><stop offset='0.8571428571428571' stop-color='#8a51eb'/><stop offset='1' stop-color='#3f5efb'/></linearGradient></defs><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["Consitute", "Organize", "Calculate", "Separate", "Establish", "Formulate"];
    string[] secondWords = ["Ambitious", "Dangerous", "Nebulous", "Enormous", "Beautiful", "Maddening"];
    string[] thirdWords = ["Employment", "Strategy", "History", "Currency", "Solution", "Surgery"];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721("Fortune Cookie NFT", "FORTUNE") {
        console.log("Find out what the future holds for you");
    }

    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory){
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory){
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory){
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256){
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNFT() public {
        require(totalMinted < totalSupply, "The Fortune Cookies are sold out. You have no future.");
        totalMinted = totalMinted + 1;

        uint256 newTokenId = _tokenIds.current();

        string memory firstWord = pickRandomFirstWord(newTokenId);
        string memory secondWord = pickRandomSecondWord(newTokenId);
        string memory thirdWord = pickRandomThirdWord(newTokenId);
        string memory combinedWord = string(abi.encodePacked(firstWord, secondWord, thirdWord));

        string memory finalSVG = string(abi.encodePacked(baseSVG, combinedWord, "</text></svg>"));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSVG)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenURI = string(abi.encodePacked("data:application/json;base64,", json));
        console.log("\n---------------------");
        console.log(finalTokenURI);
        console.log("---------------------\n");

        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, finalTokenURI);
        console.log("A new NFT w/ID %s has been minted to %s", newTokenId, msg.sender);
        
        _tokenIds.increment();

        emit NewEpicNFTMinted(msg.sender, newTokenId);
    }
}
