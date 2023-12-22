// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract FTPprotocol {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Function to transfer ownership of a contract to another address
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid new owner");
        owner = newOwner;
    }
}

contract WraithProtocol {
    address public owner;
    address public marketplace;
    
    struct DataEntry {
        string date;
        string indexHeader;
        uint256[4] indexNumbers;
        string indexFormula;
        bool isSold;
    }

    mapping(uint256 => DataEntry) public dataEntries;
    uint256 public currentEntryId;

    event DataAdded(
        uint256 indexed entryId,
        string date,
        string indexHeader,
        uint256[4] indexNumbers,
        string indexFormula
    );
    event DataSold(uint256 indexed entryId, address buyer, uint256 price);
    event BidPlaced(address indexed bidder, uint256 indexed entryId, uint256 price);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor(address _marketplace) {
        owner = msg.sender;
        marketplace = _marketplace;
    }

    // Function to add data to the oracle
    function addData(
        string memory _date,
        string memory _indexHeader,
        uint256[4] memory _indexNumbers,
        string memory _indexFormula
    ) external onlyOwner {
        require(bytes(_date).length > 0, "Date is required");
        require(bytes(_indexHeader).length > 0, "Index header is required");
        require(_indexNumbers[0] > 0, "At least 1 index number is required");

        currentEntryId++;
        dataEntries[currentEntryId] = DataEntry({
            date: _date,
            indexHeader: _indexHeader,
            indexNumbers: _indexNumbers,
            indexFormula: _indexFormula,
            isSold: false
        });

        emit DataAdded(currentEntryId, _date, _indexHeader, _indexNumbers, _indexFormula);
    }

    // Function to retrieve data by entry ID
    function getDataById(uint256 _entryId)
        external
        view
        returns (
            string memory date,
            string memory indexHeader,
            uint256[4] memory indexNumbers,
            string memory indexFormula,
            bool isSold
        )
    {
        DataEntry memory entry = dataEntries[_entryId];
        return (entry.date, entry.indexHeader, entry.indexNumbers, entry.indexFormula, entry.isSold);
    }

    // Function to mark data as sold
    function markDataAsSold(uint256 _entryId) external onlyOwner {
        dataEntries[_entryId].isSold = true;
    }

    // Function for a wallet from the marketplace to place a bid
    function bid(uint256 _entryId, uint256 _price) external {
        require(msg.sender == marketplace, "Only marketplace can bid");

        // Emit an event indicating a bid
        emit BidPlaced(msg.sender, _entryId, _price);
    }

    // Function for the owner to accept or decline a bid
    function acceptReveal(uint256 _entryId, bool _accept) external onlyOwner {
        require(dataEntries[_entryId].isSold == false, "Data already sold");

        address bidder = msg.sender; // Placeholder for actual bidder address
        uint256 price = 123; // Placeholder for actual bid price

        if (_accept) {
            // Trigger logic to send data to the bidder
            // You should implement the logic to send data based on your requirements

            // Mark data as sold
            dataEntries[_entryId].isSold = true;

            // Emit an event indicating the sale
            emit DataSold(_entryId, bidder, price);
        } else {
            // Decline the bid
            // You can add additional logic or emit an event if needed
        }
    }
}

contract Wraith is ERC721, FTPprotocol {
    address public wraithProtocolAddress;
    address public ownerMarketplace;
    uint256 public wraithId;
    string public jpegNFT; // Placeholder for JPEG NFT URI
    string public indexNumbersExplanation; // Private value explaining index numbers
    string public wraithAd; // Public marketing pitch

    event WraithCreated(
        address indexed wraithContract,
        uint256 indexed wraithId,
        uint256 indexed index,
        string date
    );

    constructor(
        address _wraithProtocol,
        uint256 _wraithId,
        uint256 _index,
        string memory _date,
        string memory _jpegNFT,
        string memory _indexNumbersExplanation,
        string memory _wraithAd
    ) ERC721("Wraith NFT", "WRAITH") {
        owner = msg.sender;
        wraithProtocolAddress = _wraithProtocol;
        ownerMarketplace = address(0);
        wraithId = _wraithId;
        jpegNFT = _jpegNFT;
        indexNumbersExplanation = _indexNumbersExplanation;
        wraithAd = _wraithAd;

        WraithProtocol wraithProtocol = WraithProtocol(_wraithProtocol);
        wraithProtocol.addData(_date, _index, _jpegNFT, _indexNumbersExplanation, _wraithAd);

        emit WraithCreated(address(this), _wraithId, _index, _date);
    }

    // Function to set the owner's marketplace address
    function setOwnerMarketplace(address _ownerMarketplace) external onlyOwner {
        ownerMarketplace = _ownerMarketplace;
    }

    // Function to accept a reveal
    function acceptReveal(uint256 _entryId, bool _accept) external onlyOwner {
        WraithProtocol wraithProtocol = WraithProtocol(wraithProtocolAddress);
        wraithProtocol.acceptReveal(_entryId, _accept);
    }

    // Function to place a bid
    function bid(uint256 _entryId, uint256 _price) external {
        require(_price > 0, "Bid price must be greater than 0");
        require(ownerMarketplace != address(0), "Owner's marketplace address not set");

        WraithProtocol wraithProtocol = WraithProtocol(wraithProtocolAddress);
        wraithProtocol.bid(_entryId, _price);
    }

    // Function to get JPEG NFT URI
    function getJpegNFT() external view returns (string memory) {
        return jpegNFT;
    }

    // Function to get index numbers explanation
    function getIndexNumbersExplanation() external view returns (string memory) {
        return indexNumbersExplanation;
    }

    // Function to get WraithAd
    function getWraithAd() external view returns (string memory) {
        return wraithAd;
    }
}
