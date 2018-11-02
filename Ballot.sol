pragma solidity ^0.4.24;

contract Ballot {
    string public vote;

    constructor (string _vote) public {
        vote = _vote;
    }

    function contractAddress() public view returns (address) {
        return address(this);
    }
}

contract BallotFactory {
    address owner;
    bool isOpen;
    uint64 maxVote;
    string public winner;
    string[] candidates;

    // KYC to prevent multiple votes
    // 0 = Unregistered, 1 = Registered, 2 = Voted
    mapping(address => uint) voterStatus;

    mapping(address => address) voterContracts;
    mapping(string => uint) candidateVotes;

    event newVote(address owner, address ballotAddress);

    modifier canVote {
        require(voterStatus[msg.sender] == 1);
        _;
    }

    modifier onlyOpen {
        require(isOpen);
        _;
    }

    modifier onlyClosed {
        require(!isOpen);
        _;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    constructor (uint64 _maxVote) public {
        owner = msg.sender;
        maxVote = _maxVote;
        isOpen = true;
    }

    function withdraw() public onlyOwner returns(bool) {
        owner.transfer(address(this).balance);
        return true;
    }

    function approveAddress(address _address) public onlyOwner returns(bool) {
        voterStatus[_address] = 1;
        return true;
    }

    function closeBallot() public onlyOwner onlyOpen payable returns(bool){
        // Prevent accidental closing of ballot
        require(msg.value >= 1 ether);

        isOpen = false;

        return true;
    }

    function createVote(string _vote) public canVote onlyOpen returns(bool) {
        Ballot ballot = new Ballot(_vote);
        voterContracts[msg.sender] = ballot.contractAddress();
        voterStatus[msg.sender] = 2;
        candidateVotes[_vote] += 1;
        candidates.push(_vote);

        emit newVote(msg.sender, voterContracts[msg.sender]);

        return true;
    }

  function getWinner() onlyOwner onlyClosed public returns (string) {
    uint count;
    bool tied;
    string memory currentWinner;

    for(uint i=0; i < candidates.length; i++){
        uint currentCount = candidateVotes[candidates[i]];

        if(currentCount > count){
            currentWinner = candidates[i];
            count = currentCount;
            tied = false;
        }else if(currentCount == count){
            tied = true;
        }
    }

    winner = currentWinner;

    return tied ? 'tied' : winner
  }
}
