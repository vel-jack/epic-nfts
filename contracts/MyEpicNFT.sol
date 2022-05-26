// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    string svgPartOne =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo =
        "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = [
        "God",
        "Lord",
        "Almighty",
        "Gaurdian",
        "Angel",
        "Ape"
    ];
    string[] secondWords = ["Is", "Not", "Saves", "Helps", "Drops", "Kills"];
    string[] thirdWords = [
        "You",
        "Me",
        "All",
        "Them",
        "Us",
        "Horse",
        "Sheep",
        "Earth",
        "Future",
        "Life"
    ];
    string[] colors = [
        "red",
        "#08C2A8",
        "black",
        "darkslategray",
        "blue",
        "green"
    ];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("This is my First NFT Contract");
    }

    function getTotalNFTsMintedSoFar() public view returns (uint256) {
        return _tokenIds.current();
    }

    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
        );
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function pickRandomColor(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("COLOR", Strings.toString(tokenId)))
        );
        rand = rand % colors.length;
        return colors[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnNFT() public {
        uint256 newTokenId = _tokenIds.current();
        require(newTokenId < 50, "Too late to mint");
        string memory f = pickRandomFirstWord(newTokenId);
        string memory s = pickRandomSecondWord(newTokenId);
        string memory t = pickRandomThirdWord(newTokenId);
        string memory newWord = string(abi.encodePacked(f, s, t));
        string memory randomColor = pickRandomColor(newTokenId);

        string memory finalSvg = string(
            abi.encodePacked(
                svgPartOne,
                randomColor,
                svgPartTwo,
                newWord,
                "</text></svg>"
            )
        );
        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name":"',
                newWord,
                '","description":"Everyone know this ',
                newWord,
                '","image":"data:image/svg+xml;base64,',
                Base64.encode(bytes(finalSvg)),
                '"}'
            )
        );
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        console.log(finalTokenUri, "\n");
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, finalTokenUri);
        _tokenIds.increment();
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newTokenId,
            msg.sender
        );
        emit NewEpicNFTMinted(msg.sender, newTokenId);
    }
}
