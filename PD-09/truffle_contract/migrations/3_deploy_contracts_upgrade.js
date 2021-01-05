const { deployProxy, upgradeProxy } = require('@openzeppelin/truffle-upgrades');
const game = artifacts.require("Gachagang");
const gameV2 = artifacts.require("GachagangV2");

module.exports = async function(deployer) {
    const gameOld = await game.deployed();
    const gameNew = await upgradeProxy(gameOld.address, gameV2, {deployer, unsafeAllowCustomTypes: true});
    console.log('Old', gameOld.address);
    console.log('New', gameNew.address);
}