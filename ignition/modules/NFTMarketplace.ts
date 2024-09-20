// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const NftMarketplaceModule = buildModule("NFTMarketplaceModule", (m) => { 

  const nftMarketplaceModule = m.contract("NFTMarketplace");

  return { nftMarketplaceModule };
});

export default NftMarketplaceModule;
