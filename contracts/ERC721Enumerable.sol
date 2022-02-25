// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enum.sol';


contract ERC721Enumerable is ERC721, IERC721Enum {

  uint256[] private _allTokens;

  //mapping from tokenId to position in _allTokens array
  mapping(uint256 => uint256) private _allTokensIndex;

  //mapping of owner to list of all owner token ids
  mapping(address => uint256[]) private _ownedTokens;

  //mapping from token ID index of the owner tokens list
  mapping(uint256 => uint256) private _ownedTokensIndex;

  constructor () {
    _registerInterface(bytes4(keccak256('totalSupply(bytes4)')
    ^keccak256('tokenByIndex(bytes4)')
    ^keccak256('tokenOfOwnerByIndex(bytes4)')
  ));

  }


//function tokenByIndex(uint256 _index) external view returns (uint256);

//function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);

function _mint(address to, uint256 tokenId) internal override(ERC721) {
  super._mint(to, tokenId);
  addTokensToAllEnumeration(tokenId);
  addTokensToOwnerEnumeration(to, tokenId);
}

//add the tokens to the array, and also set the position of the index.
function addTokensToAllEnumeration(uint256 tokenId) private {
  //tokenId added to _allTokensIndex
  _allTokensIndex[tokenId] = _allTokens.length;
  _allTokens.push(tokenId);
}

//Most of all functions are being passed the tokenId.
function addTokensToOwnerEnumeration(address owner, uint256 tokenId) private {
  //add address and tokenId to the _ownedTokens.
  //ownedTokensIndex tokenId set to address of ownedTokens position
  //Execute function with minting.

  _ownedTokens[owner].push(tokenId);
  _ownedTokensIndex[tokenId] = _ownedTokens[owner].length;
}

//returns tokenByIndex and tokenOfOwnerByIndex
function tokenByIndex(uint256 index) public view override returns(uint256) {
  //we want the index, and push through the index to allTokens
  //make sure the index is not of bounds of totalSupply
  require(index < totalSupply(), "index is out of bounds");
  return _allTokens[index];
}

function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns(uint256) {
  //make sure the index of the owner isn't out of bounds.
  require(index < balanceOf(owner));
  return _ownedTokens[owner][index];
}

function totalSupply() public view override returns(uint256) {
  return _allTokens.length;
}

}
