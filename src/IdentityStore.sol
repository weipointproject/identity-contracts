pragma solidity ^0.4.13;

interface IdentityStore {
    function getIdFromAddress(
        address addr,
        bytes32 idType
    ) constant returns(bytes32);

    function getAddressFromId(
        bytes32 userID,
        bytes32 idType
    ) constant returns(address);
}
