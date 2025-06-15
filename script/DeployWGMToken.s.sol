// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/WERC20.sol";

contract DeployWGMToken is Script {
  function setUp() public {}

  function run() public {
    uint256 deployer = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(deployer);

    address bridge = 0xe64c80DaC84aeE6983C3a2945a84f757e98c6B40; // TODO: bridge
    new WERC20(
      "Wrapped Goodmorning",
      "WGM",
      6,
      bridge
    );

    vm.stopBroadcast();
  }
}
