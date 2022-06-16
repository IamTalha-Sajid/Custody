// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staking {

    struct stake{
        address userId;
        uint amount;
        uint _stakingtime;
        bool staked;
        uint _minStakeTime;
    }

    IERC20 public token;
    mapping (address => stake) stakes;
    address owner;          //Owner of the Contract
    uint256 minStakeTime;   //Minimum Time before User Cannot Unstake Tokens
    uint256 minStakeAmount; //Minimum Amount of CUstodiy Tokens user need to stake 
    uint256 rewardPerHour;  //CUstodiy Token Reward for Staking 

    constructor() {
        owner = msg.sender;
    }

    /*    OWNER FUNCTIONS     */

    //Give Address of CUstodiy Token
    function setERC20Token(address _token) public returns (bool){
        require(msg.sender == owner, "Only Owner can set Token");
        token = IERC20(_token);
        return true;
    }

    //Set Time in Seconds
    function setMinimumStakingTime (uint256 _time) public returns (bool){
        require(msg.sender == owner, "Only Owner can set Token");
        minStakeTime = _time;
        return true;
    }

    //Set CUstodiy Token Amount
    function setMinimumStakingAmount (uint256 _amount) public returns (bool){
        require(msg.sender == owner, "Only Owner can set Token");
        minStakeAmount = _amount;
        return true;
    }

    //Set Amount of Reward
    function setStakingRewardPerHour (uint256 _reward) public returns (bool){
        require(msg.sender == owner, "Only Owner can set Token");
        rewardPerHour = _reward;
        return true;
    }

    //Check Total Staked Tokens
    function checkTotalStakedToken () public view returns (uint256) {
        require(msg.sender == owner, "Only Owner can set Token");
        return token.balanceOf(address(this));
    }

    /*      USERS FUNCTIONS     */

    //Function to Add Stake
    function addStake(address _userId, uint _amount) public returns (bool){
        require (stakes[_userId].staked == false, "You have Already Staked Token");
        require (_amount <= token.balanceOf(_userId), "You can't Stake More than You Own");
        require (token.allowance(_userId, address(this)) >= _amount, "Not Approved the Contract to use Tokens");
        uint256 time = block.timestamp + minStakeTime;
        stakes[_userId] = stake(_userId, _amount, block.timestamp, true, time);
        token.transferFrom(_userId, address(this), _amount);
        return true;
    }

    //User will be Rewarded ERC20 Tokens Based on Time he Staked for
    function reward(address _userId, uint256 _amount) private {
        token.transferFrom(owner, _userId, _amount);
    }

    //Check How many Tokens a User have Staked
    function checkStakedToken (address _userId) public view returns (uint){
        return stakes[_userId].amount;
    }

    //Remove Stake and Reward
    function removeStake (address _userId) public returns (bool){
        require(stakes[_userId].staked = true, "You Have Not Staked Any Tokens");
        require(block.timestamp >= stakes[_userId]._minStakeTime, "No Reward for Staking Less than Minimum Time");
        uint256 unStakeTime = block.timestamp;
        uint256 totalStakeTime = unStakeTime - stakes[_userId]._stakingtime;
        uint256 totalStakeTimeInHr = totalStakeTime/3600;
        uint256 rewardToken = totalStakeTimeInHr * rewardPerHour;
        token.transferFrom(address(this), _userId, stakes[_userId].amount);
        reward(_userId, rewardToken);
        stakes[_userId].amount = 0;
        stakes[_userId]._stakingtime = 0;
        stakes[_userId].staked = false;
        return true;
    }
}
