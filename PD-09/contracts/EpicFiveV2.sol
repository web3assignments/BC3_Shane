pragma solidity >= 0.6;
pragma experimental ABIEncoderV2;

import "./ProvableAPI_0.6.sol";
import "./SafeMath.sol";
import "./Initializable.sol";

/// @title Gacha game inspired by EpicSeven
/// @author Shane
contract GachagangV2 is usingProvable, Initializable {
    
    using SafeMath for uint256;
        
    bytes32 public queryId;
    
    enum Rarity{ One, Two, Three, Four, Five }

    uint pullCount;
    uint balance;
    
    struct Unit {
        string name;
        Rarity rarity;
        uint8 level;
        string skill;
    }
    
    Unit[] private pulls;
    
    mapping(string => Unit) units;
    
    event Summon(Unit[] units);
    
    /// @dev Remove the created units from constructor and give it an own function to initialize.
    function initialize() public initializer payable {
        provable_setProof(proofType_Ledger);

        units["Five Star"] = Unit ({
            name: "Kayron",
            rarity: Rarity.Five,
            level: 1,
            skill: "Void slash"
        });
        
        units["Four Star"] = Unit ({
            name: "Fighter Maya",
            rarity: Rarity.Four,
            level: 1,
            skill: "Strike of Provocation"
        });
        
        units["Three Star"] = Unit ({
            name: "Hurado",
            rarity: Rarity.Three,
            level: 1,
            skill: "Staff Strike"
        });
            
        units["Two Star"] = Unit ({
            name: "Forest Cloud Penguin",
            rarity: Rarity.Two,
            level: 1,
            skill: "EXP Fodder"
        });
    
        units["One Star"] = Unit ({
            name: "Breezy-Wood Penguin",
            rarity: Rarity.One,
            level: 1,
            skill: "EXP Fodder"
        });
    }
    
    modifier checkPullValidity(uint count) {
        require(count == 1 || count == 10, "The amount you want to pull is not available, only 1 or 10 pulls are allowed!");
        _;
    }
        
    function __callback(bytes32  _queryId,string memory _result,bytes memory _proof ) override public {
        if (provable_randomDS_proofVerify__returnCode(_queryId,_result,_proof)== 0) {
            pullUnit(uint256(keccak256(abi.encodePacked(_result))) % 200);
        }
    }
    
    /// @notice Select if you want to do a single or ten pull. 
    /// @param count is the amount of pulls you want to do. Only accepts 1 or 10.
    function Pull(uint count) public payable checkPullValidity(count){
        for(uint i = 0; i < count; i++) {
            queryId=provable_newRandomDSQuery(
            0,          // QUERY_EXECUTION_DELAY
            5,          // NUM_RANDOM_BYTES_REQUESTED
            200000      // GAS_FOR_CALLBACK
            );
        }
    }
    
    /// @notice Calculate what unit you have received from your pull
    /// @param rng is the Random value that it receives from the provable callback function
    function pullUnit(uint rng) private {
        if(rng < 1) {
            pulls.push(units["Five Star"]);
        } else if (rng < 10) {
            pulls.push(units["Four Star"]);
        } else if (rng < 20) {
            pulls.push(units["Three Star"]);
        } else if (rng < 30) {
            pulls.push(units["Two Star"]);
        } else {
            pulls.push(units["One Star"]);
        }
    }
    
    /// @notice Get all cards that were pulled
    /// @return a list of cards
    function getUnits() public view returns (Unit[] memory) { 
        return pulls;
    }
    
    /// @notice Returns the balance of the user
    /// @dev Add the actual implementation of this
    /// @return the balance
    function getBalance() public view returns (uint) {
        return balance;
    }

}