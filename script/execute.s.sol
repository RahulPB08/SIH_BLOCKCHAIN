// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "../../lib/foundry-devops/src/DevOpsTools.sol";
import {GovernorContract} from "../../src/governance_standard/GovernorContract.sol";
import {BoxV1} from "../../src/BoxV1.sol";
import {BoxV2} from "../../src/BoxV2.sol";
import {TimeLock} from "../../src/governance_standard/TimeLock.sol";
import {ERC1967Proxy} from "../../lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract execute is Script {
    string constant PROPOSAL_DESCRIPTION = "Proposal #1: Upgrade Box to Box_2";
    uint256 constant MIN_DELAY = 3600; // 1 hour for timelock delay
    uint256 constant LOCAL_CHAIN_ID = 31337;

    function run() external {
        // uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(
            0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
        );

        // Fetch deployed contracts
        GovernorContract governor = GovernorContract(
            payable(
                DevOpsTools.get_most_recent_deployment(
                    "GovernorContract",
                    block.chainid
                )
            )
        );

        TimeLock timelock = TimeLock(
            payable(
                DevOpsTools.get_most_recent_deployment(
                    "TimeLock",
                    block.chainid
                )
            )
        );

        address proxyAddress = DevOpsTools.get_most_recent_deployment(
            "ERC1967Proxy",
            block.chainid
        );

        // Get the BoxV2 implementation address (should be deployed by ProposeBoxChange)
        address boxV2Address = DevOpsTools.get_most_recent_deployment(
            "BoxV2",
            block.chainid
        );
        BoxV1 proxyBox = BoxV1(proxyAddress);
        address currentOwner = proxyBox.owner();
        console.log("New version:", proxyBox.version());
        console.log("Proxy Ownership:", currentOwner);
        console.log("Governor:", address(governor));
        console.log("TimeLock:", address(timelock));
        console.log("Proxy:", proxyAddress);
        console.log("BoxV2 Implementation:", boxV2Address);
        console.log("Min Delay:", timelock.getMinDelay());

        // Encode function call for upgrade
        bytes memory encodedFunctionCall = abi.encodeWithSignature(
            "upgradeToAndCall(address,bytes)",
            boxV2Address,
            ""
        );

        bytes32 descriptionHash = keccak256(bytes(PROPOSAL_DESCRIPTION));
        governor.execute(
            _toArray(proxyAddress),
            _toArray(0),
            _toArrayBytes(encodedFunctionCall),
            descriptionHash
        );
        console.log("New version:", BoxV2(proxyAddress).version());

        vm.stopBroadcast();
    }

    function _toArray(address a) internal pure returns (address[] memory arr) {
        arr = new address[](1);
        arr[0] = a;
    }

    function _toArray(uint256 v) internal pure returns (uint256[] memory arr) {
        arr = new uint256[](1);
        arr[0] = v;
    }

    function _toArrayBytes(
        bytes memory b
    ) internal pure returns (bytes[] memory arr) {
        arr = new bytes[](1);
        arr[0] = b;
    }
}
