// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/PredictTheFuture.sol";

contract PredictTheFutureTest is Test {
    PredictTheFuture public predictTheFuture;
    ExploitContract public exploitContract;

    function setUp() public {
        // Deploy contracts
        predictTheFuture = (new PredictTheFuture){value: 1 ether}();
        exploitContract = new ExploitContract(predictTheFuture);
    }

    function testGuess() public {
        // Set block number and timestamp
        // Use vm.roll() and vm.warp() to change the block.number and block.timestamp respectively
        vm.roll(104306);
        vm.warp(93582192);

        for (uint8 i = 0; i < 10; i++) {
            // Make a guess in a new block
            vm.roll(block.number + 1);
            exploitContract.lockNumber{value: 1 ether}(i);

            // Wait for the next block to settle
            vm.roll(block.number + 2);
            exploitContract.settle();

            if (predictTheFuture.isComplete()) {
                // Guess was correct, test should pass
                _checkSolved();
                return;
            }
        }
    
    }

    function _checkSolved() internal {
        assertTrue(predictTheFuture.isComplete(), "Challenge Incomplete");
    }

    receive() external payable {}
}
