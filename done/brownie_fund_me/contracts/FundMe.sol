// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;


import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe{
    // using keyword
    // using SafeMathChainLink for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address owner;
    AggregatorV3Interface public priceFeed;

    // constuctor
    constructor(address _priceFeed) public {
        priceFeed = AggregatorV3Interface(_priceFeed);
        owner = msg.sender;
    }

    // function used to pay for things
   function fund() public payable{
       // msg. sender and value are keywords
       uint256 minUSD = 50 * 10 ** 18; // 50 x 1^18
       // require statement
       require(getConversionRate(msg.value) >= minUSD, "Not enough eth");
       addressToAmountFunded[msg.sender] += msg.value;
       // what is the eth to usd conversion rate?
       // use an oracle
       funders.push(msg.sender);
   } 

   function getVersion() public view returns (uint256) {
    //    AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
       return priceFeed.version();
   }

   function getPrice() public view returns (uint256) {
    //    AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
       (,int256 answer,,,) = priceFeed.latestRoundData();
       return uint256(answer * 10000000000);
   }

   function getEntranceFee() public view returns (uint256){
       uint256 minUSD = 50 * 10**18;
       uint256 price = getPrice();
       uint256 precision = 1 * 10**18;
       return (minUSD * precision) / price;
   }

   function getConversionRate(uint256 ethAmt) public view returns(uint256) {
       uint256 ethPrice  = getPrice();
       uint256 ethAmtInUsd = (ethPrice * ethAmt) / 100000000;
       return ethAmtInUsd;
   }

    // modifier
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

   function withdraw() payable onlyOwner public {
       
        msg.sender.transfer(address(this).balance);
        // for loops 
        for(uint256 i=0; i < funders.length; i++){
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
   }
}