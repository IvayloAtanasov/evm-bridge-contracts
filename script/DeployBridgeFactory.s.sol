// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/BridgeFactory.sol";

contract DeployBridgeFactory is Script {
  function setUp() public {}

  function run() public {
    uint256 deployer = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(deployer);

    new BridgeFactory();

    vm.stopBroadcast();
  }
}
