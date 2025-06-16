// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/WERC20.sol";

contract DeployWGMToken is Script {
    function setUp() public {}

    function run() public {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        address bridge = 0x554645F69ac6de11ba3A682f3f76D2221F0BF80C; // TODO: bridge of chosen network
        new WERC20("Wrapped Goodmorning", "WGM", 6, bridge);

        vm.stopBroadcast();
    }
}
