const Dex = artifacts.require("Dex.sol");
const TestTokenDex = artifacts.require("TestTokenDex.sol");

module.exports = async function(deployer) {

    await deployer.deploy(TestTokenDex);
    const _testTokenDex = await TestTokenDex.deployed();

    await deployer.deploy(Dex, _testTokenDex.address);
    const _dex = await Dex.deployed();

    //transfer total supply of TTD to Dex smart contract
    await _testTokenDex.transfer(_dex.address, '50000000000000000');
}