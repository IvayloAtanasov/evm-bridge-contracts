// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20Permit {
  function permit(
    address owner,
    address spender,
    uint256 value,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external;

  function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract BridgeFactory {
  event Bridged(
    address indexed user,
    address indexed token,
    uint256 amount,
    address indexed to,
    uint256 targetChainId
  );

  function lockWithPermit(
    address token,
    uint256 amount,
    address to,
    uint256 targetChainId,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external {
    IERC20Permit(token).permit(
      msg.sender,
      address(this),
      amount,
      deadline,
      v,
      r,
      s
    );

    bool success = IERC20Permit(token).transferFrom(msg.sender, address(this), amount);
    require(success, "Transfer failed");

    emit Bridged(msg.sender, token, amount, to, targetChainId);
  }
}
