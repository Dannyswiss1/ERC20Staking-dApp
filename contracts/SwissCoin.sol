//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SwissCoin is ERC20 {

    constructor() ERC20("SwissToken", "SWS") {
        _mint(msg.sender, 100000 * 10 ** decimals());
    }
    
}