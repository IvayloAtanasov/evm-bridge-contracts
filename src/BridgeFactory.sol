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

  function transfer(address to, uint256 amount) external returns (bool);

  function transferFrom(address from, address to, uint256 value) external returns (bool);
}

interface IWERC20Permit {
  function mint(address to, uint256 amount) external;

  function burn(address from, uint256 amount) external;
}

contract BridgeFactory {
  event Locked(
    address indexed sender,
    address indexed user,
    address indexed token,
    uint256 amount,
    uint256 targetChainId
  );

  event Unlocked(
    address indexed sender,
    address indexed user,
    address indexed token,
    uint256 amount,
    uint256 targetChainId
  );

  address public relayer;

  constructor(address _relayer) {
    relayer = _relayer;
  }

  modifier onlyRelayer() {
    require(msg.sender == relayer, "Not authorized relayer");
    _;
  }

  function lockWithPermit(
    address user,
    address token,
    uint256 amount,
    uint256 targetChainId,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external {
    IERC20Permit(token).permit(
      user,
      address(this),
      amount,
      deadline,
      v,
      r,
      s
    );

    bool success = IERC20Permit(token).transferFrom(user, address(this), amount);
    require(success, "Transfer failed");

    emit Locked(msg.sender, user, token, amount, targetChainId);
  }

  function claimWrapped(address user, address wrappedToken, uint256 amount) external onlyRelayer {
    IWERC20Permit(wrappedToken).mint(user, amount);
  }

  function unwrap(
    address wrappedToken,
    uint256 amount,
    uint256 targetChainId
  ) external {
    address user = msg.sender;
    IWERC20Permit(wrappedToken).burn(user, amount);

    emit Unlocked(msg.sender, user, wrappedToken, amount, targetChainId);
  }

  function claim(address user, address token, uint256 amount) external onlyRelayer {
    IERC20Permit(token).transfer(user, amount);
  }
}
