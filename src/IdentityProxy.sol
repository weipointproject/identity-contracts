pragma solidity ^0.4.13;

import './SingleIdentityStore.sol';

contract IdentityProxy {
    SingleIdentityStore identityStore;
    address public governor;

    modifier onlyGovernor() {
        require(msg.sender == governor);
        _;
    }

    function IdentityProxy(
        address _governorAddress,
        address _storeAddress
    ) {
        identityStore = SingleIdentityStore(_storeAddress);
        governor = _governorAddress;
    }

    function getIdFromAddress(address addr) constant returns(bytes32) {
        return identityStore.getIdFromAddress(addr);
    }

    function getAddressFromId(bytes32 id) constant returns(address) {
        return identityStore.getAddressFromId(id);
    }

    function upgradeStore(address addr) onlyGovernor {
        identityStore = SingleIdentityStore(addr);
    }

    function changeGovernor(address addr) onlyGovernor {
        governor = addr;
    }
}
