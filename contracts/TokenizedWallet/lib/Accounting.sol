// SPDX-License-Identifier: MIT

pragma solidity 0.7.6;

import "./math-lib.sol";
import "./IERC20.sol";

contract Accounting {
    using DSMath for uint;
    bool internal _in;


    modifier noReentrance() {
        require(!_in, "Reentrance not allowed!");
        _in = true;
        _;
        _in = false;
    }
    
    //keeping track of total ETH and token balances
    mapping (address => uint) public totalTokenBalances;
    uint balanceETH;
    mapping (address => uint) tokenBalances;

    function ETHBalance() public view returns(uint) {
        return balanceETH;}

    function TokenBalance(address token) public view returns(uint) {
        return tokenBalances[token];}

    function depositETH(uint _value) internal {
        balanceETH = balanceETH.add(_value);
    }

    function depositToken(address _token, uint _value) internal noReentrance {        
        require(IERC20(_token).transferFrom(msg.sender, address(this), _value), "Token transfer not possible!");
        tokenBalances[_token] = tokenBalances[_token].add(_value);}

    function sendETH(address payable _to, uint _value) internal noReentrance {
        require(balanceETH >= _value, "Insufficient ETH balance!");
        require(_to != address(0), "Invalid recipient addess!");
        balanceETH = balanceETH.sub(_value);
        _to.transfer(_value);
    }

    function sendToken(address _token, address _to, uint _value) internal noReentrance {
        require(tokenBalances[_token] >= _value, "Insufficient token balance!");
        require(_to != address(0), "Invalid recipient addess!");
        tokenBalances[_token] = tokenBalances[_token].sub(_value);
        require(IERC20(_token).transfer(_to, _value), "Token transfer failed!");
    }
}