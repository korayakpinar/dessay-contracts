// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const DessayToken = await ethers.getContractFactory("DessayToken");
  const dessayToken = await DessayToken.deploy();
  await dessayToken.deployed();
  console.log("DessayToken deployed to:", dessayToken.address);

  const Dessay = await ethers.getContractFactory("Dessay");
  const dessay = await Dessay.deploy(dessayToken.address);
  await dessay.deployed();
  console.log("Dessay deployed to:", dessay.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });


