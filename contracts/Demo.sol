// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Demo {
    string defaultStr = "default";
    // 记录谁部署的
    address owner;
    // 结构体
    struct Info {
        uint256 id;
        string name;
        address addr;
    }
    // 数组
    Info[] infos;
    // 映射
    mapping(uint256 => Info) inforMapping;

    // 构造函数
    constructor() {
        owner = msg.sender;
    }

    function addStr(string memory str) internal pure returns (string memory) {
        return string.concat("hello world :", str);
    }

    function setHello(string memory str, uint256 _id) private {
        require(msg.sender == owner, "Dont opt it");
        Info memory info = Info(_id, str, msg.sender);
        infos.push(info);
    }

    function sayHello(uint256 _id) private view returns (string memory) {
        for (uint256 i = 0; i < infos.length; i++) {
            if (infos[i].id == _id) {
                return addStr(infos[i].name);
            }
        }
        return addStr(defaultStr);
    }

    function setHelloMapping(string memory str, uint256 _id) public {
        Info memory info = Info(_id, str, msg.sender);
        inforMapping[_id] = info;
    }

    function sayHelloMapping(uint256 _id) public view returns (string memory) {
        Info memory temp = inforMapping[_id];
        if (temp.addr == address(0x0)) {
            return addStr(defaultStr);
        } else {
            return addStr(temp.name);
        }
    }
}
