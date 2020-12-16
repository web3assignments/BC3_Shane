const game = artifacts.require("Gachagang");

module.exports = function(deployer) {
	deployer.deploy(game);
};