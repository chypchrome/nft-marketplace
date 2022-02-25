// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector {

  //array to store the kryptoBirdz NFT's
  string [] public kryptoBirdz;

  mapping(string => bool) _kryptoBirdzExists;

  function mint(string memory _kryptoBird) public {
  //deprecated  uint _id = KryptoBirdz.push(_kryptoBird);
  require(!_kryptoBirdzExists[_kryptoBird], "Error - kbird already exists");

    kryptoBirdz.push(_kryptoBird);
    uint _id = kryptoBirdz.length - 1;

    _mint(msg.sender, _id);
    _kryptoBirdzExists[_kryptoBird] = true;
  }


  constructor() ERC721Connector("KryptoBird", "KBIRDZ") {
  }



}
