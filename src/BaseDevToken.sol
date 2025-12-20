/// SPDX-License-Identifier: MIT

/// @title BaseDevToken ERC20 (BDT)
/// @notice Demo / developer-focused ERC-20 token built with OpenZeppelin for secure patterns and easy extension.
/// @dev Extends ERC20 and Ownable for basic token functionality with restricted minting and burning.

pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

error BaseDevToken__InvalidAddress();
error BaseDevToken__InsufficientBalance();
error BaseDevToken__ZeroAmount();

contract BaseDevToken is ERC20, Ownable {
    /// @notice Initializes the token with a name, symbol, and initial supply minted to the deployer.
    /// @param initialSupply The initial supply of tokens (in wei units, considering 18 decimals).
    constructor(uint256 initialSupply) ERC20("BaseDevToken", "BDT") Ownable(msg.sender) {
        if (initialSupply == 0) revert BaseDevToken__ZeroAmount();
        _mint(msg.sender, initialSupply);
    }

    /// @notice Mints new tokens to a specified address. Only callable by the owner.
    /// @param to The address to receive the minted tokens.
    /// @param amount The amount of tokens to mint (in wei units).
    function mint(address to, uint256 amount) public onlyOwner {
        if (to == address(0)) revert BaseDevToken__InvalidAddress();
        if (amount == 0) revert BaseDevToken__ZeroAmount();
        _mint(to, amount);
    }

    /// @notice Burns tokens from a specified address. Only callable by the owner.
    /// @param from The address from which to burn tokens.
    /// @param amount The amount of tokens to burn (in wei units).

    function burnFrom(address from, uint256 amount) public onlyOwner {
        if (from == address(0)) revert BaseDevToken__InvalidAddress();
        if (amount == 0) revert BaseDevToken__ZeroAmount();
        if (balanceOf(from) < amount) revert BaseDevToken__InsufficientBalance();
        _burn(from, amount);
    }

    /// @notice Allows any token holder to burn their own tokens.
    /// @param amount The amount of tokens to burn (in wei units).

    function burn(uint256 amount) public {
        if (amount == 0) revert BaseDevToken__ZeroAmount();
        if (balanceOf(msg.sender) < amount) revert BaseDevToken__InsufficientBalance();
        _burn(msg.sender, amount);
    }
}