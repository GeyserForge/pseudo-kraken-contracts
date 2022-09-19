// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "./extensions/ERC721AQueryable.sol";

contract PSEUDO is ERC721AQueryable {

    bool public mintEnabled = false;
    address public deployer;
    string public baseUri;
    uint256 public constant MAX_SUPPLY = 3000;
    uint256 public constant MINT_PRICE = 0.01 ether;
    uint256 public startTokenId;
    constructor(string memory name_, string memory symbol_,
        string memory _baseUri, address[] memory initAddresses) ERC721A(name_, symbol_) {
        // @todo Mint to specific wallet addresses
        deployer = msg.sender;

        _mintERC2309(initAddresses[0], 21);
        _mintERC2309(initAddresses[1], 50);
        _mintERC2309(initAddresses[2], 21);
        _mintERC2309(initAddresses[3], 21);
        _mintERC2309(initAddresses[4], 333); // Sudo LP
        _mintERC2309(initAddresses[5], 42); // Giveaways
        _mintERC2309(initAddresses[6], 58); // Mono + Treasury
        _mintERC2309(initAddresses[7], 47); // BrocDev

        baseUri = _baseUri;
    }

    function _startTokenId() internal view override returns (uint256) {
        return startTokenId;
    }

    function updateBaseURI(string memory _baseUri) external {
        require(msg.sender == deployer, "Only deployer can update base URI");
        baseUri = _baseUri;
    }

    function toggleMintEnabled(bool toggle) external {
        require(msg.sender == deployer, "Only deployer can toggle minting");
        mintEnabled = toggle;
    }

    function setMintEnabled(string memory _baseUri) external {
        require(msg.sender == deployer, "Only deployer can set minting");
        mintEnabled = true;
        baseUri = _baseUri;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseUri;
    }

    function baseURI() public view returns (string memory) {
        return _baseURI();
    }

    function totalMinted() public view returns (uint256) {
        return _totalMinted();
    }

    function mint() external payable {
        require(msg.value >= MINT_PRICE, "Not enough ETH");
        require(totalSupply() + 1 < MAX_SUPPLY, "Max supply reached");
        require(mintEnabled, "Minting is not enabled");
        _mint(msg.sender, 1);
    }

    function mintFive() external payable {
        require(msg.value >= MINT_PRICE * 5, "Not enough ETH");
        require(totalSupply() + 5 < MAX_SUPPLY, "Max supply reached");
        require(mintEnabled, "Minting is not enabled");
        _mint(msg.sender, 5);
    }

    function mintTen() external payable {
        require(msg.value >= MINT_PRICE * 10, "Not enough ETH");
        require(totalSupply() + 10 < MAX_SUPPLY, "Max supply reached");
        require(mintEnabled, "Minting is not enabled");
        _mint(msg.sender, 10);
    }

    function withdraw() external {
        require(msg.sender == deployer, "Only owner");
        payable(msg.sender).transfer(address(this).balance);
    }
}