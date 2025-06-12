// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/GMToken.sol";

contract DeployGMToken is Script {
  function setUp() public {}

  function run() public {
    uint256 deployer = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(deployer);

    uint256 initialSupply = 10_000 * 1e6;
    new GMToken(initialSupply);

    vm.stopBroadcast();
  }
}
