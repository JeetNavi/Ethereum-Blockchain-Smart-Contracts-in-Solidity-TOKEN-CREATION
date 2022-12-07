contract B160966_part1{

    address public payable owner;
    uint256 public totalSupply; // Are we supposed to make up our own value?
    string public name = "CW3Token";
    string public symbol = "CW3T";
    uint128 public price = 600 wei; // Set it to 600 wei? //Selling and redeeming tokens are interchangable
    mapping(address => uint256) balances;

    constructor() public {
        owner = msg.sender;
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

    function totalSupply() public view returns (uint) {
        return totalSupply;
    }

    function balanceOf(address addr) public view returns (uint256) {
        return balances[addr];
    }

    function getName() public view returns (string){
        return name;
    }

    function getSymbol() public view returns (string){
        return symbol;
    }

    function getPrice() public view returns (uint128){
        return price;
    }

    function transfer(address to, uint256 value) public returns (bool /*success, ppl use names here so maybe do that for others too*/) {
        require (balanceOf[msg.sender] >= value /*msgs on requires? i.e. insufficient balance*/ );

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;

        Transfer(msg.sender, to, value);

        return true;
    }

    modifier onlyOwner(){
        require (msg.sender == owner);
    }

    function mint(address to, uint256 value) public onlyOwner returns (bool){ //how does this fail lol?
        balanceOf[to] += value;

        Mint(to, value);

        return true;
    }

    function sell(uint256 value) public returns (bool) {
        require (balanceOf[msg.sender] >= value);

        balanceOf[msg.sender] -= value;
        totalSupply -= value

        msg.sender.transfer(value * price); //what if the contract doesnt have enough wei?? i didnt think about this yet

        Sell(msg.sender, value)

        return true;
    }

    function close() onlyOwner{
        selfdestruct(owner)
    }

    function() payable external {}
    // think about if there are any attacks in here...
    // mayeb do revert if msg.data > 1 ?
    //youtube: solidity tutorial fall back functuin eat the blocks shows above line and hpow to use the fallback func

}
