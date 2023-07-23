require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.8.19",
  networks: {
    ropsten: {
      url: "https://goerli.infura.io/v3/1c2959aaaaea48b29dcbd39b41844ef0", // Replace with your Infura project ID
      accounts: [`0x55A76042391Fbe0a268B6903B9caA2E974AE35c8`], // Add your private key as an environment variable
    },
  },
};
