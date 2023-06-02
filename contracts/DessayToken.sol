//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DessayToken is ERC20 {
    uint constant INIT_SUPPLY = 100 * (10**18);
    mapping(address => uint) public stakedBalances;
    mapping(address => bool) public isStaked;
    mapping(address => uint) public stakeTimes;
    mapping(address => uint) public userPowers;

    constructor() ERC20("Dessay", "DSY") {
        _mint(msg.sender, INIT_SUPPLY);
    }

    function stakeToken(uint256 amount) public {
        require(
            amount <= balanceOf(msg.sender),
            "Not enough Dessay tokens in your wallet, please try lesser amount"
        );
        require(!isStaked[msg.sender], "You have already staked Dessay tokens");
        approve(msg.sender, amount);
        transferFrom(msg.sender, address(this), amount);
        stakedBalances[msg.sender] = amount;
        stakeTimes[msg.sender] = block.timestamp;
        isStaked[msg.sender] = true;
        userPowers[msg.sender] = amount;
    }

    function unstakeToken(uint256 amount) public {
        require(isStaked[msg.sender], "You have not staked Dessay tokens");
        require(
            block.timestamp >= stakeTimes[msg.sender] + 86400,
            "You can unstake only after 24 hours"
        );
        require(
            amount <= stakedBalances[msg.sender],
            "You can't unstake more than you have staked"
        );
        isStaked[msg.sender] = false;
        stakedBalances[msg.sender] -= amount;
        transfer(msg.sender, amount);
    }

    function getStakedBalance(address user) public view returns (uint) {
        return stakedBalances[user];
    }

    function getStakeTime(address user) public view returns (uint) {
        return stakeTimes[user];
    }

    function getUserPower(address user) public view returns (uint) {
        return userPowers[user];
    }
}