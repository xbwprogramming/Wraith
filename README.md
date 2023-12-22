# Wraith
Wraith Protocol is a cutting-edge decentralized data oracle and NFT platform. Data providers can securely upload valuable information to the blockchain using Wraith Protocol, creating unique NFTs backed by real-world data. The protocol enables seamless data trading in a decentralized marketplace, empowering data creators and consumers.

Detailed Breakdown:

WraithProtocol.sol

addData:
Inputs:
_date: Date associated with the data entry.
_indexHeader: Index header name.
_indexNumbers: Array of up to four index numbers.
_indexFormula: Optional formula associated with the index.
Details:
Only callable by the owner.
Adds a new data entry to the oracle.
Emits a DataAdded event.

getDataById:
Inputs:
_entryId: Identifier for a specific data entry.
Details:
Retrieves detailed information about a specific data entry.
Provides information such as date, index header, index numbers, index formula, and whether the data is sold.

markDataAsSold:
Inputs:
_entryId: Identifier for a specific data entry.
Details:
Marks a specific data entry as sold.
Only callable by the owner.

bid:
Inputs:
_entryId: Identifier for a specific data entry.
_price: Bid price.
Details:
Allows the marketplace to place bids on data entries.
Emits a BidPlaced event.
Accessible only to the marketplace address.

acceptReveal:
Inputs:
_entryId: Identifier for a specific data entry.
_accept: Boolean indicating whether to accept or decline the bid.
Details:
Allows the owner to accept or decline bids on a specific data entry.
Marks the data entry as sold if accepted.
Emits a DataSold event.



Wraith.sol
setOwnerMarketplace:
Inputs:
_ownerMarketplace: Address of the owner's marketplace.
Details:
Sets the owner's marketplace address.
Only callable by the owner.

acceptReveal:
Inputs:
_entryId: Identifier for a specific data entry.
_accept: Boolean indicating whether to accept or decline the bid.
Details:
Calls the acceptReveal function in the associated WraithProtocol contract.
Allows the owner to accept or decline bids.

bid:
Inputs:
_entryId: Identifier for a specific data entry.
_price: Bid price.
Details:
Allows the marketplace to place bids on data entries.
Emits a BidPlaced event.

getJpegNFT:
Details:
Retrieves the JPEG NFT URI associated with the Wraith.

getIndexNumbersExplanation:
Details:
Retrieves the private value explaining the index numbers associated with the Wraith.

getWraithAd:
Details:
Retrieves the public marketing pitch associated with the Wraith.
