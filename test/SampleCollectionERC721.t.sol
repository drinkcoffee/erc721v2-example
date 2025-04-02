// Copyright Immutable Pty Ltd 2018 - 2025
// SPDX-License-Identifier: Apache 2.0
pragma solidity >=0.8.19 <0.8.29;

// solhint-disable-next-line no-global-import
import "forge-std/Test.sol";
import {SampleCollectionERC721} from "../src/SampleCollectionERC721.sol";
import {OperatorAllowlistUpgradeable} from "@imtbl/contracts/contracts/allowlist/OperatorAllowlistUpgradeable.sol";
import {DeployOperatorAllowlist} from "@imtbl/contracts/test/utils/DeployAllowlistProxy.sol";


/**
 * Base contract for all ERC 721 tests.
 */
abstract contract ERC721BaseTest is Test {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    string public constant BASE_URI = "https://drinkcoffee.github.io/projects/nfts";
    string public constant CONTRACT_URI = "https://drinkcoffee.github.io/projects/nfts/sample-collection.json";
    string public constant NAME = "ERC721 Sample Collection";
    string public constant SYMBOL = "SC7";


    SampleCollectionERC721 public erc721;

    OperatorAllowlistUpgradeable public allowlist;

    address public owner;
    address public feeReceiver;
    address public operatorAllowListAdmin;
    address public operatorAllowListUpgrader;
    address public operatorAllowListRegistrar;

    string public name;
    string public symbol;
    string public baseURI;
    string public contractURI;
    uint96 public feeNumerator;

    address public user1;
    address public user2;
    address public user3;
    uint256 public user1Pkey;


    function setUp() public virtual {
        owner = makeAddr("hubOwner");
        feeReceiver = makeAddr("feeReceiver");
        operatorAllowListAdmin = makeAddr("operatorAllowListAdmin");
        operatorAllowListUpgrader = makeAddr("operatorAllowListUpgrader");
        operatorAllowListRegistrar = makeAddr("operatorAllowListRegistrar");

        name = NAME;
        symbol = SYMBOL;
        baseURI = BASE_URI;
        contractURI = CONTRACT_URI;   
        feeNumerator = 200; // 2%     

        DeployOperatorAllowlist deployScript = new DeployOperatorAllowlist();
        address proxyAddr = deployScript.run(operatorAllowListAdmin, operatorAllowListUpgrader, operatorAllowListRegistrar);
        allowlist = OperatorAllowlistUpgradeable(proxyAddr);

        (user1, user1Pkey) = makeAddrAndKey("user1");
        user2 = makeAddr("user2");
        user3 = makeAddr("user3");

        erc721 = new ImmutableERC721MintByID(
            owner, name, symbol, baseURI, contractURI, address(allowlist), feeReceiver, feeNumerator
        );
    }

    function testAccessControl() public {
        address[] memory admins = erc721.getAdmins();
        assertEq(admins[0], owner);

        // Test granting and revoking minter role
        bytes32 minterRole = erc721.MINTER_ROLE();
        assertFalse(erc721.hasRole(minterRole, user1));

        vm.prank(owner);
        assertTrue(erc721.hasRole(minterRole, owner));
    }

    function testMint() public {
        vm.prank(minter);
        erc721.mint(user1, 1);

        vm.prank(minter);
        erc721.safeMint(user1, 2);

        uint256 qty = 5;

        uint256 first = erc721BQ.mintBatchByQuantityNextTokenId();
        uint256 originalBalance = erc721.balanceOf(user1);
        uint256 originalSupply = erc721.totalSupply();

        vm.prank(minter);
        vm.expectEmit(true, true, false, false);
        emit Transfer(address(0), user1, first);
        emit Transfer(address(0), user1, first+1);
        emit Transfer(address(0), user1, first+2);
        emit Transfer(address(0), user1, first+3);
        emit Transfer(address(0), user1, first+4);
        erc721BQ.mintByQuantity(user1, qty);

        assertEq(erc721.balanceOf(user1), originalBalance + qty);
        assertEq(erc721.totalSupply(), originalSupply + qty);

        for (uint256 i = 0; i < qty; i++) {
            assertEq(erc721.ownerOf(first + i), user1);
        }
    }
}
