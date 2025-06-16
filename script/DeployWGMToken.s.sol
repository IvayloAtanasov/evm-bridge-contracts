// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/WERC20.sol";

contract DeployWGMToken is Script {
    function setUp() public {}

    function run() public {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        address bridge = 0x2aFa7663137618251C31cb58A72F3B0E2543A2e5; // TODO: bridge of chosen network
        new WERC20("Wrapped Goodmorning", "WGM", 6, bridge);

        vm.stopBroadcast();
    }
}
