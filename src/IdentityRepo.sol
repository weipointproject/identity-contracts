pragma solidity ^0.4.13;

contract IdentityRepo {
    // { address => { idType => userID } }
    mapping(address => mapping(bytes32 => bytes32)) identities;

    // { idType => { userID => address } }
    mapping(bytes32 => mapping(bytes32 => address)) reverseIdentities;

    address public owner;

    modifier onlyowner() {
        require(msg.sender == owner);
        _;
    }

    function IdentityRepo() {
        owner = msg.sender;
    }

    function identitiesGet(
        address addr,
        bytes32 idType
    ) constant returns(
        bytes32
    ) {
        return identities[addr][idType];
    }

    function identitiesSet(
        address addr,
        bytes32 idType,
        bytes32 userID
    ) onlyowner {
        identities[addr][idType] = userID;
    }

    function identitiesRemove(
        address addr,
        bytes32 idType
    ) onlyowner {
        delete identities[addr][idType];
    }

    function reverseIdentitiesGet(
        bytes32 idType,
        bytes32 userID
    ) constant returns(address) {
        return reverseIdentities[idType][userID];
    }

    function reverseIdentitiesRemove(
        bytes32 idType,
        bytes32 userID
    ) onlyowner {
        delete reverseIdentities[idType][userID];
    }

    function reverseIdentitiesSet(
        bytes32 idType,
        bytes32 userID,
        address addr
    ) onlyowner {
        reverseIdentities[idType][userID] = addr;
    }

    function transferOwnership(address addr) onlyowner {
        owner = addr;
    }
}
