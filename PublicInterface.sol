pragma solidity ^0.4.13;

contract IdentityInterface {
    /**
     * Get an address's userID for a given ID type
     *
     * @param  {address} addr   The address to find the ID for
     * @param  {bytes32} idType The type of the id to find. e.g. keybase.
     *                          Encoded as: web3.toHex('keybase');
     * @return {bytes32}        The ID of the requested type for the address
     *                          Encoded as: id = web3.toAscii(returnValue)
     */
    function getIdFromAddress(
        address addr,
        bytes32 idType
    ) constant returns(bytes32);

    /**
     * Get an identity's address given a type and userID
     *
     * @param  {bytes32} idType The type of the id to find. e.g. keybase.
     *                          Encoded as: web3.toHex('keybase');
     * @param  {bytes32} userID The userID of the user to find
     *                          Encoded as: web3.toHex(userID);
     * @return {address}        The address of the requested user
     */
    function getAddressFromId(
        bytes32 idType,
        bytes32 userID
    ) constant returns(address);
}
