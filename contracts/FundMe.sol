// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FoundMe {
    mapping(address => uint256) public funderToAmount;

    // uint256 MINIMUM_VALUE = 1 * 10**18; //wei
    uint256 MINIMUM_VALUE = 100 * 10**18; //usd

    AggregatorV3Interface internal dataFeed;

    constructor() {
        dataFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
    }

    function fund() external payable {
        require(convertEthToUsd(msg.value) >= MINIMUM_VALUE, "Send more ETH");
        uint256 value = funderToAmount[msg.sender];
        funderToAmount[msg.sender] = value + msg.value;
    }

    // 预言机 链上获取链下数据 获取一些数据 比如 eth-> 本币价格
    // 交易过成狗 提交 广播 达成共识
    // 确定性交易 非确定性交易
    // DON 去中心化预言机网络 多节点分布式 data feed 喂价
    function getChainlinkDataFeedLatestAnswer() public view returns (int256) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }

    function convertEthToUsd(uint256 ethMount) internal view returns (uint256) {
        uint256 answer = uint256(getChainlinkDataFeedLatestAnswer());
        return (ethMount * answer) / 10**8;
    }

    function test() public pure returns (uint256) {
        uint256 a = 11;
        uint256 b = 12;
        return a + b;
    }
}
