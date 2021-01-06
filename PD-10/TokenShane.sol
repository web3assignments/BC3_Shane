pragma solidity >= 0.6;

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/token/ERC20/ERC20.sol";

/// @author Shane
contract EpicFiveToken is ERC20 {
    
    constructor() public ERC20("EpicFive", "EFIVE") {
        _mint(msg.sender, 10000 * (10 ** uint256(decimals())));
    }
}
