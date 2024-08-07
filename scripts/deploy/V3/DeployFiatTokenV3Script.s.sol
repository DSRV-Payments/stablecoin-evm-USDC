// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.6.12;

import "forge-std/console.sol";
import { Script } from "forge-std/Script.sol";
import { FiatTokenV3 } from "../../../contracts/v3/FiatTokenV3.sol";

contract DeployFiatTokenV3Script is Script {
    uint256 private deployerPrivateKey;

    address trustedForwarder = address(
        0x71bB75dCB43f57360b0e2fdd08BE14622741FD80
    );

    function setUp() public {
        deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
    }

    function run() external {
        vm.startBroadcast(deployerPrivateKey);

        FiatTokenV3 fiatToken = new FiatTokenV3(trustedForwarder);

        vm.stopBroadcast();

        console.log("FiatTokenV3 deployed at:", address(fiatToken));
    }
}
