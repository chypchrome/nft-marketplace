// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './interfaces/ERC165.sol';
import './interfaces/IERC721.sol';
import './Libraries/Counters.sol';


contract ERC721 is ERC165, IERC721 {
  using SafeMath for uint256;
  using Counters for Counters.Counter;

  //mapping in solidity creates a hash table of key pair values


  //mapping from token id to the owner
  mapping (uint256 => address) private _tokenOwner;
  //mapping from owner to number of tokens
  mapping (address => Counters.Counter) private _ownedTokens;
  //When sending NFT's need approval processes.
  mapping(uint256 => address) private _tokenApprovals;

  constructor () {
    _registerInterface(bytes4(keccak256('balanceOf(bytes4)')
    ^keccak256('ownerOf(bytes4)')
    ^keccak256('transferFrom(bytes4)')));
  }

  function balanceOf(address _owner) public override view returns(uint256) {
    require(_owner != address(0), "ERC721 uses a non-zero address.");
    return _ownedTokens[_owner].current();
  }

  function ownerOf(uint256 _tokenId) public override view returns(address) {
    address owner = _tokenOwner[_tokenId];
    require(owner != address(0), "ERC721 uses a non-zero address.");
    return owner;
  }


  //Does the tokenId exists already?
  function _exists(uint256 tokenId) internal view returns(bool) {
    //Setting address of NFT owner to check the mapping of the address from token owner.
    address owner = _tokenOwner[tokenId];
    return owner != address(0);
  }

  //Function is not safe because of the math. 
  //Solidity doesn't handle any mathematic overflow. 


  function _mint(address to, uint256 tokenId) internal virtual {
    //Requires the address isn't zero.
    require(to != address(0), "ERC721 needs to have an ethereum address");
    //Mint an ID that doesn't already exists.
    require(!_exists(tokenId), "ERC721, token already minted");
    //We are adding a new address with a tokenId for minting.
    _tokenOwner[tokenId] = to;
    //keeping track of each address that is minting and increment 1.
    _ownedTokens[to].increment();

    emit Transfer(address(0), to, tokenId);

  }

  function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
    //Requires
    require(_to != address(0), "Error - ERC721 transfer to the zero address.");
    require(ownerOf(_tokenId) == _from, "You dont own it dummy.");

    //1. Add token Id to new owner.
    _tokenOwner[_tokenId] = _to;
    //2. update the balance of the previous owner
    _ownedTokens[_from].decrement();
    //3. update the balance of the new owner
    _ownedTokens[_to].increment();
    //4. add the safe functionality
    //I just had them backwards for future reference.

    emit Transfer(_from, _to, _tokenId);

  }

  function transferFrom(address _from, address _to, uint256 _tokenId) public override {
    _transferFrom(_from, _to, _tokenId);
  }

  //APPROVAL

  function approve(address _to, uint256 _tokenId) public override {
    address owner = ownerOf(_tokenId);

    require(_to != owner);
    require(msg.sender == owner);
    _tokenApprovals[_tokenId] = _to;

    emit Approval(owner, _to, _tokenId);
  }


  /*

  - Minting function
  - Keep track of addresses are minting
  - NFT to point to an address
  - Keep track of Token ID's
  - Keep track of token owner addresses to token id's
  - keep track of how many tokens an owner address has
  - create an event that emits a transfer log - contract address, where it's minted to, and the ID.

  */

}
