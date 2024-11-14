// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// 多种引用方式 还可 http 引用
import {Demo} from "./Demo.sol";

contract DemoFactory {
    Demo[] demos;

    function createDemo() public {
        Demo demo = new Demo();
        demos.push(demo);
    }

    function getDemo(uint256 _id) public view returns (Demo) {
        return demos[_id];
    }

    function callSetHello(
        uint256 _index,
        string memory str,
        uint256 _id
    ) public {
        demos[_index].setHelloMapping(str, _id);
    }

    function callSayHello(uint256 _index, uint256 _id)
        public
        view
        returns (string memory)
    {
        return demos[_index].sayHelloMapping(_id);
    }
}
