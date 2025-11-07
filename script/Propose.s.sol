// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "../../lib/foundry-devops/src/DevOpsTools.sol";
import {GovernorContract} from "../../src/governance_standard/GovernorContract.sol";
import {BoxV1} from "../../src/BoxV1.sol";
import {BoxV2} from "../../src/BoxV2.sol";
import "../lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract ProposeBoxChange is Script {
    uint256 constant NEW_STORE_VALUE = 24;
    string constant PROPOSAL_DESCRIPTION = "Proposal #1: Upgrade Box to Box_2";

    function run() external returns (uint256) {
        vm.startBroadcast(
            0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
        );

        // Governor contract
        GovernorContract governor = GovernorContract(
            payable(
                DevOpsTools.get_most_recent_deployment(
                    "GovernorContract",
                    block.chainid
                )
            )
        );

        BoxV2 newBox = new BoxV2();
        // Proxy contract
        address proxyAddress = DevOpsTools.get_most_recent_deployment(
            "ERC1967Proxy",
            block.chainid
        );
        BoxV1 proxy = BoxV1(payable(proxyAddress));

        // New implementation

        // console.log("Proposing upgrade to Box_2 at:", address(newBox));

        // Encode upgrade function call
        bytes memory encodedFunctionCall = abi.encodeWithSignature(
            "upgradeToAndCall(address,bytes)",
            address(newBox),
            ""
        );

        // Proposal arrays

        // Initialize proposal arrays
        address[] memory targets = new address[](1);
        uint256[] memory values = new uint256[](1);
        bytes[] memory calldatas = new bytes[](1);

        // Populate proposal arrays
        targets[0] = address(proxy);
        values[0] = 0;
        calldatas[0] = encodedFunctionCall;
        // Submit proposal
        uint256 proposalId = governor.propose(
            targets,
            values,
            calldatas,
            PROPOSAL_DESCRIPTION
        );

        console.log("Proposal ID:", proposalId);

        vm.stopBroadcast();
        return proposalId;
    }
}
