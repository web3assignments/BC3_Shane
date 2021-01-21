pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract Gachagang {
    enum Rarity{ One, Two, Three, Four, Five }

    uint8 constant singleCost = 50;
    uint constant tenCost = 500;
    
    uint balance;
    
    struct Unit {
        string name;
        Rarity rarity;
        uint8 level;
        string skill;
    }
    
    Unit[] public pulls;
    
    mapping(string => Unit) public units;
    
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
    
    function randomizedNumber(uint count) public view returns (uint) {
        uint random =  uint(keccak256(abi.encodePacked(block.timestamp, count, block.difficulty)))%10000;
        return random;
    }
    
    function pullSingleUnit() public {
        uint rng = randomizedNumber(1);
        require(balance >= singleCost, "You do not have enough gems to a summon.");
        balance -= singleCost;
        if(rng < 150) {
            pulls.push(units["Five Star"]);
        } else if (rng < 500) {
            pulls.push(units["Four Star"]);
        } else if (rng < 750) {
            pulls.push(units["Three Star"]);
        } else if (rng < 3000) {
            pulls.push(units["Two Star"]);
        } else {
            pulls.push(units["One Star"]);
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
