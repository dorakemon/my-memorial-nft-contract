//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Burnable is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // mint価格をここで定義
    // ここが最低価格になる。 0.01ETHではなく、1ETHでも可。
    uint MINT_PRICE = 1 ether;

    constructor () ERC721 ("Burnable", "BURN") {}

    // mint処理
    function mintBurnable(string memory tokenURI) public payable returns (uint256) { 
        // mint時に合わせて 0.01ether を送ってきているか確認
        require(msg.value == MINT_PRICE);

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        // 実際のmint処理
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    // 換金burn処理
    function burn(uint256 _tokenId) public { 
        // そのNFT所有者かどうか確認
        require(ownerOf(_tokenId) == msg.sender);

        // そのNFTを無に転送する (burn)
        _transfer(msg.sender, 0x000000000000000000000000000000000000dEaD, _tokenId);

        // mint時に払った0.01etherを返す処理
        address payable receiver = payable(msg.sender);
        receiver.transfer(MINT_PRICE);
    }
}
