// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {BaseDevToken} from "../src/BaseDevToken.sol";

contract BaseDevTokenTest is Test {
    BaseDevToken token;
    address owner;
    address user1;
    address user2;

    error BaseDevToken__InvalidAddress();
    error BaseDevToken__InsufficientBalance();
    error BaseDevToken__ZeroAmount();

    uint256 initialSupply = 1000 * 10**18; // 1000 tokens with 18 decimals

    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        token = new BaseDevToken(initialSupply);
    }

    function testConstructor() public view {
        assertEq(token.name(), "BaseDevToken");
        assertEq(token.symbol(), "BDT");
        assertEq(token.decimals(), 18);
        assertEq(token.totalSupply(), initialSupply);
        assertEq(token.balanceOf(owner), initialSupply);
        assertEq(token.owner(), owner);
    }

    function testConstructorZeroSupply() public {
        vm.expectRevert(BaseDevToken__ZeroAmount.selector);
        new BaseDevToken(0);
    }

    function testMint() public {
        uint256 mintAmount = 100 * 10**18;
        token.mint(user1, mintAmount);
        assertEq(token.balanceOf(user1), mintAmount);
        assertEq(token.totalSupply(), initialSupply + mintAmount);
    }

    function testMintZeroAmount() public {
        vm.expectRevert(BaseDevToken__ZeroAmount.selector);
        token.mint(user1, 0);
    }

    function testMintToZeroAddress() public {
        vm.expectRevert(BaseDevToken__InvalidAddress.selector);
        token.mint(address(0), 100 * 10**18);
    }

    function testMintNotOwner() public {
        vm.prank(user1);
        vm.expectRevert();
        token.mint(user2, 100 * 10**18);
    }

    function testBurnFrom() public {
        uint256 burnAmount = 100 * 10**18;
        token.burnFrom(owner, burnAmount);
        assertEq(token.balanceOf(owner), initialSupply - burnAmount);
        assertEq(token.totalSupply(), initialSupply - burnAmount);
    }

    function testBurnFromZeroAmount() public {
        vm.expectRevert(BaseDevToken__ZeroAmount.selector);
        token.burnFrom(owner, 0);
    }

    function testBurnFromZeroAddress() public {
        vm.expectRevert(BaseDevToken__InvalidAddress.selector);
        token.burnFrom(address(0), 100 * 10**18);
    }

    function testBurnFromInsufficientBalance() public {
        vm.expectRevert(BaseDevToken__InsufficientBalance.selector);
        token.burnFrom(owner, initialSupply + 1);
    }

    function testBurnFromNotOwner() public {
        vm.prank(user1);
        vm.expectRevert();
        token.burnFrom(owner, 100 * 10**18);
    }

    function testBurn() public {
        uint256 burnAmount = 100 * 10**18;
        token.burn(burnAmount);
        assertEq(token.balanceOf(owner), initialSupply - burnAmount);
        assertEq(token.totalSupply(), initialSupply - burnAmount);
    }

    function testBurnZeroAmount() public {
        vm.expectRevert(BaseDevToken__ZeroAmount.selector);
        token.burn(0);
    }

    function testBurnInsufficientBalance() public {
        vm.prank(user1);
        vm.expectRevert(BaseDevToken__InsufficientBalance.selector);
        token.burn(100 * 10**18);
    }

    function testTransfer() public {
        uint256 transferAmount = 100 * 10**18;
        require(token.transfer(user1, transferAmount));
        assertEq(token.balanceOf(owner), initialSupply - transferAmount);
        assertEq(token.balanceOf(user1), transferAmount);
    }

    function testTotalSupplyAfterMultipleMints() public {
        uint256 mintAmount1 = 500 * 10**18;
        uint256 mintAmount2 = 300 * 10**18;
        token.mint(user1, mintAmount1);
        token.mint(user2, mintAmount2);
        assertEq(token.totalSupply(), initialSupply + mintAmount1 + mintAmount2);
    }

    function testBalanceAfterMultipleTransfers() public {
        uint256 transferAmount1 = 200 * 10**18;
        uint256 transferAmount2 = 100 * 10**18;
        token.transfer(user1, transferAmount1);
        token.transfer(user2, transferAmount2);
        assertEq(token.balanceOf(owner), initialSupply - transferAmount1 - transferAmount2);
        assertEq(token.balanceOf(user1), transferAmount1);
        assertEq(token.balanceOf(user2), transferAmount2);
    }

    function testBurnFromAfterTransfer() public {
        uint256 transferAmount = 300 * 10**18;
        uint256 burnAmount = 100 * 10**18;
        token.transfer(user1, transferAmount);
        token.burnFrom(user1, burnAmount);
        assertEq(token.balanceOf(user1), transferAmount - burnAmount);
        assertEq(token.totalSupply(), initialSupply - burnAmount);
    }

    function testSelfBurn() public {
        uint256 burnAmount = 50 * 10**18;
        token.burn(burnAmount);
        assertEq(token.balanceOf(owner), initialSupply - burnAmount);
        assertEq(token.totalSupply(), initialSupply - burnAmount);
    }

    function testApproveAndTransferFromMultiple() public {
        uint256 approveAmount = 400 * 10**18;
        uint256 transferAmount1 = 150 * 10**18;
        uint256 transferAmount2 = 100 * 10**18;
        token.approve(user1, approveAmount);
        vm.prank(user1);
        token.transferFrom(owner, user2, transferAmount1);
        vm.prank(user1);
        token.transferFrom(owner, user2, transferAmount2);
        assertEq(token.balanceOf(user2), transferAmount1 + transferAmount2);
        assertEq(token.allowance(owner, user1), approveAmount - transferAmount1 - transferAmount2);
    }

    function testDecimals() public {
        assertEq(token.decimals(), 18);
    }

    function testNameAndSymbol() public {
        assertEq(token.name(), "BaseDevToken");
        assertEq(token.symbol(), "BDT");
    }

    function testOwnerTransfer() public {
        address newOwner = address(0x3);
        vm.prank(owner);
        token.transferOwnership(newOwner);
        assertEq(token.owner(), newOwner);
    }

    function testNonOwnerCannotMint() public {
        vm.prank(user1);
        vm.expectRevert();
        token.mint(user2, 100 * 10**18);
    }

    function testNonOwnerCannotBurnFrom() public {
        vm.prank(user1);
        vm.expectRevert();
        token.burnFrom(owner, 100 * 10**18);
    }
}