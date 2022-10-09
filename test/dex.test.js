const Dex = artifacts.require("Dex.sol");
const TestTokenDex = artifacts.require("TestTokenDex");

contract('Dex', (accounts) => {
    let dex, testTokenDex;

    beforeEach(async () =>{
        testTokenDex = await TestTokenDex.new();
        dex = await Dex.new(testTokenDex.address);

        //transfer all tokens to dex smart contract
        await testTokenDex.transfer(dex.address, '50000000000000000');

    })

    describe('Contract Deployment', async () => {
        it('dex smart contract should have all tokens', async () => {
            const balance = await testTokenDex.balanceOf(dex.address);
            assert(balance.toString() === '50000000000000000');
        });
    })

    describe('Decentralized Exchange', async() => {
        it('should allow a user buy tokens', async () => {

            await dex.buyTTD({from: accounts[1], value: 30000});
            const userBalance = await testTokenDex.balanceOf(accounts[1]);
            //300 is equal to 3TTD remebering 2 decimals
            assert(userBalance.toString() === "300");
            const numOfBuys = await dex.numOfBuys();
            assert(numOfBuys.toString() === "1");
        });

        it('should allow a user sell tokens', async () => {
            await dex.buyTTD({from: accounts[1], value: 30000});
            await testTokenDex.approve(dex.address, 100, {from: accounts[1]});
            await dex.sellTTD(100, {from: accounts[1]});
            const userBalance = await testTokenDex.balanceOf(accounts[1]);
            assert(userBalance.toString() === "200");
            const numOfSells = await dex.numOfSells();
            assert(numOfSells.toString() === "1");
        })
    })
})