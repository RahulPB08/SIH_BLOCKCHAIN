// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "../../lib/foundry-devops/src/DevOpsTools.sol";
import {BoxV1} from "../../src/BoxV1.sol";
import {TimeLock} from "../../src/governance_standard/TimeLock.sol";
import "../../lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployBoxScript is Script {
    function run() external {
        // Replace with your deployer private key
        uint256 deployerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

        vm.startBroadcast(deployerPrivateKey);

        TimeLock timeLock = TimeLock(
            payable(
                DevOpsTools.get_most_recent_deployment(
                    "TimeLock",
                    block.chainid
                )
            )
        );
        address governor=DevOpsTools.get_most_recent_deployment(
                    "GovernorContract",
                    block.chainid
                );
        BoxV1 boxIMpl = new BoxV1();

        bytes memory initData = abi.encodeWithSignature(
            "initialize(address)",
            address(timeLock)
        );
        ERC1967Proxy proxy = new ERC1967Proxy(address(boxIMpl), initData);

        console.log(
            "Transferring ownership of Box to TimeLock at:",
            address(timeLock)
        );

        console.log("Ownership transfer complete!");
        vm.stopBroadcast();
    }
}
