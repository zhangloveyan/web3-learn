// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Parent {
    // 主合约、子合约、外部皆可访问 自动生产 get 方法
    uint256 public a = 1;
    // 仅主合约内部访问
    uint256 private b = 1;
    // 主合约、子合约访问
    uint256 internal c = 1;
    // 不可修饰变量
    // uint256 external d = 1;

    // 任何地方
    function add_1() public {
        a++;
    }

    // 仅内部
    function add_2() private {
        a++;
    }

    // 当前合约、子合约
    function add_3() internal {
        a++;
    }

    // 子合约、外部合约
    function add_4() external {
        a++;
        // 报错 因为 external 无法内部调用
        // addOne();
    }
}

contract Child is Parent {
    // 如果改成 external 虽然外部都可以调用,但是内部无法使用
    function getValue() public view returns(uint256){
        // a c 可以访问 b 不行
        // return a;
        // return b;
        return c;
    }

    function add() public {
        // 子合约中 仅 public internal 可调用
        add_1();
        // add_2();
        add_3();
        // add_4();

    }
}
