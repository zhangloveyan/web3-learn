// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {FundMe} from "./FundMe.sol";

contract MeToken is ERC20 {
    FundMe fundMe;

    constructor(address fundMeAddr) ERC20("MeToken", "ME") {
        // 和 new 一个合约不同，把地址转为 合约类型对应的实例 类似 payable(addr)
        fundMe = FundMe(fundMeAddr);
    }

    function mint(uint256 amountToMint) public activityEnd {
        require(
            fundMe.funderToAmount(msg.sender) >= amountToMint,
            "You cannot mint this many tokens"
        );
        _mint(msg.sender, amountToMint);
        fundMe.setFunderToAmount(msg.sender, amountToMint);
    }

    function claim(uint256 amountToClaim) public activityEnd {
        require(
            balanceOf(msg.sender) >= amountToClaim,
            "You don't have enough ERC20 tokens"
        );
        _burn(msg.sender, amountToClaim);
    }

    modifier activityEnd() {
        require(fundMe.getComplete(), "Activity not complete");
        _;
    }
}
