// SPDX-License-Identifier: MIT
// File: @chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol


pragma solidity ^0.8.0;

// solhint-disable-next-line interface-starts-with-i
interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

// File: contracts/FundMe.sol


pragma solidity ^0.8.20;


contract FundMe {
    // 合约拥有者（部署人） 加 public 方便查看，但一般不加
    address public owner;

    // 每个地址的金额
    mapping(address => uint256) public funderToAmount;

    // 最小金额
    uint256 constant MINIMUM_VALUE = 1 * 10**18; //wei
    // 目标金额
    uint256 constant TARGET_VALUE = 10 * 10**18; //wei

    // 部署时间
    uint256 deployTime;
    // 锁定时间
    uint256 lockTime;

    // 是否完成
    bool public complete = false;

    // 初始化函数
    constructor(uint256 _lockTime) {
        owner = msg.sender;
        deployTime = block.timestamp;
        lockTime = _lockTime;
    }

    function getComplete() external view returns (bool) {
        return complete;
    }

    // 存款
    function fund() external payable {
        require(block.timestamp < deployTime + lockTime, "Activity is end");
        require(msg.value >= MINIMUM_VALUE, "Send more ETH");
        funderToAmount[msg.sender] += msg.value;
    }

    // 取钱
    function getFund() external activityNotEnd onlyOwner {
        require(address(this).balance >= TARGET_VALUE, "Target is not reached");

        // 不成功 revert 交易
        // payable(msg.sender).transfer(address(this).balance);

        // 不成功 返回 false
        // bool success_1 = payable(msg.sender).send(address(this).balance);
        // require(success_1, "send tx fail");

        // call 调用函数、携带参数、返回参数
        // 方式 {bool, result} = addr.call{value: value}("");
        bool success_2;
        (success_2, ) = payable(msg.sender).call{value: address(this).balance}(
            ""
        );
        require(success_2, "call tx fail");
        complete = true;
    }

    // 退款
    function refund() external activityNotEnd {
        require(address(this).balance < TARGET_VALUE, "Target is reached");
        require(funderToAmount[msg.sender] != 0, "You didn't fund");

        bool success_2;
        (success_2, ) = payable(msg.sender).call{
            value: funderToAmount[msg.sender]
        }("");
        require(success_2, "call tx fail");
        funderToAmount[msg.sender] = 0;
    }

    // 提供其他合约进行修改 需要添加校验，暂时没做
    function setFunderToAmount(address funder, uint256 amount) external {
        uint256 value = funderToAmount[funder];
        require(value >= amount, "You don't have enough money");
        funderToAmount[funder] = value - amount;
    }

    // 更换合约拥有者
    function setOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }

    // 修改器 类似断言
    modifier onlyOwner() {
        require(owner == msg.sender, "Only owner can operate this function");
        _;
    }

    modifier activityNotEnd() {
        require(
            block.timestamp >= deployTime + lockTime,
            "Activity is not end"
        );
        _;
    }
}
