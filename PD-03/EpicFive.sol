pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract Gachagang {
    enum Rarity{ One, Two, Three, Four, Five }
    
    // Add price to pull later
    uint constant singleCost = 50;
    uint constant tenCost = 500;
    
    uint balance;
    
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
    
    Unit[] private allUnits;
    Unit[] private pulls;
    
    mapping(string => Unit) units;
    
    // Might remove this event later if i do not want to use it
    // event NewUnit(string name, Rarity rarity, uint level, string skill);
    
    event Summon(Unit[] units, uint balance);
    
    
    constructor() public {
        balance = 600;
        
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
    
    // // Created for later
    // function createUnit(string memory _name, Rarity _rarity, uint _level, string memory _skill) private {
    //     units.push(Unit(_name, _rarity, 1, _skill));
    //     emit NewUnit(_name, _rarity, _level, _skill);
    // }
    
    function randomizedNumber(uint count) private view returns (uint) {
        uint random =  uint(keccak256(abi.encodePacked(block.timestamp, count, block.difficulty)))%10000;
        return random;
    }
    
    function pullSingleUnit() public view returns (Unit memory){
        uint rng = randomizedNumber(1);
        require(balance >= singleCost, "You do not have enough gems to a summon.");
        if(rng < 275) {
            return units["Five Star"];
        } else if (rng < 750) {
            return units["Four Star"];
        } else if (rng < 1250) {
            return units["Three Star"];
        } else if (rng < 3000) {
            return units["Two Star"];
        } else {
            return units["One Star"];
        }
    }
    
    function pullTenUnits() public {
        require(balance >= tenCost, "You do not have enough gems to do a 10 summon.");
        for(uint i = 1; i < 11; i++){
            uint rng = randomizedNumber(i);
            if(rng < 275) {
                pulls.push(units["Five Star"]);
            } else if (rng < 750) {
                pulls.push(units["Four Star"]);
            } else if (rng < 1250) {
                pulls.push(units["Three Star"]);
            } else if (rng < 3000) {
                pulls.push(units["Two Star"]);
            } else {
                pulls.push(units["One Star"]);
            }
        }
        balance -= tenCost;
        emit Summon(pulls, balance);
    }
    
    function getUnits() public view returns (Unit[] memory) { 
        require((pulls.length > 0), "No units available to retrieve.");
        return pulls;
    }
    
    function getBalance() public view returns (uint) {
        return balance;
    }

}
