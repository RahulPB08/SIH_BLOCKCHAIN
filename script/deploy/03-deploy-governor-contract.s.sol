// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {GovernorContract} from "../../src/governance_standard/GovernorContract.sol";
import {GovernanceToken} from "../../src/GovernanceToken.sol";
import {TimeLock} from "../../src/governance_standard/TimeLock.sol";
import {DevOpsTools} from "../../lib/foundry-devops/src/DevOpsTools.sol";
import {deployTimeLock} from "./02-deploy-time-lock.s.sol";
import {deployGovernanceToken} from "./01-deploy-governor-token.s.sol";


contract DeployGovernor is Script {
    // Configuration constants (replace with your actual values)
    uint256 constant QUORUM_PERCENTAGE = 4; // example value
    uint256 constant VOTING_PERIOD = 5; // example value (~1 week in blocks)
    uint256 constant VOTING_DELAY = 1; // example value

    function run() external {
        // Start broadcasting to deploy contracts
        vm.startBroadcast();

        // Fetch already deployed contracts
        GovernanceToken governanceToken = GovernanceToken(
            DevOpsTools.get_most_recent_deployment(
                "GovernanceToken",
                block.chainid
            )
        );
        TimeLock timeLock = TimeLock(payable(
            DevOpsTools.get_most_recent_deployment("TimeLock", block.chainid))
        );


        // Deploy GovernorContract
        GovernorContract governor = new GovernorContract(
            governanceToken,
            timeLock,
            QUORUM_PERCENTAGE,
            VOTING_PERIOD,
            VOTING_DELAY
        );

        console.log("GovernorContract deployed at:", address(governor));

        vm.stopBroadcast();
    }
}
