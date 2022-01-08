//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract TwoWeeksAllowance {

    using SafeMath for uint;

    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    uint public maximum = 20 ether;

    function deposit() external payable {
        require(balances[msg.sender] < maximum && balances[msg.sender]+msg.value < maximum);
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp + 2 weeks;
    }

    function lockTimeIncrease(uint _secondsToIncrease) public {
        lockTime[msg.sender] = lockTime[msg.sender].add(_secondsToIncrease);
    }

    function maximumIncrease(uint _amountToIncrease) public {
        require(maximum <= 50 ether, "Off Increase limits");
        maximum += _amountToIncrease;
    }


    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Not Enough Funds");
        require(_amount <= 5 ether);
        require(block.timestamp > lockTime[msg.sender], "2 weeks is not over");

        balances[msg.sender] -= _amount;

        payable(msg.sender).transfer(_amount);

    }
}
// CryptoMarketPool Project