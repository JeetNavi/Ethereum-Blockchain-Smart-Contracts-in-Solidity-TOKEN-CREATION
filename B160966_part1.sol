// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 <0.9.0;

contract B160966_part1{

    address payable public owner;
    uint256 public _totalSupply; //Defaults to 0
    string public name;
    string public symbol;
    uint128 public price;
    mapping(address => uint256) public balances;

    constructor() {
        owner = payable(msg.sender);
        name = "CW3Token";
        symbol = "CW3T";
        price = 600 wei;
    }

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );

    event Mint(
        address indexed to,
        uint256 value
    );

    event Sell(
        address indexed from,
        uint256 value
    );

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address addr) public view returns (uint256) {
        return balances[addr];
    }

    function getName() public view returns (string memory){
        return name;
    }

    function getSymbol() public view returns (string memory){
        return symbol;
    }

    function getPrice() public view returns (uint128){
        return price;
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(balances[msg.sender] >= value, "Insufficient Funds!");

        balances[msg.sender] -= value;
        balances[to] += value;

        emit Transfer(msg.sender, to, value);

        return true;
    }

    modifier onlyOwner(){
        require (msg.sender == owner);
        _;
    }

    function mint(address to, uint256 value) public onlyOwner returns (bool){
        balances[to] += value;
        _totalSupply += value; //Not specified in specs

        emit Mint(to, value);

        return true;
    }

    function sell(uint256 value) public returns (bool) {
        require (balances[msg.sender] >= value, "You do not have that many tokens in your balance!");

        balances[msg.sender] -= value;
        _totalSupply -= value;

        payable(msg.sender).transfer(value * price); //what if the contract doesnt have enough wei?? i didnt think about this yet

        emit Sell(msg.sender, value);

        return true;
    }

    function close() public onlyOwner{
        selfdestruct(owner);
    }

    fallback() external payable {}

    receive() external payable {}
}
