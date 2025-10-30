// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PiggyBank {
    mapping(address => uint256) public balances;

    event Deposited(address indexed from, uint256 amount);
    event Withdrawn(address indexed to, uint256 amount);

    // Deposit CELO/ETH by sending value directly; no inputs required
    receive() external payable {
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    // Withdraw entire balance; no inputs required
    function withdrawAll() external {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Nothing to withdraw");
        // Effects before interactions
        balances[msg.sender] = 0;
        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "Transfer failed");
        emit Withdrawn(msg.sender, amount);
    }
}
