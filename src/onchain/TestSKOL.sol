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

    // State variables
    mapping(address => ReputationData) private _reputations;
    address[] private _registeredUsers;

    // Events
    event UserRegistered(address indexed user, uint256 initialReputation);
    event ReputationUpdated(address indexed user, uint256 oldScore, uint256 newScore, address indexed rater);

    /**
     * @dev Register a new user (anyone can call)
     * @param user Address of the user to register
     */
    function registerUser(address user) public {
        // Allow re-registration for testing
        if (!_reputations[user].isRegistered) {
            _registeredUsers.push(user);
        }

        _reputations[user] = ReputationData({score: INITIAL_REPUTATION, totalRatings: 0, isRegistered: true});

        emit UserRegistered(user, INITIAL_REPUTATION);
    }

    /**
     * @dev Register yourself
     */
    function registerSelf() public {
        registerUser(msg.sender);
    }

    /**
     * @dev Update a user's reputation (anyone can call, including self-rating)
     * @param user Address of the user being rated
     * @param rating New rating score (0-1000)
     */
    function updateReputation(address user, uint256 rating) public {
        // Auto-register if not registered
        if (!_reputations[user].isRegistered) {
            registerUser(user);
        }

        // Auto-register rater if not registered
        if (!_reputations[msg.sender].isRegistered) {
            registerUser(msg.sender);
        }

        // Clamp rating to valid range
        if (rating > MAX_REPUTATION) {
            rating = MAX_REPUTATION;
        }

        ReputationData storage userData = _reputations[user];
        uint256 oldScore = userData.score;

        // Simple average calculation
        userData.totalRatings += 1;
        userData.score = ((userData.score * (userData.totalRatings - 1)) + rating) / userData.totalRatings;

        emit ReputationUpdated(user, oldScore, userData.score, msg.sender);
    }

    /**
     * @dev Give a positive rating (800 points)
     * @param user Address of the user being rated
     */
    function givePositiveRating(address user) external {
        updateReputation(user, 800);
    }

    function giveNegativeRating(address user) external {
        updateReputation(user, 200);
    }
}
