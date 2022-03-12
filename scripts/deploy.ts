// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Burnable = await ethers.getContractFactory("Burnable");
  const burnable = await Burnable.deploy();

  await burnable.deployed();

  // const Burnable = await ethers.getContractFactory("Burnable");
  // const c = await Burnable.attach("0xe7f1725e7734ce288f8367e1bb143e90bb3f0512")
  // const url =
  //   "https://ipfs.infura.io/ipfs/QmQpCpJgeMZ8UDqGgtkZX7PeoxLmyh2BcWBA28GXM9bYND";
  // await contract.mintBurnable(url, { value: ethers.utils.parseEther("1") });

  console.log("Burnable deployed to:", burnable.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
