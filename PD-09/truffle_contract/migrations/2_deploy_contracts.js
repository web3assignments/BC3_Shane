const game = artifacts.require("Gachagang");
const { deployProxy } = require('@openzeppelin/truffle-upgrades');

module.exports = async function(deployer) {
	const instance = await deployProxy(game, { deployer, unsafeAllowCustomTypes: true });
	console.log('Deployed', instance.address);
};