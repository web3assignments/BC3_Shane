pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract Gachagang {
    enum Rarity{ One, Two, Three, Four, Five }
    
    // Add price to pull later
    //uint constant gemCost = 50;
    
    struct Unit {
        string name;
        Rarity rarity;
        uint level;
        string skill;
    }
    
    // Added banner struct for specific character pools
    struct Banner {
        string name;
        Unit unit;
    }
    
    Unit[] private units;
    Unit[] private pulls;
    
    event NewUnit(string name, Rarity rarity, uint level, string skill);
    
    constructor() public {
        units.push(Unit({
            name: "Kayron",
            rarity: Rarity.Five,
            level: 1,
            skill: "Immortality"
        }));
        
        units.push(Unit({
            name: "Fighter Maya",
            rarity: Rarity.Four,
            level: 1,
            skill: "Finishing Attack"
        }));
        
        units.push(Unit({
            name: "Hurado",
            rarity: Rarity.Three,
            level: 1,
            skill: "Push back & Strip"
        }));
        
        units.push(Unit({
            name: "Forest Cloud Penguin",
            rarity: Rarity.Two,
            level: 1,
            skill: "EXP Fodder"
        }));
        
        units.push(Unit({
            name: "Breezy-Wood Penguin",
            rarity: Rarity.One,
            level: 1,
            skill: "EXP Fodder"
        }));
    }
    
    // Created for later
    function createUnit(string memory _name, Rarity _rarity, uint _level, string memory _skill) private {
        units.push(Unit(_name, _rarity, 1, _skill));
        emit NewUnit(_name, _rarity, _level, _skill);
    }
    
    function randomizedNumber(uint count) private view returns (uint) {
        uint random =  uint(keccak256(abi.encodePacked(block.timestamp, count, block.difficulty)))%10000;
        return random;
    }
    
    function pullSingleUnit() public view returns (Unit memory){
        uint rng = randomizedNumber(1);
        if(rng < 275) {
            return units[0];
        } else if (rng < 750) {
            return units[1];
        } else if (rng < 1250) {
            return units[2];
        } else if (rng < 3000) {
            return units[3];
        } else {
            return units[4];
        }
    }
    
    function pullTenUnits() public {
        for(uint i = 1; i < 11; i++){
            uint rng = randomizedNumber(i);
            if(rng < 275) {
                pulls.push(units[0]);
            } else if (rng < 750) {
                pulls.push(units[1]);
            } else if (rng < 1250) {
                pulls.push(units[2]);
            } else if (rng < 3000) {
                pulls.push(units[3]);
            } else {
                pulls.push(units[4]);
            }
        }
    }
    
    function getUnits() public view returns (Unit[] memory) { 
        return pulls;
    }

}
