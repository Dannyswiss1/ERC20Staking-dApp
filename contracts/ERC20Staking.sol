//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract ERC20Staking {

    using SafeERC20 for IERC20;

    IERC20 public immutable token;

    constructor() {
        token = _token;
    }
}