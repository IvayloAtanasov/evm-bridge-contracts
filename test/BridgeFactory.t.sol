// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/BridgeFactory.sol";

contract MockERC20Permit is IERC20Permit {
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256, uint8, bytes32, bytes32
    ) external override {
        allowances[owner][spender] = value;
    }

    function transfer(address to, uint256 amount) external override returns (bool) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external override returns (bool) {
        require(allowances[from][msg.sender] >= value, "Insufficient allowance");
        require(balances[from] >= value, "Insufficient balance");
        allowances[from][msg.sender] -= value;
        balances[from] -= value;
        balances[to] += value;
        return true;
    }

    function mint(address to, uint256 amount) external {
        balances[to] += amount;
    }
}

contract MockWERC20Permit is IWERC20Permit {
    mapping(address => uint256) public balances;

    function mint(address to, uint256 amount) external override {
        balances[to] += amount;
    }

    function burn(address from, uint256 amount) external override {
        require(balances[from] >= amount, "Insufficient wrapped balance");
        balances[from] -= amount;
    }
}

contract BridgeFactoryTest is Test {
    BridgeFactory bridge;
    MockERC20Permit token;
    MockWERC20Permit wrapped;
    address user = address(0x1);
    address relayer = address(0x2);

    function setUp() public {
        bridge = new BridgeFactory(relayer);
        token = new MockERC20Permit();
        wrapped = new MockWERC20Permit();
        token.mint(user, 1_000_000 ether);
    }

    function testLockWithPermit() public {
        vm.prank(user);
        bridge.lockWithPermit(user, address(token), 100 ether, 1234, block.timestamp + 1 days, 0, bytes32(0), bytes32(0));
        assertEq(token.balances(user), 1_000_000 ether - 100 ether);
    }

    function testClaimWrappedOnlyRelayer() public {
        vm.prank(relayer);
        bridge.claimWrapped(user, address(wrapped), 500 ether);
        assertEq(wrapped.balances(user), 500 ether);
    }

    function testUnwrap() public {
        wrapped.mint(user, 300 ether);
        vm.prank(user);
        bridge.unwrap(address(wrapped), 300 ether, 555);
        assertEq(wrapped.balances(user), 0);
    }

    function testClaimOnlyRelayer() public {
        token.mint(address(bridge), 100 ether);
        vm.prank(relayer);
        bridge.claim(user, address(token), 100 ether);
        assertEq(token.balances(user), 1_000_000 ether + 100 ether);
    }

    function testRevertUnauthorizedClaimWrapped() public {
        vm.expectRevert("Not authorized relayer");
        bridge.claimWrapped(user, address(wrapped), 1 ether);
    }

    function testRevertUnauthorizedClaim() public {
        vm.expectRevert("Not authorized relayer");
        bridge.claim(user, address(token), 1 ether);
    }
}
