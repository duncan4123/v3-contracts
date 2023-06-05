// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// Scripting tool
import {Script} from "../lib/forge-std/src/Script.sol";
import {IFlow} from "../contracts/interfaces/IFlow.sol";

contract AirdropClaimSetup is Script {
    // TODO: set variables
    address private constant FLOW = address(0);
    address private constant VOTING_ESCROW = address(0);
    address private constant TEAM_MULTI_SIG = address(0);

    uint private constant AIRDROP_CLAIM_START_TIMESTAMP = 0;
    uint private constant TOTAL_AIRDROP_AMOUNT = 0;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
        // AirdropClaim
        AirdropClaim airdropClaim = new AirdropClaim(
            FLOW,
            VOTING_ESCROW,
            TEAM_MULTI_SIG,
            AIRDROP_CLAIM_START_TIMESTAMP
        );

        IFlow(FLOW).approve(address(airdropClaim), TOTAL_AIRDROP_AMOUNT);
        airdropClaim.deposit(TOTAL_AIRDROP_AMOUNT);

        vm.stopBroadcast();
    }
}
