// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './IERC20.sol';

contract TestTokenDex is IERC20 {

    string public constant name = "TestTokenDex";
    string public constant symbol = "TTD";
    uint public constant decimals = 2;

    mapping(address => uint256) balances;

    mapping(address => mapping(address => uint256)) allowed;

    uint256 _totalSupply = 500000000000000 * (10 ** decimals);

    constructor() {
        balances[msg.sender] = _totalSupply;
    }
    

    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) public override view returns (uint256) {
        return balances[owner];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(amount <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - amount;
        balances[recipient] = balances[recipient] + amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address owner, address spender) public override view returns (uint) {
        return allowed[owner][spender];
    }

    function transferFrom(address owner, address recipient, uint256 amount) public override returns (bool) {
        require(amount <= balances[owner]);
        require(amount <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner] - amount;
        allowed[owner][msg.sender] = allowed[owner][msg.sender] - amount;
        balances[recipient] = balances[recipient] + amount;
        emit Transfer(owner, recipient, amount);
        return true;
    }

}