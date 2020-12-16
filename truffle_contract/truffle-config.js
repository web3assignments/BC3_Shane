const HDWalletProvider = require('@truffle/hdwallet-provider');

const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();

module.exports = {
	compilers: {
		solc: {
			version: "^0.6"
		}
	},

  networks: {
    //development: {
    //  host: "127.0.0.1",     // Localhost (default: none)
    //  port: 7545,            // Standard Ethereum port (default: none)
    //  network_id: "*",       // Any network (default: none)
    //},
	
	rinkeby: {
      provider: () => new HDWalletProvider(mnemonic, 'https://rinkeby.infura.io/v3/f67df5925aac401cbefe7bd8a0e0d282'),
      network_id: 4,
      gas: 5500000,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    }
  },
};
