# Immutable ERC721 V2 example

This is an example repo showing how to use and extend the Immutable ERC721v2 contract.

## Command Sequence

The following is the list of commands used to create this repo.

- Create repo in github. 
- Clone the repo.
- Init Foundry project: 
  - `forge init --force`
- Install Immtuable's contracts repo:
  - `forge install https://github.com/immutable/contracts.git  --no-commit`
- Install Open Zeppelin's upgradeable contracts repo:
  - `forge install https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable  --no-commit`
- Add `./remappings.txt` with contents:
  - `@imtbl/contracts/contracts/=lib/contracts/contracts/`
- Update `./.gitignore` to ignore Apple file:
  - `.DS_Store`
- Remove `Counter` example contract, tests, and script from the src, test, and script directories.
- 




### Build

```shell
$ forge build
```

### Deploy

Not that `script/deploy.sh` needs small modifications to switch between mainnet and testnet. It also has instructions if deploying using a Ledger hardware wallet.

```shell
$ export PKEY=<your key>
$ export APIKEY=<your blockscout test net or mainnet API key>
$ sh script/deploy.sh
```



### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

