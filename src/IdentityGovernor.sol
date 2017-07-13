pragma solidity ^0.4.13;

import './lib/multiowned.sol';
import './IdentityProxy.sol';

contract IdentityGovernor is multiowned {
    IdentityProxy proxy;

    function IdentityGovernor(
        address[] _owners,
        uint _required,
        address _proxyAddress
    ) multiowned(_owners, _required) {
        proxy = IdentityProxy(_proxyAddress);
    }

    function upgradeStore(address addr) onlymanyowners(sha3(addr)) {
        proxy.upgradeStore(addr);
    }

    function changeGovernor(address addr) onlymanyowners(sha3(addr)) {
        proxy.changeGovernor(addr);
    }
}
