pragma solidity ^0.5.0;

contract Asset_Management {
    struct AssetManagementOffice {
        uint256 ID;
        string Name;
        string Address;
        uint256 NoOfOffices;
        address Owner;
    }

    struct Offices {
        uint256 OID;
        string Name;
        string Address;
        uint256 AMOID;
        uint256[] Assets;
        address Owner;
    }

    struct Manufacturers {
        uint256 MID;
        string Name;
        string Address;
        uint256[] Assets;
        address Owner;
    }

    struct Assets {
        uint256 AID;
        string Name;
        string AssetType;
        string Description;
        string Status;
    }

    /*struct OfficeInventory {
        uint256 OID;
        uint256 AID;
        uint256 Inventory;
    } 

    struct ManufacturerInventory {
        uint256 MID;
        uint256 AID;
        uint256 Inventory;
    } */

    struct RequestAssetTable {
        uint256 RID;
        uint256 OID;
        uint256 AID;
        uint256 AMOID;
        uint256 Quantity;
        string Status;
        string SupplyStatus;
    }

    struct RequestManufacturerTable {
        uint256 RMID;
        uint256 RID;
        uint256 AID;
        uint256 Quantity;
        string Status;
        uint256 AcceptedManufacturer;
    }

    mapping(uint256 => AssetManagementOffice) public assetmanagementoffice;
    mapping(uint256 => Offices) public offices;
    mapping(uint256 => Manufacturers) public manufacturers;
    mapping(uint256 => Assets) public assets;
    mapping(uint256 => mapping(uint256 => uint256)) public officeinventory;
    mapping(uint256 => mapping(uint256 => uint256))
        public manufacturerinventory;
    mapping(uint256 => RequestAssetTable) public requestassettable;
    mapping(uint256 => RequestManufacturerTable)
        public requestmanufacturertable;

    uint256 public AssetManagementOfficeCount;
    uint256 public OfficeCount;
    uint256 public ManufacturerCount;
    uint256 public AssetCount;
    uint256 public RequestCount;
    uint256 public RequestManufacturerCount;

    function addAssetManagementOffice(
        string memory _name,
        string memory _address
    ) public {
        AssetManagementOfficeCount++;
        assetmanagementoffice[AssetManagementOfficeCount] = AssetManagementOffice(
            AssetManagementOfficeCount,
            _name,
            _address,
            0,
            msg.sender
        );
    }

    function viewAssetManagementOffice(uint256 _id)
        public
        view
        returns (string memory, string memory)
    {
        require(
            msg.sender == assetmanagementoffice[_id].Owner,
            "Cant view other Asset Management Offices"
        );
        return (
            assetmanagementoffice[_id].Name,
            assetmanagementoffice[_id].Address
        );
    }

    function addOffices(
        string memory _name,
        string memory _address,
        uint256 _amoid,
        uint256[] memory _assets
    ) public {
        require(
            _amoid > 0 && _amoid <= AssetManagementOfficeCount,
            "Enter valid ID"
        );
        uint256 i;
        //uint256 j;
        uint256 counter;
        /* for (i = 0; i <= assets.length; i++) {
            for (j = 1; j <= _assets.length; j++) {
                if (_assets[i] == assets[j]) {
                    counter++;
                    break;
                }
            }
        } */
        for (i = 0; i < _assets.length; i++) {
            if (_assets[i] > 0 && _assets[i] <= AssetCount) {
                counter++;
            }
        }
        require(counter == _assets.length, "Enter correct Asset ID's");
        OfficeCount++;
        offices[OfficeCount] = Offices(
            OfficeCount,
            _name,
            _address,
            _amoid,
            _assets,
            msg.sender
        );
        assetmanagementoffice[_amoid].NoOfOffices++;
    }

    function viewOffices(uint256 _oid)
        public
        view
        returns (
            string memory,
            string memory,
            uint256[] memory
        )
    {
        return (
            offices[_oid].Name,
            offices[_oid].Address,
            offices[_oid].Assets
        );
    }

    function addManufacturers(
        string memory _name,
        string memory _address,
        uint256[] memory _assets
    ) public {
        uint256 i;
        uint256 counter;
        for (i = 0; i < _assets.length; i++) {
            if (_assets[i] > 0 && _assets[i] <= AssetCount) {
                counter++;
            }
        }
        require(counter == _assets.length, "Enter correct Asset ID's");
        ManufacturerCount++;
        manufacturers[ManufacturerCount] = Manufacturers(
            ManufacturerCount,
            _name,
            _address,
            _assets,
            msg.sender
        );
    }

    function viewManufacturers(uint256 _mid)
        public
        view
        returns (
            string memory,
            string memory,
            uint256[] memory
        )
    {
        return (
            manufacturers[_mid].Name,
            manufacturers[_mid].Address,
            manufacturers[_mid].Assets
        );
    }

    function addAssets(
        string memory _name,
        string memory _assettype,
        string memory _description
    ) public {
        AssetCount++;
        assets[AssetCount] = Assets(
            AssetCount,
            _name,
            _assettype,
            _description,
            "Approved"
        );
    }

    function viewAssets(uint256 _aid)
        public
        view
        returns (
            string memory,
            string memory,
            string memory
        )
    {
        return (
            assets[_aid].Name,
            assets[_aid].AssetType,
            assets[_aid].Description
        );
    }

    function addOfficeInventory(
        uint256 _oid,
        uint256 _aid,
        uint256 _inventory
    ) public {
        require(_oid > 0 && _oid <= OfficeCount, "Enter correct Office ID");
        require(_aid > 0 && _aid <= AssetCount, "Enter correct Asset ID");
        uint256 counter;
        uint256 i;
        uint256[] memory j = offices[_oid].Assets;
        for (i = 0; i < j.length; i++) {
            if (_aid == j[i]) {
                counter++;
            }
        }
        require(counter > 0, "Entered Asset is not present in the Office");
        officeinventory[_oid][_aid] = _inventory;
    }

    function viewOfficeInventory(uint256 _oid, uint256 _aid)
        public
        view
        returns (uint256)
    {
        return (officeinventory[_oid][_aid]);
    }

    function addManufacturerInventory(
        uint256 _mid,
        uint256 _aid,
        uint256 _inventory
    ) public {
        require(
            _mid > 0 && _mid <= ManufacturerCount,
            "Enter correct Manufacturer ID"
        );
        require(_aid > 0 && _aid <= AssetCount, "Enter correct Asset ID");
        uint256 counter;
        uint256 i;
        uint256[] memory j = manufacturers[_mid].Assets;
        for (i = 0; i < j.length; i++) {
            if (_aid == j[i]) {
                counter++;
            }
        }
        require(
            counter > 0,
            "Entered Asset is not present in the ManufacturerList"
        );
        manufacturerinventory[_mid][_aid] = _inventory;
    }

    function viewManufacturerInventory(uint256 _oid, uint256 _aid)
        public
        view
        returns (uint256)
    {
        return (manufacturerinventory[_oid][_aid]);
    }

    function placeAssetRequest(
        uint256 _oid,
        uint256 _aid,
        uint256 _quantity
    ) public {
        require(_oid > 0 && _oid <= OfficeCount, "Enter correct Office ID");
        require(_aid > 0 && _aid <= AssetCount, "Enter correct Asset ID");
        require(
            msg.sender == offices[_oid].Owner,
            "Cannot request Assets for other Offices"
        );
        uint256 i;
        uint256[] memory j = offices[_oid].Assets;
        uint256 counter;
        for (i = 0; i < j.length; i++) {
            if (_aid == j[i]) {
                counter++;
                break;
            }
        }
        require(counter > 0, "Item not found in the Office Inventory");
        RequestCount++;
        requestassettable[RequestCount] = RequestAssetTable(
            RequestCount,
            _oid,
            _aid,
            offices[_oid].AMOID,
            _quantity,
            "Pending",
            "Not Started"
        );
    }

    function viewRequest(uint256 _rid)
        public
        view
        returns (
            uint256,
            uint256,
            string memory
        )
    {
        require(_rid > 0 && _rid <= RequestCount, "Enter correct Request ID");
        return (
            requestassettable[_rid].AID, //return office ID too
            requestassettable[_rid].Quantity,
            requestassettable[_rid].Status
        );
    }

    function approveRequest(uint256 _rid) public {
        require(_rid > 0 && _rid <= RequestCount, "Enter correct Request ID");
        require(
            msg.sender ==
                assetmanagementoffice[requestassettable[_rid].AMOID].Owner,
            "Cannot approve the request"
        );
        require(
            keccak256(abi.encodePacked(requestassettable[_rid].Status)) ==
                keccak256(abi.encodePacked("Pending")),
            "Already Approved"
        );
        requestassettable[_rid].Status = "Approved";
        RequestManufacturerCount++;
        requestmanufacturertable[RequestManufacturerCount] = RequestManufacturerTable(
            RequestManufacturerCount,
            _rid,
            requestassettable[_rid].AID,
            requestassettable[_rid].Quantity,
            "Requested",
            0
        );
    }

    function viewRequestManufacturer(uint256 _rmid)
        public
        view
        returns (
            uint256,
            uint256,
            string memory,
            uint256
        )
    {
        return (
            requestmanufacturertable[_rmid].AID,
            requestmanufacturertable[_rmid].Quantity,
            requestmanufacturertable[_rmid].Status,
            requestmanufacturertable[_rmid].AcceptedManufacturer
        );
    }

    function acceptRequest(uint256 _rmid, uint256 _mid) public {
        require(
            _rmid > 0 && _rmid <= RequestManufacturerCount,
            "Enter correct RMID"
        );
        require(
            keccak256(
                abi.encodePacked(requestmanufacturertable[_rmid].Status)
            ) == keccak256(abi.encodePacked("Requested")),
            "Already Accepted"
        );
        uint256 i;
        uint256[] memory j = manufacturers[_mid].Assets;
        uint256 counter;
        for (i = 0; i < j.length; i++) {
            if (requestmanufacturertable[_rmid].AID == j[i]) {
                counter++;
                break;
            }
        }
        require(counter > 0, "Item is not found in the Manufacturer Inventory");
        requestmanufacturertable[_rmid].Status = "Approved";
        requestmanufacturertable[_rmid].AcceptedManufacturer = _mid;
        requestassettable[requestmanufacturertable[_rmid].RID]
            .SupplyStatus = "Started";
    }

    function supplyAssets(uint256 _rmid, uint256 _mid) public {
        require(
            _rmid > 0 && _rmid <= RequestManufacturerCount,
            "Enter correct RMID"
        );
        require(
            requestmanufacturertable[_rmid].AcceptedManufacturer == _mid,
            "Accepted by another Manufacturer"
        );
        require(
            requestmanufacturertable[_rmid].Quantity <=
                manufacturerinventory[_mid][requestmanufacturertable[_rmid]
                    .AID],
            "Not enough Inventory"
        );
        manufacturerinventory[_mid][requestmanufacturertable[_rmid].AID] =
            manufacturerinventory[_mid][requestmanufacturertable[_rmid].AID] -
            requestmanufacturertable[_rmid].Quantity;
        requestassettable[requestmanufacturertable[_rmid].RID]
            .SupplyStatus = "In Transit"; //Show the supply status
    }

    function receiveAssets(uint256 _rid) public {
        require(
            _rid > 0 && _rid <= RequestManufacturerCount,
            "Enter correct RID"
        );
        require(
            keccak256(abi.encodePacked(requestassettable[_rid].SupplyStatus)) ==
                keccak256(abi.encodePacked("In Transit")),
            "Not received from Manufacturer"
        );
        requestassettable[_rid].SupplyStatus = "Received";
    }

    function issueAssets(uint256 _rid) public {
        require(
            _rid > 0 && _rid <= RequestManufacturerCount,
            "Enter correct RID"
        );

        require(
            keccak256(abi.encodePacked(requestassettable[_rid].SupplyStatus)) ==
                keccak256(abi.encodePacked("Received")),
            "Check the status from Manufacturer"
        );
        require(
            keccak256(abi.encodePacked(requestassettable[_rid].Status)) ==
                keccak256(abi.encodePacked("Approved")),
            "Not yet Approved"
        );
        officeinventory[requestassettable[_rid].OID][requestassettable[_rid]
            .AID] =
            officeinventory[requestassettable[_rid].OID][requestassettable[_rid]
                .AID] +
            requestassettable[_rid].Quantity;
    }
}
