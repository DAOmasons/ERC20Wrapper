// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract wARB is ERC20, AccessControl, ReentrancyGuard {
    bytes32 public constant RECOVERY_ROLE = keccak256("RECOVERY_ROLE");
    IERC20 private immutable _underlying;

    // Define custom errors
    error ERC20InvalidSender(address sender);
    error ERC20InvalidReceiver(address receiver);

    // Events for deposit, withdrawal, and recovery
    event Deposit(address indexed account, uint256 value);
    event Withdrawal(address indexed account, uint256 value);
    event Recovery(address indexed account, uint256 value);

    constructor(string memory name_, string memory symbol_, IERC20 underlyingToken) 
        ERC20(name_, symbol_) 
        AccessControl() 
        ReentrancyGuard() 
    {
        require(address(underlyingToken) != address(0), "Invalid underlying token address");

        _underlying = underlyingToken;

        // Setup roles
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(RECOVERY_ROLE, _msgSender());
    }

    function decimals() public view override returns (uint8) {
        try IERC20Metadata(address(_underlying)).decimals() returns (uint8 value) {
            return value;
        } catch {
            return super.decimals();
        }
    }

    function underlying() public view returns (IERC20) {
        return _underlying;
    }

    // Allows a user to deposit underlying tokens and receive wrapped tokens
    function depositFor(address account, uint256 value) public nonReentrant returns (bool) {
        address sender = _msgSender();
        if (sender == address(this)) revert ERC20InvalidSender(sender);
        if (account == address(this)) revert ERC20InvalidReceiver(account);

        SafeERC20.safeTransferFrom(_underlying, sender, address(this), value);
        _mint(account, value);
        emit Deposit(account, value);
        return true;
    }

    // Allows a user to burn wrapped tokens and withdraw underlying tokens
    function withdrawTo(address account, uint256 value) public nonReentrant returns (bool) {
        if (account == address(this)) revert ERC20InvalidReceiver(account);

        _burn(_msgSender(), value);
        SafeERC20.safeTransfer(_underlying, account, value);
        emit Withdrawal(account, value);
        return true;
    }

    // Mint wrapped tokens to recover any underlying tokens sent by mistake
    function recover(address account) public virtual returns (uint256) {
        require(hasRole(RECOVERY_ROLE, _msgSender()), "Caller is not authorized");

        uint256 value = _underlying.balanceOf(address(this)) - totalSupply();
        _mint(account, value);
        emit Recovery(account, value);
        return value;
    }
}
