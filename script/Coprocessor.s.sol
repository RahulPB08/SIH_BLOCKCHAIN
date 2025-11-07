// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Coprocessor.sol";

contract MyScript is Script {
    function run(address chain_fusion_canister_address) external returns (address) {
        uint256 deployerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

        vm.startBroadcast(deployerPrivateKey);

        Coprocessor coprocessor = new Coprocessor();
        coprocessor.updateCoprocessor(chain_fusion_canister_address);

        for (uint256 index = 0; index < 3; index++) {
            coprocessor.newJob{value: 0.1 ether}();
        }

        vm.stopBroadcast();
        return address(coprocessor);
    }
}
