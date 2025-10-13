// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title TestSKOL
 * @dev Simplified version of ReputationRegistry for testnet testing
 * @notice Removes restrictions to allow easy testing with multiple wallets
 */
contract TestSKOL {
    // Constants for reputation calculations
    uint256 public constant MAX_REPUTATION = 1000;
    uint256 public constant MIN_REPUTATION = 0;
    uint256 public constant INITIAL_REPUTATION = 500;
    string private info = "Version 0.0.0";

    // Simplified struct
    struct ReputationData {
        uint256 score;
        uint256 totalRatings;
        bool isRegistered;
    }
}
