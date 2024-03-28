require("@nomiclabs/hardhat-ethers");
require("dotenv").config(); // Load environment variables from .env file

// Add any other plugins you might be using

module.exports = {
  solidity: {
    version: "0.8.25",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    arbitrumSepolia: {
      url: `https://arbitrum-sepolia.infura.io/v3/${process.env.INFURA_PROJECT_ID}`, // Use the Infura project ID from your .env file
      accounts: [process.env.PRIVATE_KEY].filter(Boolean).map(key => `0x${key}`), // Safely load the private key
      chainId: 421613,
    },
    // You can still keep the zkSync networks here or remove them if not needed
  },
  paths: {
    artifacts: "./artifacts",
    cache: "./cache",
    sources: "./contracts",
    tests: "./test",
  },
};
