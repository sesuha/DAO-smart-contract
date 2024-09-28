// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract DAO {
    // Structure for a proposal
    struct Proposal {
        string description;
        uint votesFor;
        uint votesAgainst;
        uint endTime;
        bool executed;
    }

    address public owner;
    uint public proposalCount = 0;
    mapping(uint => Proposal) public proposals;
    mapping(address => bool) public members;
    mapping(address => mapping(uint => bool)) public voted;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier onlyMembers() {
        require(members[msg.sender], "Only members can vote");
        _;
    }

    constructor() {
        owner = msg.sender;
        members[owner] = true; // Owner is the first member
    }

    // Add a new member
    function addMember(address _member) public onlyOwner {
        members[_member] = true;
    }

    // Create a new proposal
    function createProposal(string memory _description, uint _duration) public onlyMembers {
        proposals[proposalCount] = Proposal({
            description: _description,
            votesFor: 0,
            votesAgainst: 0,
            endTime: block.timestamp + _duration,
            executed: false
        });
        proposalCount++;
    }

    // Vote on a proposal
    function vote(uint _proposalId, bool _support) public onlyMembers {
        require(!voted[msg.sender][_proposalId], "Already voted on this proposal");
        require(block.timestamp < proposals[_proposalId].endTime, "Voting period has ended");

        voted[msg.sender][_proposalId] = true;

        if (_support) {
            proposals[_proposalId].votesFor++;
        } else {
            proposals[_proposalId].votesAgainst++;
        }
    }

    // Execute a proposal if voting period has ended
    function executeProposal(uint _proposalId) public {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp >= proposal.endTime, "Voting period not ended");
        require(!proposal.executed, "Proposal already executed");

        if (proposal.votesFor > proposal.votesAgainst) {
            // Code to execute proposal goes here
        }

        proposal.executed = true;
    }
}
