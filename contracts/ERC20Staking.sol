//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract ERC20Staking {

     using SafeERC20 for IERC20;

    IERC20 public immutable token;

    uint public immutable rewardsPerHour = 1000; // 0.01%

    uint public totalStaked = 0;

    event Deposit(address _address, uint _amount);
    event Claim(address _address, uint _amount);
    event Compound(address _address, uint _amount);
    event Withdraw(address _address, uint _amount);

    mapping(address => uint) public balanceOf;
    mapping(address => uint) public lastUpdated;
    mapping(address => uint) public claimed;

    constructor(IERC20 _token) {
        token = _token;
    }

    function totalRewards() external view returns (uint) {
  return _totalRewards();
}

function _totalRewards() internal view returns (uint) {
  return token.balanceOf(address(this)) - totalStaked;
}

function deposit(uint _amount) external {
    _compound;
  token.safeTransferFrom(msg.sender, address(this), _amount);
  balanceOf[msg.sender] += _amount;
  lastUpdated[msg.sender] = block.timestamp;
  totalStaked += _amount;

  emit Deposit(msg.sender, _amount);
}

function rewards(address _address) external view returns (uint) {
  return _rewards(_address);
}

function _rewards(address _address) internal view returns (uint) {
  return (block.timestamp - lastUpdated[_address]) * balanceOf[_address] / (rewardsPerHour * 1 hours);
}

function claim() external {
  uint amount = _rewards(msg.sender);
  token.safeTransfer(msg.sender, amount);
  claimed[msg.sender] += amount;
  lastUpdated[msg.sender] = block.timestamp;

  emit Claim(msg.sender, amount);
}

function compound() external {
    _compound;
  uint amount = _rewards(msg.sender);
  
  claimed[msg.sender] += amount;
  balanceOf[msg.sender] += amount;
  totalStaked += amount;
  lastUpdated[msg.sender] = block.timestamp;

  emit Compound(msg.sender, amount);
}

function _compound() internal {
  uint amount = _rewards(msg.sender);
  
  claimed[msg.sender] += amount;
  balanceOf[msg.sender] += amount;
  totalStaked += amount;
  lastUpdated[msg.sender] = block.timestamp;
  
  emit Compound(msg.sender, amount);
}

function withdraw(uint _amount) external {
    require(balanceOf[msg.sender] >= _amount, "Insufficient funds");
    _compound();
  token.safeTransfer(msg.sender, _amount);
  balanceOf[msg.sender] -= _amount;
  totalStaked -= _amount;

  emit Withdraw(msg.sender, _amount);
}
    
}