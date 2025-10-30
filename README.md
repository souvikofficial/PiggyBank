PiggyBank — Beginner-Friendly Solidity Contract
A minimal, input-free smart contract that lets anyone deposit native tokens and withdraw their entire balance safely. Designed for quick deployment to EVM chains (including Celo testnets) and easy understanding for first-time smart contract developers.​

Project Description
PiggyBank is a simple contract that accepts deposits via a plain transfer and tracks balances per sender, requiring no function parameters anywhere. Users can retrieve their full balance using a single withdraw function that follows the checks-effects-interactions pattern to reduce risk.​

What it does
Accepts funds through the receive() function when native tokens are sent to the contract address. No calldata or parameters are needed.​
Tracks per-sender balances in a mapping and emits events for deposits and withdrawals to make off-chain indexing straightforward.​
Lets users withdraw their entire balance with one call, updating state before transfer to mitigate reentrancy issues.​

Features
No input parameters: deposits occur by sending value; withdrawals are one-click per user.​
Safety pattern: uses checks-effects-interactions to reduce reentrancy risk; suitable for beginner education.​
Clear events: Deposited and Withdrawn events for debugging, analytics, and block explorer visibility.​

Deployed Smart Contract Link : https://repo.sourcify.dev/11142220/0x706a0365a89cF9503369f4f5Eeb7794989a47415/

Code
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
