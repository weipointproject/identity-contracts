pragma solidity ^0.4.13;

contract SingleIdentityStore {
    struct Identity {
        bytes32 idType;
        bytes32 userID;
    }

    function getIdFromAddress(address addr) constant returns(bytes32);

    function getAddressFromId(bytes32 id) constant returns(address);
}
