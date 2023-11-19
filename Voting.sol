// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting  {

    address owner;
    uint id;
    uint Variants;
    address Can1;
    address Can2;
    address Can3;
    uint constant DURATION = 1 days;
    uint startAt;
	uint endsAt;

    struct User {
        uint ID;
        string name;
        address addr;
    }

    mapping (uint => User) public  Users;
    mapping (address => bool) private isUserAddress;
    mapping (address => uint) public Candidates;
    mapping (address => bool) private isUserVoted;

    modifier onlyOwner() {
        require (msg.sender == owner, "not an owner");
        _;
    }
    modifier onlyRegisteredUser() {
        require(isUserAddress[msg.sender], "User is not registered");
        _;
    }
    modifier votingTime() {
        require(block.timestamp < endsAt, "the voting has already been completed");
        _;
    }

    event Registered (uint _id, string _name, address _addr, string _message);
    event Voted (string _message, uint _number);

    constructor() {
        owner = msg.sender;
        startAt = block.timestamp;
        endsAt = startAt + DURATION;
    }

    function addCandidates(address _can1, address _can2, address _can3) public onlyOwner {
        Can1 = _can1;
        Can2 = _can2;
        Can3 = _can3;
    }

    function saveUser(string memory _name) public votingTime {
        require(!isUserAddress[msg.sender] , "User already exists");
        id++;
        User memory newUser = User (id, _name, msg.sender );
        Users[id] = newUser;
        isUserAddress[msg.sender] = true;
        string memory registered = "you are registered" ;

        emit Registered(id, _name, msg.sender, registered);    
    }

    function voting ( uint _numberCandidate) public onlyRegisteredUser votingTime { 
        require(!isUserVoted[msg.sender] , "User has already voted"); 
        if (_numberCandidate == 1) {
            Candidates[Can1]++;
        }else if (_numberCandidate == 2) {
            Candidates[Can2]++;
        }else if (_numberCandidate == 3) {
            Candidates[Can3]++;
        }else {
            revert("incorrect number");
        }   
        isUserVoted[msg.sender] = true; 
        string memory voted = "you have successfully voted for candidate number";

        emit Voted(voted, _numberCandidate); 
    }

    function result() public view returns(uint, uint, uint) {
        return (Candidates[Can1], Candidates[Can2], Candidates[Can3]);
    } 
}