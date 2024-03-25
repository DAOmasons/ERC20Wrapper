// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/ERC20Wrapper.sol)
/*
//  ██████   █████   ██████      ███    ███  █████  ███████  ██████  ███    ██ ███████ 
//  ██   ██ ██   ██ ██    ██     ████  ████ ██   ██ ██      ██    ██ ████   ██ ██      
//  ██   ██ ███████ ██    ██     ██ ████ ██ ███████ ███████ ██    ██ ██ ██  ██ ███████ 
//  ██   ██ ██   ██ ██    ██     ██  ██  ██ ██   ██      ██ ██    ██ ██  ██ ██      ██ 
//  ██████  ██   ██  ██████      ██      ██ ██   ██ ███████  ██████  ██   ████ ███████ 
//                                                                                     
//                                                                                     
*/
pragma solidity ^0.8.20;

import {IERC20, IERC20Metadata, ERC20} from "../ERC20.sol";
import {SafeERC20} from "../utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @dev Extension of the ERC20 token contract to support token wrapping.
 *
 * Users can deposit and withdraw "underlying tokens" and receive a matching number of "wrapped tokens". This is useful
 * in conjunction with other modules. For example, combining this wrapping mechanism with {ERC20Votes} will allow the
 * wrapping of an existing "basic" ERC20 into a governance token.
 */
abstract contract gsARB is ERC20, AccessControl {
    bytes32 public constant RECOVERY_ROLE = keccak256("RECOVERY_ROLE");
    IERC20 private immutable _underlying;

    /**
     * @dev The underlying token couldn't be wrapped.
     */
    error ERC20InvalidUnderlying(address token);

    constructor(IERC20 underlyingToken) ERC20("WrappedToken", "WT") {
        // Check if the underlying token is the contract itself to prevent wrapping itself
        if (underlyingToken == IERC20(address(this))) {
            revert ERC20InvalidUnderlying(address(this));
        }
        _underlying = underlyingToken;

        // Setup the default admin role
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

        // Assign the RECOVERY_ROLE to the deployer
        _setupRole(RECOVERY_ROLE, _msgSender());
    }
}

    /**
     * @dev See {ERC20-decimals}.
     */
    function decimals() public view virtual override returns (uint8) {
        try IERC20Metadata(address(_underlying)).decimals() returns (uint8 value) {
            return value;
        } catch {
            return super.decimals();
        }
    }

    /**
     * @dev Returns the address of the underlying ERC-20 token that is being wrapped.
     */
    function underlying() public view returns (IERC20) {
        return _underlying;
    }

    /**
     * @dev Allow a user to deposit underlying tokens and mint the corresponding number of wrapped tokens.
     */
    function depositFor(address account, uint256 value) public virtual returns (bool) {
        address sender = _msgSender();
        if (sender == address(this)) {
            revert ERC20InvalidSender(address(this));
        }
        if (account == address(this)) {
            revert ERC20InvalidReceiver(account);
        }
        SafeERC20.safeTransferFrom(_underlying, sender, address(this), value);
        _mint(account, value);
        return true;
    }

    /**
     * @dev Allow a user to burn a number of wrapped tokens and withdraw the corresponding number of underlying tokens.
     */
    function withdrawTo(address account, uint256 value) public virtual returns (bool) {
        if (account == address(this)) {
            revert ERC20InvalidReceiver(account);
        }
        _burn(_msgSender(), value);
        SafeERC20.safeTransfer(_underlying, account, value);
        return true;
    }

    /**
     * @dev Mint wrapped token to cover any underlyingTokens that would have been transferred by mistake. Internal
     * function that can be exposed with access control if desired.
     */
    function _recover(address account) internal virtual returns (uint256) {
        require(hasRole(RECOVERY_ROLE, msg.sender), "Caller is not authorized");
        uint256 value = _underlying.balanceOf(address(this)) - totalSupply();
        _mint(account, value);
        return value;
    }
}
