// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "../../lib/foundry-devops/src/DevOpsTools.sol";
import {TimeLock} from "../../src/governance_standard/TimeLock.sol";
import {GovernorContract} from "../../src/governance_standard/GovernorContract.sol";

contract SetupRoles is Script {
    // Use zero address for executor
    address constant ADDRESS_ZERO = address(0);

    function run() external {
        // Replace with your deployer private key
        uint256 deployerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

        // Start broadcasting
        vm.startBroadcast(deployerPrivateKey);

        // Fetch already deployed contracts
        TimeLock timeLock = TimeLock(
            payable(
                DevOpsTools.get_most_recent_deployment("TimeLock", block.chainid)
            )
        );
        GovernorContract governor = GovernorContract(
            payable(
                DevOpsTools.get_most_recent_deployment("GovernorContract", block.chainid)
            )
        );

        console.log("----------------------------------------------------");
        console.log("Setting up roles for TimeLock...");

        // Get roles
        bytes32 proposerRole = timeLock.PROPOSER_ROLE();
        bytes32 executorRole = timeLock.EXECUTOR_ROLE();
        bytes32 adminRole = timeLock.TIMELOCK_ADMIN_ROLE();

        // Grant proposer role to GovernorContract
        timeLock.grantRole(proposerRole, address(governor));
        console.log("Granted proposer role to GovernorContract");

        // Grant executor role to zero address (everyone)
        timeLock.grantRole(executorRole, ADDRESS_ZERO);
        console.log("Granted executor role to ADDRESS_ZERO");

        // Revoke admin role from deployer
        timeLock.revokeRole(adminRole, vm.addr(deployerPrivateKey));
        console.log("Revoked admin role from deployer");

        console.log("Roles setup complete!");
        vm.stopBroadcast();
    }
}
