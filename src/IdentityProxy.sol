pragma solidity ^0.4.13;

import './IdentityStore.sol';

contract IdentityProxy {
    IdentityStore identityStore;
    address public governor;

    modifier onlyGovernor() {
        require(msg.sender == governor);
        _;
    }

    function IdentityProxy(
        address _governorAddress,
        address _storeAddress
    ) {
        identityStore = IdentityStore(_storeAddress);
        governor = _governorAddress;
    }

    function getIdFromAddress(
        address addr,
        bytes32 idType
    ) constant returns(bytes32) {
        return identityStore.getIdFromAddress(addr, idType);
    }

    function getAddressFromId(
        bytes32 idType,
        bytes32 userID
    ) constant returns(address) {
        return identityStore.getAddressFromId(idType, userID);
    }

    function upgradeStore(address addr) onlyGovernor {
        identityStore = IdentityStore(addr);
    }

    function changeGovernor(address addr) onlyGovernor {
        governor = addr;
    }
}
