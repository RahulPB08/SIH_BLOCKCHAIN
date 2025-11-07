// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script,console} from "forge-std/Script.sol";
import {GovernanceToken} from "../../src/GovernanceToken.sol";

contract deployGovernanceToken is Script {
    function run() external returns (GovernanceToken){
        // Load deployer's private key from env
        // uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);

        vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);

        // Deploy GovernanceToken
        GovernanceToken governanceToken = new GovernanceToken();
        console.log("GovernanceToken deployed at:", address(governanceToken));

        // Delegate to deployer
        governanceToken.delegate(deployer);
        console.log("Delegated to:", deployer);

        // Check how many checkpoints (vote snapshots) deployer has
        console.log("Checkpoints:", governanceToken.numCheckpoints(deployer));

        vm.stopBroadcast();
        return governanceToken;
    }
}
