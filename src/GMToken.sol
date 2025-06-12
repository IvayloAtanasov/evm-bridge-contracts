// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "solmate/tokens/ERC20.sol";

contract GMToken is ERC20 {
  constructor(uint256 initialSupply) ERC20("Goodmorning", "GM", 6) {
    _mint(msg.sender, initialSupply);
  }
}
