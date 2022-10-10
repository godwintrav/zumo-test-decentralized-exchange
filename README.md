# zumo-test-decentralized-exchange
1. Smart Contract Overview

STATE VARIABLES:
Below are the state variables in the Dex Smart Contract.

name: This is a state variable that stores the name of the Decentralized Exchange. It has a public access modifier so by default solidity creates a view function to get the value of the variable.

owner: This is a state variable that stores the address of the account that deployed the smart contract. The address is assigned in the constructor of the smart contract.

numOfBuys: This is a state variable that stores the number of buy orders that has been executed in the smart contract. The value is incremented at the end of the buyTTD() function. It has a public access modifier so by default solidity creates a view function to get the value of the variable.

numOfSells: This is a state variable that stores the number of sell orders that has been executed in the smart contract. The value is incremented at the end of the sellTTD() function. It has a public access modifier so by default solidity creates a view function to get the value of the variable.

buyRate: This is a state varibale that stores the rate of 1 TTD token to ETH in wei for buy orders. It has a public access modifier so by default solidity creates a view function to get the value of the variable.

sellRate: This is a state varibale that stores the rate of 1 TTD token to ETH in wei for sell orders. It has a public access modifier so by default solidity creates a view function to get the value of the variable.

testTokenDexBits: This is a state variable that stores the smallest denomination of TTD, since TTD has a decimal of two, 1TTD is the same thing as 100TTDBits. This is similar to how wei is the smallest denomination to eth. This variable is used for accurate calculations of tokens.

testTokenDex: This a state variable of type TestTokenDex which is the the erc20 contract of our TestTokenDex. This variable stores the reference to our erc20 token. This variable is initialized in the constructor of the dex contract by the address of the deployed TestTokenDex contract.

FUNCTIONS:

buyTTD(): This function is responsible for handling buy orders in the dex contract.
It gets the msg.value that was sent and checks if it's greater than 0 to ensure the contract is not sent 0 wei.
Then it converts the amount of TTD tokens the user wants to buy to TTDBits which if you remember is the smallest denomination of the TTD token.
It gets the amount of TTD tokens the user wants in TTDBits by multiplying the amount sent in wei by the variable testTokenDexBits and dividing the result by the  buyRate.
After getting the amount of tokens the user wants in TTDBits, we then require it to be less than or equal to the available Tokens.
Then after we transfer the amount of TTD tokens in the dex contract to the user address which is msg.sender through the transfer() function in the TTD token contract and then we send half of the amount of wei (msg.value) the user sent to pay for the TTD Tokens to the owner address and then we increment the numOfBuys variable by 1.

sellTTD(): This function is responsible for handling sell orders in the dex contract. This function has one arguement which is the amount of token to be sold in TTDbits the smallest denomination of TTD Token. It checks if the amount is greater than 0. Then we get the user TTD token balance and check if the amount the user wants to sell is less than or equal to the user TTD token balance. Then we use the transferFrom function() in the TTD token contract to transfer the tokens from the user account on his behalf to the dex contract. NOTE: the transferFrom() function can only be successful if the user has approved the dex contract to spend it's token through the approve() function from the TTD token contract. Then we convert the token amount to the wei equivalent using the sell rate then send the wei to the user account and then we increment the numOfSells by 1.

getUserTestTokenDexBalance(): This function gets the TTD Token balance of the msg.sender.

getTestTokenDexContractAddress(): This function gets the TTD Token contract address.

getMaximumExchangeSizeForBuy(): This function returns the maximum exchange size for buy orders which is the total number of TTD tokens the dex contract has available.

getMaximumExchangeSizeForSell(): This function returns the maximum exchange size for sell orders which is the total number of ETH the dex contract has available.


DEPLOYMENT PROCESS:


Firstly run npm i in the terminal to install all the required packages

run the command: truffle develop in the terminal to open the development console so we can run our tests to ensure the smart contract is working the way we want.
Type in test in the truffle develop console to run the tests.

In the truffle.config.js:
To deploy to the Goerli testnet we need the Goerli RPC endpoint URL(you can get one from Infura Node Provider) then we add it to the goerli object in the networks object, also we need the private key of the address which is going to deploy the contract(store the private key in a safe location) and call in the goerli object, we also need the network id depending on the test network you are deploying to, for Goerli it is 5.

In your terminal type in the command 
truffle migrate --network goerli

Then truffle runs the deploy scripts in the migrations folder of the project in numerical order with.
the command --network tells truffle what network to deploy the smart contract to.
Now the smart contract is deployed to the Goerli test network. Thank you.
