# Weipoint Verified Identities

Ethereum smart contracts to store verified address identities. Currently storing Keybase identities that have been linked to Ethereum Addresses on Weipoint. The public interface can be used to retrieve a userID given an address, as well as an address given a userID. 

[Medium Post](https://medium.com/weipoint/weipoint-identity-link-edacbdde7ca6)

See PublicInterface.sol for the public interface for dApps and other smart contracts

## Rinkeby Testnet

Currently live on the Rinkeby Testnet at `0x23d94891ba51b6d677f614aaaa6eadbd5890ef6a`

IdentityRepo - [0x8f906a6f5973e5602754fdc438a5faef80983a12](https://rinkeby.etherscan.io/address/0x8f906a6f5973e5602754fdc438a5faef80983a12)

OwnedIdentityStore - [0xe81e67f324aa1257a17dcba71953113fc063067c](https://rinkeby.etherscan.io/address/0xe81e67f324aa1257a17dcba71953113fc063067c)

IdentityProxy - [0x23d94891ba51b6d677f614aaaa6eadbd5890ef6a](https://rinkeby.etherscan.io/address/0x23d94891ba51b6d677f614aaaa6eadbd5890ef6a)

IdentityGovernor - [0xab3f9968dc373a4314d18296dd13f5f6cf074eed](https://rinkeby.etherscan.io/address/0xab3f9968dc373a4314d18296dd13f5f6cf074eed)

## Example Usage

With Javascript + web3

```javascript
// Load the contract from blockchain
const abi = [{"constant":true,"inputs":[],"name":"governor","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"upgradeStore","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"addr","type":"address"},{"name":"idType","type":"bytes32"}],"name":"getIdFromAddress","outputs":[{"name":"","type":"bytes32"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"idType","type":"bytes32"},{"name":"userID","type":"bytes32"}],"name":"getAddressFromId","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"changeGovernor","outputs":[],"payable":false,"type":"function"},{"inputs":[{"name":"_governorAddress","type":"address"},{"name":"_storeAddress","type":"address"}],"payable":false,"type":"constructor"}];

const IdentityContract = web3.eth.contract(abi);

// This is the current address on Rinkeby Testnet, so make sure your
// Ethereum Node is set to the correct network
const contractInstance = IdentityContract.at('0x23d94891ba51b6d677f614aaaa6eadbd5890ef6a');

const keybaseType = web3.toHex('keybase');
const userID = web3.toHex('weipoint');
const address = '0x7f00A10b3580Fb1F7310bC4186bBafDC58A1376D';

const encodedUserID = contractInstance.getIdFromAddress(address, keybaseType);
web3.toAscii(encodedUserID); // => 'weipoint'

contractInstance.getAddressFromId(keybaseType, userID); // => '0x7f00A10b3580Fb1F7310bC4186bBafDC58A1376D'
```

Via another smart contract with Solidity
```solidity
contract IdentityContract {
  function getIdFromAddress(
    address addr,
    bytes32 idType
  ) constant returns(bytes32);

  function getAddressFromId(
    bytes32 idType,
    bytes32 userID
  ) constant returns(address);
}

contract YourContract {
  ...

  function identifyAddress(address addr, bytes32 idType) {
    IdentityContract identityContract = IdentityContract("0x23d94891ba51b6d677f614aaaa6eadbd5890ef6a");
    bytes32 userID = identityContract.getIdFromAddress(addr, idType); // => the hex encoded userID
  }
  
  function getUserAddress(bytes32 idType, bytes32 userID) {
    IdentityContract identityContract = IdentityContract("0x23d94891ba51b6d677f614aaaa6eadbd5890ef6a");
    address addr = identityContract.getAddressFromId(idType, userID);
  }

  ...
}
```

## Architecture
The smart contracts are organized into 4 components: the proxy, the repo, the store, and the governor. It is designed to be upgradable, so we can continue to add new features in the future.

The proxy is the public endpoint, and is all external parties should ever have to interact with. It is designed to be as simple as possible in the hope it does not need to be upgraded.

The repo stores the actual mappings from address -> userID and from userID -> address. It provides getter and setter methods, with the setters only accessible from the store contract.

The store sits between the proxy and the repo, and transfers get requests between the two. It is also responsible for controlling access to the repo set functions. Currently access is granted only to an address controlled by Weipoint. This means Weipoint has the ability to input any data into the repo. However, we believe this is an acceptible tradeoff for the moment, because anyone can verify the authenticity of the links added to the repo by viewing and verifying the publicly accessible proofs of ownership on weipoint.com. The store is able to be easily upgraded, so we hope to move to a more decentralized model of data injection in the future.

The governor is responsible for deciding when the store should be upgraded, as well as when the governor itself should be upgraded. It is currently implemented as a multisig contract, but since it can be upgraded we may switch to some other form of decentralized governance in the future.
