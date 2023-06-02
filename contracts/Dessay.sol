//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./DessayToken.sol";

contract Dessay is DessayToken {
    DessayToken public ourToken;

    event WritingEntered(
        string header,
        string ipfsaddr,
        address publisher,
        Topics[] topics,
        uint tstamp,
        uint index,
        uint id
    );

    event Upvoted(
        address voter,
        address receiver,
        uint amount,
        uint writingID,
        uint tstamp
    );

    event ReplyAdded(uint id, address publisher, string content);

    constructor(address _ourToken) {
        ourToken = DessayToken(_ourToken);
    }

    enum Topics {
        Felsefe,
        BilimKurgu,
        Teknoloji,
        Bilim,
        Sanat,
        Muzik,
        Programlama,
        Biyoloji,
        Fizik,
        Kimya,
        Matematik,
        Evrim,
        Havacilik,
        Cografya,
        FilmIncelemesi,
        BilgisayarBilimleri,
        Kripto
    }

    struct Upvote {
        address publisher;
        uint amount;
        uint percentage;
        uint id;
        uint before;
    }

    struct Writing {
        string header;
        string ipfsaddress;
        Topics[] topics;
        address publisher;
        uint comments;
        uint tstamp;
        uint index;
        uint id;
        uint upvoteAmount;
        uint upvoteCount;
        uint replyCount;
        uint badgeThreshold;
    }

    struct Object {
        address publisher;
        uint index;
    }

    struct Badge {
        string name;
        string description;
        address holder;
        uint id;
    }

    struct Comment {
        address publisher;
        string content;
    }

    uint writingCount = 0;
    mapping(address => Writing[]) addrToWriting;
    mapping(uint => Object) idToObject;
    mapping(uint => Comment[]) idToComments;
    mapping(Topics => Writing[]) topicToWritings;
    mapping(uint => Badge[]) idToBadges;
    mapping(address => Upvote[]) addrToUpvotes;

    function enterWriting(
        string memory _header,
        string memory _ipfsaddress,
        Topics[] memory _topicsInput,
        uint _badgeThreshold
    ) public {
        addrToWriting[msg.sender].push(
            Writing(
                _header,
                _ipfsaddress,
                _topicsInput,
                msg.sender,
                0,
                block.timestamp,
                addrToWriting[msg.sender].length,
                writingCount,
                0,
                0,
                0,
                _badgeThreshold
            )
        );
        idToObject[writingCount] = Object(
            msg.sender,
            addrToWriting[msg.sender].length - 1
        );
        writingCount++;
        for (uint i = 0; i < _topicsInput.length; i++) {
            topicToWritings[_topicsInput[i]].push(
                addrToWriting[msg.sender][addrToWriting[msg.sender].length - 1]
            );
        }

        emit WritingEntered(
            _header,
            _ipfsaddress,
            msg.sender,
            _topicsInput,
            block.timestamp,
            addrToWriting[msg.sender].length - 1,
            writingCount - 1
        );
    }

    function getWrites(
        address user
    ) public view returns (Writing[] memory hisWriting) {
        return addrToWriting[user];
    }

    function getWritingForIndex(
        address _addr,
        uint index
    ) public view returns (Writing memory writing) {
        return addrToWriting[_addr][index];
    }

    function reply(address _publisher, string memory content, uint _id) public {
        idToComments[_id].push(Comment(_publisher, content));
        addrToWriting[_publisher][idToObject[_id].index].replyCount++;
        emit ReplyAdded(_id, _publisher, content);
    }

    function upvote(uint256 amount, uint256 writingId) public {
        /*require(
            addrToWriting[idToObject[writingId].publisher][
                idToObject[writingId].index
            ].badgeThreshold > amount,
            "Threshold is not reached"
        );*/

        /*
        ourToken.approve(msg.sender, amount / 4);
        userPowers[idToObject[writingId].publisher] -= amount;
        stakedBalances[msg.sender] -= (amount * 3) / 4;
        stakedBalances[idToObject[writingId].publisher] += (amount * 3) / 4;
        transferFrom(msg.sender, idToObject[writingId].publisher, amount / 4);*/
        addrToWriting[idToObject[writingId].publisher][
            idToObject[writingId].index
        ].upvoteAmount += amount;
        emit Upvoted(
            msg.sender,
            idToObject[writingId].publisher,
            amount,
            writingId,
            block.timestamp
        );
    }

    function getComments(
        uint _id
    ) public view returns (Comment[] memory comments) {
        return idToComments[_id];
    }

    /*
    function getFeed() public view returns(Writing[] memory feed) {
        feed = new Writing[](addrToFollowed[msg.sender].length);
        for(uint i = 0; i < addrToFollowed[msg.sender].length; i++) {
            
            feed[i] = addrToWriting[addrToFollowed[msg.sender][i]][addrToWriting[addrToFollowed[msg.sender][i]].length - 1];
        }
        return feed;
    }*/

    function getWritingsForTopic(
        Topics _topic,
        uint _start,
        uint _end
    ) public view returns (Writing[] memory writings) {
        Writing[] memory output = new Writing[](_end - _start + 1);
        for (uint i = _start; i < _end; i++) {
            uint j = 0;
            if (topicToWritings[_topic][i].publisher == msg.sender) {
                output[j] = topicToWritings[_topic][i];
                j++;
            }
        }
        return output;
    }
}