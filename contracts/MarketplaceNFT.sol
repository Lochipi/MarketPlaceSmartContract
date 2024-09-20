// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTMarketplace is ERC721, Ownable, ReentrancyGuard{
    uint256 public nextTokenId;

    struct MarketItem {
        uint256 tokenId;
        address payable seller;
        uint256 price;
        bool isListed;
    }

    mapping(uint256 => MarketItem) public marketItems;

    // nft events
    event NFTMinted(uint256 indexed tokenId, address owner);
    event MarketItemCreated(uint256 indexed tokenId, address seller, uint256 price);
    event MarketItemSold(uint256 indexed tokenId, address buyer, uint256 price);
     event MarketItemListed(uint256 indexed tokenId, uint256 price);

    constructor() ERC721("NFT Marketplace", "NFTM") Ownable(msg.sender) {}

    // Mint a new NFT
    function mintNFT(uint256 price) external onlyOwner {
        require(price > 0, "Price must be greater than zero");
       
        uint256 newTokenId = nextTokenId;
        
        _mint(msg.sender, newTokenId);
        marketItems[newTokenId] = MarketItem(newTokenId, payable(msg.sender), price, false);

        nextTokenId++;
        
        emit NFTMinted(newTokenId, msg.sender);
    }

    // listing an NFT
    function listNFT(uint256 tokenId, uint256 price) external {
        MarketItem storage item = marketItems[tokenId];

        require(ownerOf(tokenId) == msg.sender, "Only the owner can list this NFT");
        require(price > 0, "Price must be greater than zero");

        // Mark the NFT as listed for sale
        item.isListed = true;
        item.price = price;

        emit MarketItemListed(tokenId, price);
    }

    // Buy an NFT
    function buyNFT(uint256 tokenId) external payable nonReentrant {
        MarketItem storage item = marketItems[tokenId];

        require(item.isListed, "This NFT is not listed for sale");
        require(msg.value == item.price, "Please submit the correct price");

        // Transfer ownership to the buyer
        _transfer(item.seller, msg.sender, tokenId);

        // Transfer the Ether to the seller
        item.seller.transfer(msg.value);

        // marking the item as sold
        item.isListed = false;

        emit MarketItemSold(tokenId, msg.sender, msg.value);
    }

     // Fetching a specific market item
    function getMarketItem(uint256 tokenId) external view returns (MarketItem memory) {
        return marketItems[tokenId];
    }

}
