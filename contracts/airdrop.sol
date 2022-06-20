

// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "./errors.sol";
interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}



contract transferAnyToken {
    address public owner;
    uint256 public amount;
    
    mapping(address => bool) public admin;
    
    constructor (uint256 _amt) {
        amount = _amt;
        owner = msg.sender;
        admin[msg.sender] = true;
    }
    
    function addAdmin(address[] memory _admAddr) public {
        if(msg.sender != owner) revert Not_Owner();
        for (uint256 i = 0; i < _admAddr.length; i ++) {
            address _admin = _admAddr[i];
            admin[_admin] = true;
        }
    }
    
    function transfer_To_Multi_Wallet(address token, address[] memory _user, uint256[] memory amt) public {
        if (admin[msg.sender] != true) revert Not_Admin();
        for (uint256 i = 0; i < _user.length; i++) {
            address wallet = _user[i];
            IERC20(token).transferFrom(owner, wallet, amt[i]);
        }
    }

    function transfer_To_Multi_Wallet_EqualAmount(address token, address[] memory _user) public {
        if (admin[msg.sender] != true) revert Not_Admin();
        for (uint256 i = 0; i < _user.length; i++) {
            address wallet = _user[i];
            IERC20(token).transferFrom(owner, wallet, amount);
        }
    }

    function withdraw(address tok, uint256 amt) external {
        if (admin[msg.sender] != true) revert Not_Admin();
        IERC20(tok).transfer(msg.sender, amt);
    }
    
    function setAmount(uint256 _newAmount) public {
        if (admin[msg.sender] != true) revert Not_Admin();
        amount = _newAmount;
    }
}