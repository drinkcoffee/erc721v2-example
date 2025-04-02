// Copyright (c) 2025 Peter Robinson
// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19 <0.8.29;

import {MintingAccessControl} from "@imtbl/contracts/contracts/access/MintingAccessControl.sol";
import {ImmutableERC721v2} from "@imtbl/contracts/contracts/token/erc721/preset/ImmutableERC721v2.sol";


contract SampleCollectionERC721 is ImmutableERC721v2 {
    /**
     * @notice Grants `DEFAULT_ADMIN_ROLE` to the supplied `owner` address
     * @param owner_ The address to grant the `DEFAULT_ADMIN_ROLE` to
     * @param name_ The name of the collection
     * @param symbol_ The symbol of the collection
     * @param baseURI_ The base URI for the collection
     * @param contractURI_ The contract URI for the collection
     * @param operatorAllowlist_ The address of the operator allowlist
     * @param royaltyReceiver_ The address of the royalty receiver
     * @param feeNumerator_ The royalty fee numerator
     * @dev the royalty receiver and amount (this can not be changed once set)
     */
    constructor(address _owner, string memory _name, string memory _symbol,
        string memory _baseURI, string memory _contractURI, address _operatorAllowlist, 
        address _royaltyReceiver, uint96 _feeNumerator)
        ImmutableERC721v2(
            _owner,
            _name,
            _symbol,
            _baseURI,
            _contractURI,
            _operatorAllowlist,
            _royaltyReceiver,
            _feeNumerator
        ) {
            grantRole(MintingAccessControl.MINTER_ROLE, _owner);
        }
}