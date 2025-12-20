// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {BaseDevToken} from "../src/BaseDevToken.sol";

contract BaseDevTokenTestnetScript is Script {
    function run() external {
        uint256 initialSupply = 1000000 * 10**18; // 1 million tokens for testnet

        vm.startBroadcast();
        BaseDevToken token = new BaseDevToken(initialSupply);
        vm.stopBroadcast();

        console.log("BaseDevToken deployed on testnet at:", address(token));
        console.log("Initial supply:", initialSupply);
        console.log("Owner:", token.owner());
    }
}