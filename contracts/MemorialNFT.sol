//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Burnable is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  uint256 MINT_PRICE = 0.5 ether;

  mapping(address => uint256) public ownerNFTCount;

  constructor() ERC721("Burnable", "BURN") {}

  function mintBurnable(string memory tokenURI)
    public
    payable
    returns (uint256)
  {
    require(msg.value == MINT_PRICE);

    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();

    _mint(msg.sender, newItemId);
    _setTokenURI(newItemId, tokenURI);

    ownerNFTCount[msg.sender]++;

    return newItemId;
  }

  function burn(uint256 _tokenId) public {
    require(ownerOf(_tokenId) == msg.sender);

    // burn nft
    _transfer(msg.sender, 0x000000000000000000000000000000000000dEaD, _tokenId);

    // pay back
    address payable receiver = payable(msg.sender);
    receiver.transfer(MINT_PRICE);
    ownerNFTCount[msg.sender]--;
  }

  function getTokenIdBySender() public view returns (uint256[] memory) {
    uint256[] memory result = new uint256[](ownerNFTCount[msg.sender]);
    uint256 counter = 0;
    for (uint256 i = 1; i <= _tokenIds.current(); i++) {
      if (ownerOf(i) == msg.sender) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }
}
