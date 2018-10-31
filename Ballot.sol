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
  mapping(address => address) voterContracts;

  string[] candidates;
  mapping(string => uint) candidateVotes;

  uint64 maxVote;

  event newVote(address owner, address ballotAddress);

  modifier onlyOnce {
    require(voterContracts[msg.sender] == 0);
    _;
  }

  constructor (uint64 _maxVote) public {
      maxVote = _maxVote;
  }

  function createVote(string _vote) public onlyOnce payable{
    Ballot ballot = new Ballot(_vote);
    voterContracts[msg.sender] = ballot.contractAddress();
    candidateVotes[_vote] += 1;
    candidates.push(_vote);
  }

  function getWinner() public view returns (string) {
    uint count;
    string memory winner;
    bool tied;

    for(uint i=0; i < candidates.length; i++){
        uint currentCount = candidateVotes[candidates[i]];

        if(currentCount > count){
            winner = candidates[i];
            count = currentCount;
        }
        // Bugged
        if(currentCount == count){
          tied = true;
        }
    }

    return tied ? 'Tied' : winner;
  }

}
