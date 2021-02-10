// SPDX-License-Identifier: MIT

pragma solidity 0.7.6;

import "./OwnershipToken.sol";
import "./lib/Accounting.sol";

contract Bank is OwnershipToken, Accounting {
    
    string private _name;
    string private _symbol;
    
    constructor (string memory name_, string memory symbol_, address recipient_) {
        _name = name_;
        _symbol = symbol_;
        _mint(recipient_, 1);
    }
    
    function depositEther(uint _amount) public payable {
        depositETH(_amount);
    }
    
    function withdrawEther(address payable _recipient, uint _amount) public onlyHolder {
        sendETH(_recipient, _amount);
    }
    
    function depositERC20(address _tokenContractAddress, uint _amount) public payable {
        depositToken(_tokenContractAddress, _amount);
    }
    
    function withdrawER20(address _tokenContractAddress, address _recipient, uint _amount) public onlyHolder {
        sendToken(_tokenContractAddress, _recipient, _amount);
    }

}