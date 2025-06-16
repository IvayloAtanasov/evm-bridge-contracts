// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {WERC20} from "src/WERC20.sol";

contract WERC20Test is Test {
    WERC20 werc20;
    address bridge = address(0xBEEF);
    address user = address(0xABCD);

    function setUp() public {
        werc20 = new WERC20("Wrapped Token", "WERC", 18, bridge);
    }

    function testMintByBridge() public {
        vm.prank(bridge);
        werc20.mint(user, 100 ether);

        assertEq(werc20.balanceOf(user), 100 ether);
        assertEq(werc20.totalSupply(), 100 ether);
    }

    function testBurnByBridge() public {
        vm.prank(bridge);
        werc20.mint(user, 200 ether);

        vm.prank(bridge);
        werc20.burn(user, 50 ether);

        assertEq(werc20.balanceOf(user), 150 ether);
        assertEq(werc20.totalSupply(), 150 ether);
    }

    function testRevertMintByNonBridge() public {
        vm.expectRevert("Not bridge");
        werc20.mint(user, 1 ether);
    }

    function testRevertBurnByNonBridge() public {
        vm.prank(bridge);
        werc20.mint(user, 100 ether);

        vm.expectRevert("Not bridge");
        werc20.burn(user, 10 ether);
    }
}
