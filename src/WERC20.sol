// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ERC20 } from "solmate/tokens/ERC20.sol";

contract WERC20 is ERC20 {
  address public bridge;

  constructor(
    string memory name,
    string memory symbol,
    uint8 decimals,
    address _bridge
  ) ERC20(name, symbol, decimals) {
    bridge = _bridge;
  }

  modifier onlyBridge() {
    require(msg.sender == bridge, "Not bridge");
    _;
  }

  function mint(address to, uint256 amount) external onlyBridge {
    _mint(to, amount);
  }

  function burn(address from, uint256 amount) external onlyBridge {
    _burn(from, amount);
  }
}
