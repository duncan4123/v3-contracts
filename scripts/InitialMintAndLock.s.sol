// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// Scripting tool
import {Script} from "../lib/forge-std/src/Script.sol";

import {Minter} from "../contracts/Minter.sol";

contract InitialMintAndLock is Script {
    address private constant TEAM_MULTI_SIG = 0x13eeB8EdfF60BbCcB24Ec7Dd5668aa246525Dc51;

    // address to receive veNFT to be distributed to partners in the future
    address private constant FLOW_VOTER_EOA = 0xcC06464C7bbCF81417c08563dA2E1847c22b703a;
    address private constant ASSET_EOA = 0x1bAe1083CF4125eD5dEeb778985C1Effac0ecC06;

    // team member addresses
    address private constant DUNKS = 0x069e85D4F1010DD961897dC8C095FBB5FF297434;
    address private constant T0RB1K = 0x0b776552c1Aef1Dc33005DD25AcDA22493b6615d;
    address private constant CEAZOR = 0x06b16991B53632C2362267579AE7C4863c72fDb8;
    address private constant MOTTO = 0x78e801136F77805239A7F533521A7a5570F572C8;
    address private constant COOLIE = 0x03B88DacB7c21B54cEfEcC297D981E5b721A9dF1;

    // token amounts
    uint256 private constant ONE_MILLION = 1e24; // 1e24 == 1e6 (1m) ** 1e18 (decimals)
    uint256 private constant TWO_MILLION = 2e24; // 2e24 == 1e6 (1m) ** 1e18 (decimals)
    uint256 private constant THREE_MILLION = 3e24; // 3e24 == 1e6 (1m) ** 1e18 (decimals)
    uint256 private constant FOUR_MILLION = 4e24; // 4e24 == 1e6 (1m) ** 1e18 (decimals)

    // time
    uint256 private constant MAX_LOCK = 26 * 7 * 86400; // 6 MONTHS

    Minter private minter;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // TODO: Fill minter address after mainnet deploy
        minter = Minter(address(0));

        // Mint tokens and lock for veNFT

        // 1. Mint to Flow voter EOA
        _batchInitialMintAndLock({
            owner: FLOW_VOTER_EOA,
            numberOfVotingEscrow: 5,
            amountPerVotingEscrow: ONE_MILLION,
            lockTime: MAX_LOCK
        });

        _batchInitialMintAndLock({
            owner: FLOW_VOTER_EOA,
            numberOfVotingEscrow: 6,
            amountPerVotingEscrow: TWO_MILLION,
            lockTime: MAX_LOCK
        });

        _batchInitialMintAndLock({
            owner: FLOW_VOTER_EOA,
            numberOfVotingEscrow: 2,
            amountPerVotingEscrow: THREE_MILLION,
            lockTime: MAX_LOCK
        });

        // 2. Mint to team members
        _batchInitialMintAndLock({
            owner: DUNKS,
            numberOfVotingEscrow: 1,
            amountPerVotingEscrow: FOUR_MILLION,
            lockTime: MAX_LOCK
        });

        _batchInitialMintAndLock({
            owner: DUNKS,
            numberOfVotingEscrow: 1,
            amountPerVotingEscrow: TWO_MILLION,
            lockTime: MAX_LOCK
        });

        _batchInitialMintAndLock({
            owner: T0RB1K,
            numberOfVotingEscrow: 3,
            amountPerVotingEscrow: FOUR_MILLION,
            lockTime: MAX_LOCK
        });

        _batchInitialMintAndLock({
            owner: CEAZOR,
            numberOfVotingEscrow: 3,
            amountPerVotingEscrow: FOUR_MILLION,
            lockTime: MAX_LOCK
        });

        _batchInitialMintAndLock({
            owner: MOTTO,
            numberOfVotingEscrow: 3,
            amountPerVotingEscrow: FOUR_MILLION,
            lockTime: MAX_LOCK
        });

        _batchInitialMintAndLock({
            owner: COOLIE,
            numberOfVotingEscrow: 3,
            amountPerVotingEscrow: FOUR_MILLION,
            lockTime: MAX_LOCK
        });

        // 3. Mint for future partners
        _batchInitialMintAndLock({
            owner: ASSET_EOA,
            numberOfVotingEscrow: 4,
            amountPerVotingEscrow: THREE_MILLION,
            lockTime: MAX_LOCK
        });

        _batchInitialMintAndLock({
            owner: TEAM_MULTI_SIG,
            numberOfVotingEscrow: 18,
            amountPerVotingEscrow: THREE_MILLION,
            lockTime: MAX_LOCK
        });

        _batchInitialMintAndLock({
            owner: ASSET_EOA,
            numberOfVotingEscrow: 4,
            amountPerVotingEscrow: TWO_MILLION,
            lockTime: MAX_LOCK
        });

        _batchInitialMintAndLock({
            owner: TEAM_MULTI_SIG,
            numberOfVotingEscrow: 14,
            amountPerVotingEscrow: TWO_MILLION,
            lockTime: MAX_LOCK
        });

        _batchInitialMintAndLock({
            owner: TEAM_MULTI_SIG,
            numberOfVotingEscrow: 15,
            amountPerVotingEscrow: ONE_MILLION,
            lockTime: MAX_LOCK
        });

        _batchInitialMintAndLock({
            owner: ASSET_EOA,
            numberOfVotingEscrow: 5,
            amountPerVotingEscrow: ONE_MILLION,
            lockTime: MAX_LOCK
        });

        _batchInitialMintAndLock({
            owner: ASSET_EOA,
            numberOfVotingEscrow: 5,
            amountPerVotingEscrow: ONE_MILLION,
            lockTime: MAX_LOCK
        });
        // Mint for current partners and presale
        _singleInitialMintAndLock(0x69224dbA1D77bfe6eA99409aB595d04631D95C22, 1205636240970620000000000);
        _singleInitialMintAndLock(0x69224dbA1D77bfe6eA99409aB595d04631D95C22, 1201854505093560000000000);
        _singleInitialMintAndLock(0x69224dbA1D77bfe6eA99409aB595d04631D95C22, 1207527108909160000000000);
        _singleInitialMintAndLock(0x69224dbA1D77bfe6eA99409aB595d04631D95C22, 1207527108909160000000000);
        _singleInitialMintAndLock(0x69224dbA1D77bfe6eA99409aB595d04631D95C22, 1207527108909160000000000);
        _singleInitialMintAndLock(0xCFFC6e659DF622e2d41c7A879C76E6d33F37925E, 1207527108909160000000000);
        _singleInitialMintAndLock(0xF09d213EE8a8B159C884b276b86E08E26B3bfF75, 5000000000000000000000000);
        _singleInitialMintAndLock(0x50149b01f19c2D4A403B1FE4469c117a5cEdb4fc, 1006272590757630000000000);

        // set initializer to 0 so we can no longer mint more
        minter.startActivePeriod();

        vm.stopBroadcast();
    }

    function _singleInitialMintAndLock(address owner, uint256 amount) private {
        Minter.Claim[] memory claim = new Minter.Claim[](1);
        claim[0] = Minter.Claim({claimant: owner, amount: amount, lockTime: MAX_LOCK});
        minter.initialMintAndLock(claim, amount);
    }

    function _batchInitialMintAndLock(
        address owner,
        uint256 numberOfVotingEscrow,
        uint256 amountPerVotingEscrow,
        uint256 lockTime
    ) private {
        Minter.Claim[] memory claim = new Minter.Claim[](numberOfVotingEscrow);
        for (uint256 i; i < numberOfVotingEscrow; i++) {
            claim[i] = Minter.Claim({claimant: owner, amount: amountPerVotingEscrow, lockTime: lockTime});
        }
        minter.initialMintAndLock(claim, amountPerVotingEscrow * numberOfVotingEscrow);
    }
}
