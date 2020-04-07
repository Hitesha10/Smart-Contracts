// Ballot;

pragma solidity ^0.4.0;
contract ballot{
    struct voter{
        uint weight;//weighttage of the vote;
        bool voted;
        uint8 vote;//whom they vote;
        address delegate;
    }
    struct proposal{
        uint voteCount;
    }
    enum Stage{init,reg,vote,done}
    Stage public stage=Stage.init;
    uint startTime;

    address chairperson;
    mapping(address=>voter)voters;
    proposal[] proposals;
    
    modifier validstage(Stage reqstage){
        require(stage==reqstage);
        _;
    }
    event votingCompleted();
    function ballot(uint _numofproposals) public{
        chairperson=msg.sender;
        voters[chairperson].weight=2; 
        proposals.length=_numofproposals;
        stage=Stage.reg;
        startTime=now;
    }
    function register(address tovoter) public validstage(Stage.reg){
        //if(stage!=Stage.reg)
        //return;
        if(msg.sender!=chairperson || voters[tovoter].voted)
        return;
        voters[tovoter].weight=1;
        voters[tovoter].voted=false;
        if(now>startTime+20 seconds)
        {
            stage=Stage.vote;
        //    startTime=now;
        }
    }
    function vote(uint8 toproposal)public validstage(Stage.vote){
        //if(stage!=Stage.vote)
        //return;
        if(voters[msg.sender].voted||toproposal>=proposals.length)
        return;
        proposals[toproposal].voteCount+=voters[msg.sender].weight;
        voters[msg.sender].voted=true;
        voters[msg.sender].vote=toproposal;
        if(now>startTime+20 seconds)
        {
            stage=Stage.done;
            votingCompleted();
        }
    }
    function winningproposal() public constant returns (uint _winningproposal){
        if(stage!=Stage.done)
        return;
        uint256 winningvotes=0;
        for(uint i=0;i<proposals.length;i++){
            if(proposals[i].voteCount>winningvotes)
            {
                winningvotes=proposals[i].voteCount;
                _winningproposal=i;
            }
            assert(winningvotes>0);
        }
    }
}
