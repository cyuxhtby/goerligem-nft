// SPDX-License-Identifier: UNLICENSED

// $$$$$$\                                $$\ $$\        $$$$$$\                                    
//$$  __$$\                               $$ |\__|      $$  __$$\                                   
//$$ /  \__| $$$$$$\   $$$$$$\   $$$$$$\  $$ |$$\       $$ /  \__| $$$$$$\  $$$$$$\$$$$\   $$$$$$$\ 
//$$ |$$$$\ $$  __$$\ $$  __$$\ $$  __$$\ $$ |$$ |      $$ |$$$$\ $$  __$$\ $$  _$$  _$$\ $$  _____|
//$$ |\_$$ |$$ /  $$ |$$$$$$$$ |$$ |  \__|$$ |$$ |      $$ |\_$$ |$$$$$$$$ |$$ / $$ / $$ |\$$$$$$\  
//$$ |  $$ |$$ |  $$ |$$   ____|$$ |      $$ |$$ |      $$ |  $$ |$$   ____|$$ | $$ | $$ | \____$$\ 
//\$$$$$$  |\$$$$$$  |\$$$$$$$\ $$ |      $$ |$$ |      \$$$$$$  |\$$$$$$$\ $$ | $$ | $$ |$$$$$$$  |
// \______/  \______/  \_______|\__|      \__|\__|       \______/  \_______|\__| \__| \__|\_______/ 
                                                                                                  
                                                                                                                                                                                            
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract GoerliGemNFT is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint256 constant MAX_SUPPLY = 100;

    uint256 constant MAX_PER_MINT = 1;

    uint256 constant PRICE = 0;

    uint256 mintedCount;

    mapping(address => bool) public addressOwnsNFT;

    string IPFS_PATH = "bafybeigaj6zyoke7vu2qska4alarog5qjilveoows3eueladzyepej45fa/";

    constructor() ERC721("Goerli Gems", "GGEM") {
        _tokenIdCounter.increment();
        mintedCount = 0;
    }

function mint(uint256 nTokens) public {
require(nTokens == 1, "You can only claim one");
   mintHelper(msg.sender);

}

   /**
 * Mints a new NFT and assigns it to the given address
 *  
 * @param to The address to assign the NFT to
 */
function mintHelper(address to)  {
    require(to != address(0), "Invalid address");
    // Ensure that the recipient address does not already own an NFT
    require(!addressOwnsNFT[to], "Account already owns an NFT");
    // Mint a single NFT for the recipient address
    uint256 tokenId = _tokenIdCounter.current();
    addressOwnsNFT[to] = true;
    _mint(to, tokenId);
    _tokenIdCounter.increment();
    mintedCount++;
}

    // Overrides
    /**
     * Returns the base URI for the NFT
     */
function _baseURI() internal view virtual override returns (string memory) {
        return IPFS_PATH;
}

function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
    // Ensure that the caller is the owner of the NFT being burned
    require(_ownerOf(tokenId) == msg.sender, "Only the owner can burn this NFT");
    super._burn(tokenId);
}
/**
 * Returns the URI of the given NFT
 *
 * @param tokenId The ID of the NFT
 */
function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
    _requireMinted(tokenId);
    string memory baseURI = _baseURI();
    return bytes(baseURI).length > 0 ? string(abi.encodePacked("ipfs://", baseURI, Strings.toString(tokenId), ".json")) : "";
}

/**
 * Returns the maximum supply 
 */
function maxSupply() public pure returns (uint256) {
    return MAX_SUPPLY;
}

/**
 * Returns the total supply of NFTs minted
 */
function totalSupply() public view returns (uint256) {
    return mintedCount;
}

/**
 * Returns the price of the NFT
 */
function getPrice() public pure returns (uint256) {
    return PRICE;
}

/**
 * Returns one
 */
function maxPerMint() public pure returns (uint256){
    return MAX_PER_MINT;
}

}
