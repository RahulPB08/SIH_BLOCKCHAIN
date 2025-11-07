// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "../../lib/foundry-devops/src/DevOpsTools.sol";
import {GovernorContract} from "../../src/governance_standard/GovernorContract.sol";
import {Vm} from "forge-std/Vm.sol";

contract VoteProposal is Script {
    uint8 constant VOTE_FOR = 1;
    string constant REASON = "I lika do da cha cha";
uint256 constant VOTING_DELAY = 1;
    uint256 constant VOTING_PERIOD = 5; // Replace with your actual voting period in blocks

    // uint256 proposalId;

    // constructor(uint256 proposalId_1) {
    //     proposalId = proposalId_1;
    // }

    // Vote options: 0 = Against, 1 = For, 2 = Abstain

    function run(uint256 proposalId) external {
        uint256 deployerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

        vm.startBroadcast(deployerPrivateKey);

        // Fetch the latest deployed GovernorContract
        GovernorContract governor = GovernorContract(
            payable(
                DevOpsTools.get_most_recent_deployment(
                    "GovernorContract",
                    block.chainid
                )
            )
        );

        // Replace with your actual proposalId (fetch from storage or DevOpsTools if needed)
        // uint256 proposalId = DevOpsTools.get_most_recent_deployment_uint("LastProposalId", block.chainid);
        // After proposing
 if (block.chainid == 31337) {
            // local Hardhat/Anvil chain
            vm.roll(block.number + VOTING_DELAY+1);
            console.log("Moved blocks to reach voting period");
        }

        GovernorContract.ProposalState stateEnum = governor.state(proposalId);
        uint256 proposalState = uint256(stateEnum);
        console.log("Voting on proposal:", proposalId);

        // Cast vote with reason
        governor.castVoteWithReason(proposalId, VOTE_FOR, REASON);
        console.log("Vote casted with reason:", REASON);

        // Fetch proposal state (enum to uint)

        console.log("Current Proposal State:", proposalState);

        // If running on a local chain, move blocks to simulate voting period passing
        if (block.chainid == 31337) {
            vm.roll(block.number + VOTING_PERIOD + 1);
            console.log("Moved blocks to simulate voting period end");
        }

        vm.stopBroadcast();
    }
}
