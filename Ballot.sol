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
  address[] public voterAddresses;
  mapping(address => address) voterContracts;
  mapping(string => uint) voteCount;
  string[] public possibleChoices;
  string public winner;

  modifier onlyOnce {
    require(voterContracts[msg.sender] == 0);
    _;
  }

  event newVote(address owner, address ballotAddress);

  function createVote(string _vote) public onlyOnce payable{
    voterContracts[msg.sender] = new Ballot(_vote).contractAddress();
    voterAddresses.push(msg.sender);
  }

  function tallyVote() private{
    for(uint i = 0; i< voterAddresses.length; i++){
      address contractAddress = voterContracts[voterAddresses[i]];
      string memory vote = Ballot(contractAddress).vote();
      voteCount[vote] += 1;
      possibleChoices.push(vote);
    }
  }

  function determineWinner() private returns (string) {
    uint count = 0;

    for(uint j = 0; j < possibleChoices.length; j++){
      if(voteCount[possibleChoices[j]] > count){
        count = voteCount[possibleChoices[j]];
        winner = possibleChoices[j];
      }
    }

    return winner;
  }

  function resetData() private {
    for(uint i = 0; i< voterAddresses.length; i++){
      address contractAddress = voterContracts[voterAddresses[i]];
      string memory vote = Ballot(contractAddress).vote();
      voteCount[vote] = 0;
    }

    delete possibleChoices;
  }

  function getWinner() public returns (string){
    resetData();
    tallyVote();
    return determineWinner();
  }
}
