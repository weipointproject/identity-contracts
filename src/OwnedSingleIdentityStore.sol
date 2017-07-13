pragma solidity ^0.4.13;

import './SingleIdentityStore.sol';

contract OwnedSingleIdentityStore is SingleIdentityStore {
    mapping(address => Identity) public identities;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function OwnedSingleIdentityStore() {
        owner = msg.sender;
    }

    function addIdentity(
        address addr,
        bytes32 idType,
        bytes32 userID
    ) onlyOwner {
        identities[addr] = Identity(idType, userID);
    }

    function removeIdentity(address addr) onlyOwner {
        delete identities[addr];
    }

    function transfer(address newOwner) onlyOwner {
        owner = newOwner;
    }

    function getIdentity(address addr) constant returns(Identity) {
        return identities[addr];
    }

    function getIdFromAddress(address addr) constant returns(bytes32) {
        return identities[addr];
    }

    function getAddressFromId(bytes32 id) constant returns(address);
}
