// SPDX-License-Identifier: MIT

pragma solidity 0.6.6;


import "@openzepplin/contracts/token/ERC721/ERC721.sol*";

contract SimplieCollectible is ERC721 {
    uint256 public tokenCounter;
    constructor () public ERC721 ("Dogie", "DOG"){
        tokenCounter = 0;
    }

    function createCollectible() public returns (uint256) {
        uint256 newTokenId = tokenCounter;
        _safeMint(msg.sender, newTokenId);
        tokenCounter = tokenCounter + 1;
        return newTokenId;
    }
}

