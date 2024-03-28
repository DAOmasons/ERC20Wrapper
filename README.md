# ERC20 Wrapper (wERC20) Contract

![](/images/ethRapper.png)

```
//  ██████╗  █████╗  ██████╗     ███╗   ███╗ █████╗ ███████╗ ██████╗ ███╗   ██╗███████╗
//  ██╔══██╗██╔══██╗██╔═══██╗    ████╗ ████║██╔══██╗██╔════╝██╔═══██╗████╗  ██║██╔════╝
//  ██║  ██║███████║██║   ██║    ██╔████╔██║███████║███████╗██║   ██║██╔██╗ ██║███████╗
//  ██║  ██║██╔══██║██║   ██║    ██║╚██╔╝██║██╔══██║╚════██║██║   ██║██║╚██╗██║╚════██║
//  ██████╔╝██║  ██║╚██████╔╝    ██║ ╚═╝ ██║██║  ██║███████║╚██████╔╝██║ ╚████║███████║
//  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝     ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
//                                                                                     
```

The ERC20 Wrapper (wERC20) contract is a Solidity project designed to wrap ERC20 tokens, allowing them to be used in a variety of applications. This repository contains the code for the wARB contract along with instructions on how to deploy and interact with it.

## Getting Started

To use this contract as a foundation for your project, you can create a new project using the following command:

```shell
npx thirdweb create --contract --template hardhat-javascript-starter
```

After creating your project, you can find the wARB contract in `contracts/wERC20.sol`. This is your main contract file, and you can start by reviewing and customizing its contents as needed.

To enhance your contracts further, consider utilizing the `@thirdweb-dev/contracts` package, which offers a suite of base contracts and extensions. This package is pre-installed and allows for easy integration of additional features and utilities. Learn more about these options in the [Contracts Extensions Docs](https://docs.thirdweb.com/contracts).

## Building the Project

Whenever you make changes to your contract, compile it to ensure everything is correct:

```shell
npm run build
# or
yarn build
```

This step compiles your Solidity contracts and checks for any compatibility with the Contracts Extensions Docs.

## Deploying Contracts

Once your contract is ready for deployment, execute one of the following commands to deploy it to the network:

```shell
npm run deploy
# or
yarn deploy
```

Ensure you have configured your deployment scripts and network settings in `hardhat.config.js` before running these commands.

## Releasing Contracts

To publish a version of your contracts for public use, you can use the following commands. This step is particularly useful if you want to share your contract with a wider audience or for production use:

```shell
npm run release
# or
yarn release
```

---

