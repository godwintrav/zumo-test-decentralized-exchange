// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './TestTokenDex.sol';

contract Dex {
    string public name = 'Dex';
    address private owner;
    uint public numOfBuys;
    uint public numOfSells;
    //1TTD = 10000wei for buy order
    //1TTD with a decimal of 2 = 1 * 10 ^ 2 which is 100TTDbits;
    //100TTDbits = 10000 wei for buy order
    uint16 public buyRate = 10000;
    //1TTD = 5000 for sell
    //1TTD with a decimal of 2 = 1 * 10 ^ 2 which is 100TTDbits;
    //100TTDbits = 5000 wei for sell order
    uint16 public sellRate = 5000;
    // testTokenDexBits = 100 because 1TDD = 1 * 10 ^ 2. with 2 being the decimals
    //1TDD = 100testTokenDexBits
    uint testTokenDexBits = 100;
    


    TestTokenDex public testTokenDex;

    constructor(TestTokenDex _testTokenDex) {
        testTokenDex = _testTokenDex;
        owner = msg.sender;
    }


    function buyTTD() public payable{
        //this is the amount of TTD tokens the user wants to buy in wei
        uint amountToBuyInWei = msg.value;
        //check if the user sent some wei
        require(amountToBuyInWei > 0, "You have to send some ether");
        //convert amountToBuyInWei to TTDbits which is the smallest denomination of TTD since it has a decimal of 2
        uint amountToBuyInTTDBits = (amountToBuyInWei * testTokenDexBits) / buyRate;
        //get balance of dex TTD tokens
        uint testTokenDexBalance = testTokenDex.balanceOf(address(this));
        //check if balance of dex is enough for how much TTD tokens the user wants to buy
        require(amountToBuyInTTDBits <= testTokenDexBalance, "Not enough TestTokenDex in supply");
        //transfer TTD tokens to the user addres
        testTokenDex.transfer(msg.sender, amountToBuyInTTDBits);
        // transfer half of wei to owner address
        uint amountOfWeiToTransferToOwner = amountToBuyInWei / 2;
        (bool success, ) = owner.call{value: amountOfWeiToTransferToOwner}("");
        require(success, "Failed to send wei to the user");
        numOfBuys++;
    }

function sellTTD(uint amount) public{
        require(amount > 0, "amount must be greater than zero");
        //get user TTD token balance in bits
        uint userBalance = testTokenDex.balanceOf(msg.sender);
        //check if user has enough TTD tokens in bits to sell
        require(amount <= userBalance, "Insufficient Funds");
        //transfer user tokens to dex address
        testTokenDex.transferFrom(msg.sender, address(this), amount);
        //transfer wei to user address
        //Convert amount from bits to TDD remembering the 2 decimals
        uint amountInWeiToTransferToUser = (sellRate * amount) / testTokenDexBits;
        (bool success, ) = msg.sender.call{value: amountInWeiToTransferToUser}("");
        require(success, "Failed to send wei to the user");
        numOfSells++;
    } 

    function getUserTestTokenDexBalance() public view returns(uint256) {
        return testTokenDex.balanceOf(msg.sender);
    }

    function getTestTokenDexContractAddress() public view returns(address){
        return address(testTokenDex);
    }

    function getMaximumExchangeSizeForBuy() public view returns(uint256){
        return testTokenDex.balanceOf(address(this));
    }

    function getMaximumExchangeSizeForSell() public view returns(uint256){
        return address(this).balance;
    }

    
    


}