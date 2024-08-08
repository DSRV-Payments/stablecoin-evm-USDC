// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.6.12;

import { FiatTokenV2_2 } from "./../v2/FiatTokenV2_2.sol";
import { ERC2771Context } from "./ERC2771Context.sol";
import { Context } from "@openzeppelin/contracts/GSN/Context.sol";

contract FiatTokenV3 is FiatTokenV2_2, ERC2771Context {
    constructor(address trustedForwarder)
        public
        ERC2771Context(trustedForwarder)
    {}

    function _msgSender()
        internal
        virtual
        override(ERC2771Context, Context)
        view
        returns (address payable)
    {
        return ERC2771Context._msgSender();
    }

    function _msgData()
        internal
        virtual
        override(ERC2771Context, Context)
        view
        returns (bytes memory)
    {
        return ERC2771Context._msgData();
    }
}
