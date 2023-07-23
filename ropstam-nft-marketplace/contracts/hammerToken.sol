// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HammerToken is ERC20 {
    constructor() ERC20("Hammer Token", "HAMMER") {
        _mint(msg.sender, 1000000 * 10**18); // Mint 1,000,000 Hammer tokens
    }
}

contract OpenApesToken is ERC721, Ownable {
    using Strings for uint256;
    string private baseTokenURI;

    constructor(string memory _name, string memory _symbol, string memory _baseTokenURI) ERC721(_name, _symbol) {
        baseTokenURI = _baseTokenURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    function mintNFT(address to, uint256 tokenId) external onlyOwner {
        _mint(to, tokenId);
    }
}

contract RopstamNFTMarketplace is Ownable {
    HammerToken public hammerToken;
    OpenApesToken public openApesToken;
    uint256 public constant NFT_PRICE = 100 * 10**18; // 100 Ropstam tokens for NFT

    mapping(address => bool) public hasHammer;
    mapping(address => bool) public hasOpenApes;

    event NFTBought(address buyer, uint256 tokenId);

    constructor(
        string memory hammerName,
        string memory hammerSymbol,
        string memory openApesName,
        string memory openApesSymbol,
        string memory openApesBaseTokenURI
    ) {
        hammerToken = new HammerToken();
        openApesToken = new OpenApesToken(openApesName, openApesSymbol, openApesBaseTokenURI);
        addOwner(msg.sender);
    }

    modifier onlyHammerOwner() {
        require(hasHammer[msg.sender], "Only Hammer token owners can call this function");
        _;
    }

    modifier onlyOpenApesOwner() {
        require(hasOpenApes[msg.sender], "Only Open Apes token owners can call this function");
        _;
    }

    function buyNFT() external {
        require(hammerToken.balanceOf(msg.sender) >= NFT_PRICE, "Insufficient Hammer tokens");
        require(!hasOpenApes[msg.sender], "Already owns Open Apes NFT");

        hammerToken.transferFrom(msg.sender, address(this), NFT_PRICE);
        uint256 tokenId = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
        openApesToken.mintNFT(msg.sender, tokenId);
        hasOpenApes[msg.sender] = true;

        emit NFTBought(msg.sender, tokenId);
    }

    function buyHammer() external payable {
        require(msg.value == NFT_PRICE, "Incorrect Ether value for buying Hammer");
        require(!hasHammer[msg.sender], "Already owns Hammer token");

        hasHammer[msg.sender] = true;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function addOwner(address newOwner) public onlyOwner {
        hasHammer[newOwner] = false;
        hasOpenApes[newOwner] = false;
    }
}
