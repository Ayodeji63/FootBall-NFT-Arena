// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Import other required contracts and libraries
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract VirtualMatch {
    struct Player {
        address nftAddress;
        uint256 playerId;
    }
    // Variables to store match details

    struct Match {
        uint256 matchId;
        uint256 startTime;
        uint256 endTime;
        mapping(uint => Player) teamAPlayers; // List of NFT IDs representing players of Team A
        mapping(uint => Player) teamBPlayers; // List of NFT IDs representing players of Team B
        uint256 teamAScore;
        uint256 teamBScore;
        bool matchComplete;
    }

    /** State Variable */
    Match[] public matches;
    uint256 private matchCount;
    address private immutable i_platformAdmin; // Address of the platform admin to manage matches
    bytes32 internal keyHash;
    uint256 internal fee;

    /** Events */
    event MatchCreated(uint256 matchId, uint256 startTime, uint256 endTime);
    event MatchJoined(
        uint256 matchId,
        Player[] teamAPlayers,
        Player[] teamBPlayers
    );
    event MatchOutcome(uint256 matchId, uint256 teamAScore, uint256 teamBScore);

    // Modifiers to manage access control
    modifier onlyAdminOrPlayer() {
        require(msg.sender == i_platformAdmin, "Not authorized.");
        _;
    }

    constructor(address _platformAdmin) {
        i_platformAdmin = _platformAdmin;
    }

    // Function to propose a new virtual match
    function proposeMatch(
        uint256 _startTime,
        uint256 _endTime,
        Player[] calldata _teamAPlayers
    ) external payable {
        require(_teamAPlayers.length == 11, "Invalid player list.");
        require(_startTime > block.timestamp, "Invalid start time.");

        Match memory newMatch = Match({
            matchId: matchCount,
            startTime: _startTime,
            endTime: _endTime,
            teamAPlayers: _teamAPlayers,
            teamBPlayers: new Player[](0), // Empty teamBPlayers array initially
            teamAScore: 0,
            teamBScore: 0,
            matchComplete: false
        });

        matches.push(newMatch);
        matchCount++;

        emit MatchCreated(
            newMatch.matchId,
            newMatch.startTime,
            newMatch.endTime
        );
    }

    // Function for player2 to join an existing match
    function joinMatch(
        uint256 _matchId,
        Player[] calldata _teamBPlayers
    ) external payable {
        require(_matchId < matchCount, "Invalid match ID.");
        require(
            matches[_matchId].teamBPlayers.length == 0,
            "Match is already full."
        );
        require(_teamBPlayers.length > 0, "Invalid player list.");

        matches[_matchId].teamBPlayers = _teamBPlayers;

        emit MatchJoined(
            _matchId,
            matches[_matchId].teamAPlayers,
            _teamBPlayers
        );
    }

    // Function to simulate a virtual match and determine the outcome
    // function simulateMatchOutcome(uint256 _matchId) external onlyAdminOrPlayer(_matchId) {
    //     require(_matchId < matchCount, "Invalid match ID.");
    //     Match storage currentMatch = matches[_matchId];
    //     require(!currentMatch.matchComplete, "Match outcome already determined.");

    //     // Fetch real-life player performance data using Chainlink VRF
    //     bytes32 requestId = requestRandomness(keyHash, fee);

    //     // Store the requestId and matchId mapping to link the random result to the specific match
    //     // Chainlink VRF will call the fulfillRandomness function with the random number
    //     // for the requestId, which will determine the match outcome.

    //     // You may need to implement the fulfillRandomness function to calculate the match outcome.
    //     // For simplicity, let's assume it's called by Chainlink VRF with a random number between 0 and 100.
    // }

    // // Callback function to receive the random number from Chainlink VRF
    // function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
    //     // Implement logic to determine the match outcome based on the randomness received
    //     // For simplicity, let's assume the randomness is a percentage and determines the scores.

    //     uint256 matchId = /* Get matchId from requestId mapping */;
    //     Match storage currentMatch = matches[matchId];
    //     currentMatch.teamAScore = randomness;
    //     currentMatch.teamBScore = 100 - randomness;
    //     currentMatch.matchComplete = true;

    //     emit MatchOutcome(matchId, currentMatch.teamAScore, currentMatch.teamBScore);
    // }

    /******** Views And Pure Functions  ************/
    // Function to get match details by match ID
    function getMatchDetails(
        uint256 _matchId
    )
        external
        view
        returns (
            uint256 startTime,
            uint256 endTime,
            Player[] memory teamAPlayers,
            Player[] memory teamBPlayers,
            uint256 teamAScore,
            uint256 teamBScore,
            bool matchComplete
        )
    {
        require(_matchId < matchCount, "Invalid match ID.");
        Match storage currentMatch = matches[_matchId];

        return (
            currentMatch.startTime,
            currentMatch.endTime,
            currentMatch.teamAPlayers,
            currentMatch.teamBPlayers,
            currentMatch.teamAScore,
            currentMatch.teamBScore,
            currentMatch.matchComplete
        );
    }

    // Function to check if a player is in a match
    function isPlayerInMatch(
        uint256 _matchId,
        uint256 player
    ) internal view returns (bool) {
        Match storage currentMatch = matches[_matchId];
        for (uint256 i = 0; i < currentMatch.teamAPlayers.length; i++) {
            if (currentMatch.teamAPlayers[i].playerId == player) {
                return true;
            }
        }
        for (uint256 i = 0; i < currentMatch.teamBPlayers.length; i++) {
            if (currentMatch.teamBPlayers[i].playerId == player) {
                return true;
            }
        }
        return false;
    }

    function getPlatformAdmin() external view returns (address) {
        return i_platformAdmin;
    }
}
