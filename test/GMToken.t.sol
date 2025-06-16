// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {GMToken} from "src/GMToken.sol";

contract GMTokenTest is Test {
    GMToken gm;
    address user = address(0xd3ad);

    function setUp() public {
        gm = new GMToken(1_000_000 * 10 ** 6); // 6 decimals
    }

    function testInitialMintToDeployer() public {
        assertEq(gm.totalSupply(), 1_000_000 * 10 ** 6);
        assertEq(gm.balanceOf(address(this)), 1_000_000 * 10 ** 6);
    }

    function testTransfer() public {
        gm.transfer(user, 500_000 * 10 ** 6);
        assertEq(gm.balanceOf(user), 500_000 * 10 ** 6);
        assertEq(gm.balanceOf(address(this)), 500_000 * 10 ** 6);
    }

    function testRevertInsufficientBalance() public {
        vm.prank(user);
        vm.expectRevert();
        gm.transfer(address(this), 1);
    }
}
