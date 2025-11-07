// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {TimeLock} from "../../src/governance_standard/TimeLock.sol";

contract deployTimeLock is Script {
    uint256 constant MIN_DELAY = 0; 

    function run() external returns (TimeLock){
        
        address deployer = vm.addr(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);

        vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);

        // ✅ Create empty arrays for proposers and executors
        address[] memory proposers;
        address[] memory executors;

        // ✅ Deploy the TimeLock contract
        TimeLock timeLock = new TimeLock(
            MIN_DELAY, // Minimum delay
            proposers, // Proposers (none at start)
            executors, // Executors (none at start)
            deployer // Initial admin
        );

        console.log("TimeLock deployed at:", address(timeLock));

        vm.stopBroadcast();
        return timeLock;
    }
}
