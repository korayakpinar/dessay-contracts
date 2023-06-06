# Dessay

Dessay is a blockchain-based content sharing and voting platform built on Ethereum. It includes two smart contracts: DessayToken and Dessay. Users can enter their writings, vote on other writings, add comments, and stake Dessay tokens. The platform aims to provide a decentralized and incentivized ecosystem for content creators and readers.

## Contracts

### DessayToken

DessayToken is an ERC-20 compliant token contract representing the native currency of the Dessay platform. It allows users to create, transfer, and stake Dessay tokens. The contract implements features such as staking, unstaking, and calculating user power based on staked token amounts.

### Dessay

Dessay is the main smart contract that powers the content sharing and voting functionalities of the Dessay platform. It enables users to publish their writings, vote on writings from others, add comments, and interact with the community. The contract includes various features and mappings to facilitate content organization, user interactions, and badge distribution.

## Installation

To run the Dessay project locally, follow these steps:

1. Clone the project repository: ```git clone https://github.com/korayakpinar/dessay.git```

2. Navigate to the project directory: ```cd dessay```

3. Install the required packages: ```npm install```

## Testing

To run the tests for Dessay contracts, use the following command in the project directory: npx hardhat test

This will execute the test script, which verifies the functionalities of the DessayToken and Dessay contracts.

## Deployment

To deploy the DessayToken and Dessay contracts to an Ethereum network, follow these steps:

1. Update the deployment script `scripts/deploy.js` with the desired network configuration if needed.

2. Run the deployment script using the following command: ```npx hardhat run scripts/deploy.js --network <network-name>```

Replace `<network-name>` with the name of your target Ethereum network (e.g., `rinkeby` or `mainnet`).

This command will deploy the DessayToken and Dessay contracts to the specified network and provide the contract addresses upon successful deployment.

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for more details.









