// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// Scripting tool
import {Script} from "../lib/forge-std/src/Script.sol";

import {Flow} from "../contracts/Flow.sol";
import {GaugeFactory} from "../contracts/factories/GaugeFactory.sol";
import {BribeFactory} from "../contracts/factories/BribeFactory.sol";
import {PairFactory} from "../contracts/factories/PairFactory.sol";
import {Router} from "../contracts/Router.sol";
import {VelocimeterLibrary} from "../contracts/VelocimeterLibrary.sol";
import {VeArtProxy} from "../contracts/VeArtProxy.sol";
import {VotingEscrow} from "../contracts/VotingEscrow.sol";
import {RewardsDistributor} from "../contracts/RewardsDistributor.sol";
import {Voter} from "../contracts/Voter.sol";
import {Minter} from "../contracts/Minter.sol";
import {MintTank} from "../contracts/MintTank.sol";
import {OptionToken} from "../contracts/OptionToken.sol";
import {IERC20} from "../contracts/interfaces/IERC20.sol";
import {IPair} from "../contracts/interfaces/IPair.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";

contract Deployment is Script {
    // token addresses
    // TODO: check token address
    address private constant WPLS = 0xA1077a294dDE1B09bB078844df40758a5D0f9a27;
    address private constant USDC = 0x15D38573d2feeb82e7ad5187aB8c1D52810B1f07;
    address private constant DAI = 0xefD766cCb38EaF1dfd701853BFCe31359239F305;
    address private constant WETH = 0x02DcdD04e3F455D838cd1249292C58f3B79e3C3C;
    address private constant WBTC = 0xb17D901469B9208B17d916112988A3FeD19b5cA1;
    address private constant USDT = 0x0Cb6F5a34ad42ec934882A05265A7d5F59b51A2f;
    address private constant HEX = 0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39;

    // privileged accounts
    // TODO: change these accounts!
    address private constant TEAM_MULTI_SIG = address(0);
    address private constant TANK = address(0);

    // TODO: set the following variables
    uint private constant INITIAL_MINT_AMOUNT = 82800140034502500000000000;
    uint private constant MINT_TANK_MIN_LOCK_TIME = 26 * 7 * 86400;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // Flow token
        Flow flow = new Flow(TEAM_MULTI_SIG, INITIAL_MINT_AMOUNT);

        // Gauge factory
        GaugeFactory gaugeFactory = new GaugeFactory();

        // Bribe factory
        BribeFactory bribeFactory = new BribeFactory();

        // Pair factory
        PairFactory pairFactory = new PairFactory();

        // Router
        Router router = new Router(address(pairFactory), WPLS);

        // VelocimeterLibrary
        new VelocimeterLibrary(address(router));

        // VeArtProxy
        VeArtProxy veArtProxy = new VeArtProxy();

        // VotingEscrow
        VotingEscrow votingEscrow = new VotingEscrow(
            address(flow),
            address(veArtProxy),
            TEAM_MULTI_SIG
        );

        // RewardsDistributor
        RewardsDistributor rewardsDistributor = new RewardsDistributor(
            address(votingEscrow)
        );

        // Voter
        Voter voter = new Voter(
            address(votingEscrow),
            address(pairFactory),
            address(gaugeFactory),
            address(bribeFactory)
        );

        // Set voter
        votingEscrow.setVoter(address(voter));
        pairFactory.setVoter(address(voter));

        // Minter
        Minter minter = new Minter(
            address(voter),
            address(votingEscrow),
            address(rewardsDistributor)
        );

        // MintTank
        MintTank mintTank = new MintTank(
            address(flow),
            address(votingEscrow),
            TEAM_MULTI_SIG,
            MINT_TANK_MIN_LOCK_TIME
        );

        IPair flowWplsPair = IPair(
            pairFactory.createPair(address(flow), WPLS, false)
        );

        // Option to buy Flow
        OptionToken oFlow = new OptionToken(
            "Option to buy FLOW", // name
            "oFLOW", // symbol
            TEAM_MULTI_SIG, // admin
            ERC20(WPLS), // payment token
            ERC20(address(flow)), // underlying token
            flowWplsPair, // pair
            address(gaugeFactory), // gauge factory
            TEAM_MULTI_SIG, // treasury
            50 // discount
        );

        gaugeFactory.setOFlow(address(oFlow));

        // Set flow minter to contract
        flow.setMinter(address(minter));

        // Set pair factory pauser and tank
        pairFactory.setTank(TANK);

        // Set voting escrow's art proxy
        votingEscrow.setArtProxy(address(veArtProxy));

        // Set minter and voting escrow's team
        votingEscrow.setTeam(TEAM_MULTI_SIG);
        minter.setTeam(TEAM_MULTI_SIG);

        // Transfer pairfactory ownership to MSIG (team)
        pairFactory.transferOwnership(TEAM_MULTI_SIG);

        // Transfer gaugefactory ownership to MSIG (team)
        gaugeFactory.transferOwnership(TEAM_MULTI_SIG);

        // Set voter's emergency council
        voter.setEmergencyCouncil(TEAM_MULTI_SIG);

        // Set voter's governor
        voter.setGovernor(TEAM_MULTI_SIG);

        // Set rewards distributor's depositor to minter contract
        rewardsDistributor.setDepositor(address(minter));

        // Initialize tokens for voter
        address[] memory whitelistedTokens = new address[](8);
        whitelistedTokens[0] = address(flow);
        whitelistedTokens[1] = WPLS;
        whitelistedTokens[2] = USDC;
        whitelistedTokens[3] = DAI;
        whitelistedTokens[4] = WETH;
        whitelistedTokens[5] = WBTC;
        whitelistedTokens[6] = USDT;
        whitelistedTokens[7] = HEX;
        voter.initialize(whitelistedTokens, address(minter));

        vm.stopBroadcast();
    }
}
