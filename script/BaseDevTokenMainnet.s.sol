// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {BaseDevToken} from "../src/BaseDevToken.sol";

contract BaseDevTokenMainnetScript is Script {
    function run() external {
        uint256 initialSupply = 10000000 * 10**18; // 10 million tokens for mainnet

        vm.startBroadcast();
        BaseDevToken token = new BaseDevToken(initialSupply);
        vm.stopBroadcast();

        console.log("BaseDevToken deployed on mainnet at:", address(token));
        console.log("Initial supply:", initialSupply);
        console.log("Owner:", token.owner());
    }
}