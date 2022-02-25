// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './IERC165.sol';


contract ERC165 is IERC165 {

  mapping (bytes4 => bool) private _supportedInterfaces;

  constructor() {
    _registerInterface(bytes4(keccak256('supportsInterface(bytes4)')));
  }

  function supportsInterface(bytes4 interfaceId) external override view returns (bool) {
    return _supportedInterfaces[interfaceId];
  }

  function _registerInterface(bytes4 _interfaceId) internal {
    require(_interfaceId != 0xffffffff);
    _supportedInterfaces[_interfaceId] = true;
  }


}
