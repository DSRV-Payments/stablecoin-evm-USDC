// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.1) (metatx/ERC2771Context.sol)

pragma solidity 0.6.12;

import { Context } from "@openzeppelin/contracts/GSN/Context.sol";

/**
 * @dev Context variant with ERC2771 support.
 *
 * WARNING: Avoid using this pattern in contracts that rely on a specific calldata length as they'll
 * be affected by any forwarder whose `msg.data` is suffixed with the `from` address according to the ERC2771
 * specification adding the address size in bytes (20) to the calldata size. An example of an unexpected
 * behavior could be an unintended fallback (or another function) invocation while trying to invoke the `receive`
 * function only accessible if `msg.data.length == 0`.
 *
 * WARNING: The usage of `delegatecall` in this contract is dangerous and may result in context corruption.
 * Any forwarded request to this contract triggering a `delegatecall` to itself will result in an invalid {_msgSender}
 * recovery.
 */
abstract contract ERC2771Context is Context {
    /**
     * @dev The trusted forwarder address.
     */
    address private _trustedForwarder;

    /**
     * @dev Initializes the contract with a trusted forwarder, which will be able to
     * invoke functions on this contract on behalf of other accounts.
     *
     * NOTE: The trusted forwarder can be replaced by overriding {trustedForwarder}.
     */
    constructor(address trustedForwarder_) public {
        _trustedForwarder = trustedForwarder_;
    }

    /**
     * @dev Returns the address of the trusted forwarder.
     */
    function trustedForwarder() public virtual view returns (address) {
        return _trustedForwarder;
    }

    /**
     * @dev Indicates whether any particular address is the trusted forwarder.
     */
    function isTrustedForwarder(address forwarder)
        public
        virtual
        view
        returns (bool)
    {
        return forwarder == trustedForwarder();
    }

    /**
     * @dev Override for `msg.sender`. Defaults to the original `msg.sender` whenever
     * a call is not performed by the trusted forwarder or the calldata length is less than
     * 20 bytes (an address length).
     */
    function _msgSender()
        internal
        virtual
        override
        view
        returns (address payable)
    {
        uint256 calldataLength = msg.data.length;
        uint256 contextSuffixLength = _contextSuffixLength();
        if (
            isTrustedForwarder(msg.sender) &&
            calldataLength >= contextSuffixLength
        ) {
            return
                abi.decode(
                    msg.data[calldataLength - contextSuffixLength:],
                    (address)
                );
        } else {
            return super._msgSender();
        }
    }

    /**
     * @dev Override for `msg.data`. Defaults to the original `msg.data` whenever
     * a call is not performed by the trusted forwarder or the calldata length is less than
     * 20 bytes (an address length).
     */
    function _msgData() internal virtual override view returns (bytes memory) {
        uint256 calldataLength = msg.data.length;
        uint256 contextSuffixLength = _contextSuffixLength();
        if (
            isTrustedForwarder(msg.sender) &&
            calldataLength >= contextSuffixLength
        ) {
            bytes memory msgData = new bytes(
                calldataLength - contextSuffixLength
            );
            for (uint256 i = 0; i < calldataLength - contextSuffixLength; i++) {
                msgData[i] = msg.data[i];
            }
            return msgData;
        } else {
            return super._msgData();
        }
    }

    /**
     * @dev ERC-2771 specifies the context as being a single address (20 bytes).
     */
    function _contextSuffixLength() internal virtual view returns (uint256) {
        return 20;
    }
}
