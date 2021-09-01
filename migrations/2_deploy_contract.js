// Takes the marketplece contract and put it to the blockchain
// migrating the database from state to another by putting a new smart contract 
const Marketplace = artifacts.require("Marketplace");

module.exports = function(deployer) {
  deployer.deploy(Marketplace);
};
