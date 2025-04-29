// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SecretSharing {
    address public admin;
    mapping(address => bytes32) public shares;
    address[] public participants;
    uint256 public threshold;
    uint256 public totalShares;
    uint256 public revealedCount;
    mapping(address => bool) public hasRevealed;
    string public reconstructedSecret;

    event ShareStored(address indexed participant);
    event ShareRevealed(address indexed participant);
    event SecretReconstructed(string secret);

    constructor(uint256 _threshold, uint256 _totalShares) {
        admin = msg.sender;
        threshold = _threshold;
        totalShares = _totalShares;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    function storeShare(address participant, bytes32 share) external onlyAdmin {
        require(shares[participant] == bytes32(0), "Share exists");
        shares[participant] = share;
        participants.push(participant);
        emit ShareStored(participant);
    }

    function revealShare() external {
        require(shares[msg.sender] != bytes32(0), "No share");
        require(!hasRevealed[msg.sender], "Already revealed");
        
        hasRevealed[msg.sender] = true;
        revealedCount++;
        emit ShareRevealed(msg.sender);
    }

    function reconstructSecret(string calldata _secret) external onlyAdmin {
        require(revealedCount >= threshold, "Insufficient reveals");
        reconstructedSecret = _secret;
        emit SecretReconstructed(_secret);
    }

    function getParticipants() external view returns (address[] memory) {
        return participants;
    }
    function getRevealedCount() public view returns (uint256) {
    return revealedCount;
}

}
