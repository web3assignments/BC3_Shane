pragma solidity >= 0.6;
pragma experimental ABIEncoderV2;

import "https://raw.githubusercontent.com/smartcontractkit/chainlink/master/evm-contracts/src/v0.6/VRFConsumerBase.sol";

/// @title Gacha game inspired by EpicSeven
/// @author Shane
contract Gachagang is VRFConsumerBase {
    
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;
    
    enum Rarity{ One, Two, Three, Four, Five }
    
    struct Unit {
        string name;
        Rarity rarity;
        uint8 level;
        string skill;
    }
    
    Unit[] private pulls;
    
    mapping(string => Unit) units;
    
    event Summon(Unit unit);
    
    /// @dev Remove the created units from constructor and give it an own function to initialize.
    constructor() VRFConsumerBase(
            0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF Coordinator
            0x01BE23585060835E02B77ef475b0Cc51aA1e0709  // LINK Token
        ) public {
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10 ** 18; // 0.1 LINK
        
        initialize();
    }
    
    modifier checkPullValidity(uint count) {
        require(count == 1 || count == 10, "The amount you want to pull is not available, only 1 or 10 pulls are allowed!");
        _;
    }
        
     /** 
     * Requests randomness from a user-provided seed
     */
    function getRandomNumber(uint256 userProvidedSeed) public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee, userProvidedSeed);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        pullUnit(uint256(keccak256(abi.encodePacked(randomness))) % 200);
        randomResult = randomness % 200;
    }
    
    /// @notice Select if you want to do a single or ten pull. 
    /// @param count is the amount of pulls you want to do. Only accepts 1 or 10.
    function Pull(uint count) public payable checkPullValidity(count){
        for(uint i = 0; i < count; i++) {
            getRandomNumber(count);
        }
    }
    
    /// @notice Calculate what unit you have received from your pull
    /// @param rng is the Random value that it receives from the provable callback function
    function pullUnit(uint rng) private {
        if(rng < 1) {
            pulls.push(units["Five Star"]);
        } else if (rng < 50) {
            pulls.push(units["Four Star"]);
        } else if (rng < 80) {
            pulls.push(units["Three Star"]);
        } else if (rng < 100) {
            pulls.push(units["Two Star"]);
        } else {
            pulls.push(units["One Star"]);
        }
         emit Summon(pulls[pulls.length -1]);
    }
    
    function addUnit(string memory _name, Rarity _rarity, uint8 _level, string memory _skill) public {
        if(_rarity == Rarity.Five) {
            units["Five Star"] = Unit({
            name: _name,
            rarity: _rarity,
            level: _level,
            skill: _skill
            });
        } else if (_rarity == Rarity.Four) {
            units["Four Star"] = Unit({
            name: _name,
            rarity: _rarity,
            level: _level,
            skill: _skill
            });
        } else if (_rarity == Rarity.Three) {
            units["Three Star"] = Unit({
            name: _name,
            rarity: _rarity,
            level: _level,
            skill: _skill
            });
        } else if (_rarity == Rarity.Two) {
            units["Two Star"] = Unit({
            name: _name,
            rarity: _rarity,
            level: _level,
            skill: _skill
            });
        } else if (_rarity == Rarity.One) {
            units["One Star"] = Unit({
            name: _name,
            rarity: _rarity,
            level: _level,
            skill: _skill
            });
        }
    }
    
    /// @notice Get all cards that were pulled
    /// @return a list of cards
    function getUnits() public view returns (Unit[] memory) { 
        return pulls;
    }
    
    function clearUnits() public {
        delete pulls;
    }
    
    function initialize() private {
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

}
