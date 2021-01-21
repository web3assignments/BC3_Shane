pragma solidity >= 0.6;
pragma experimental ABIEncoderV2;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "../EpicSevenOld.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract GachagangTest {
    Gachagang gacha;

    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        // Here should instantiate tested contract
        gacha = new Gachagang();
    }
    
    function getInitialBalance() public returns (bool) {
        return Assert.equal(gacha.getBalance(), 600, "Balance should be 600");
    }
    
    function GenerateRandomNumberAndShouldFail() public {
        Assert.equal(gacha.randomizedNumber(5), 5, "Should be random");
    }
    
    function singlePull() public {
        gacha.pullSingleUnit();
        Assert.equal(gacha.getBalance(), 550, "New balance should be 550");
    }
    
    function tenPull() public {
        gacha.pullTenUnits();
        Assert.equal(gacha.getBalance(), 50, "New balance should be 50");
    }
    
    function getUnits() public {
        gacha.pullSingleUnit();
        Assert.equal(gacha.getUnits().length, 12, "Pulled units should contain 12 units");
    }
}
