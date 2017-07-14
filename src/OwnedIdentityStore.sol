pragma solidity ^0.4.13;

import './IdentityStore.sol';
import './IdentityRepo.sol';

contract OwnedIdentityStore is IdentityStore {
    address public owner;

    IdentityRepo repo;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function OwnedIdentityStore(address _repoAddress) {
        owner = msg.sender;
        repo = IdentityRepo(_repoAddress);
    }

    // This will overwrite the userID if one already exists
    function addIdentity(
        address addr,
        bytes32 idType,
        bytes32 userID
    ) onlyOwner {
        repo.identitiesSet(addr, idType, userID);
        repo.reverseIdentitiesSet(idType, userID, addr);
    }

    function removeIdentity(
        address addr,
        bytes32 idType
    ) onlyOwner {
        bytes32 userID = repo.identitiesGet(addr, idType);
        repo.identitiesRemove(addr, idType);
        repo.reverseIdentitiesRemove(idType, userID);
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }

    function getIdFromAddress(
        address addr,
        bytes32 idType
    ) constant returns(bytes32) {
        return repo.identitiesGet(addr, idType);
    }

    function getAddressFromId(
        bytes32 idType,
        bytes32 userID
    ) constant returns(
        address
    ) {
        return repo.reverseIdentitiesGet(idType, userID);
    }
}
