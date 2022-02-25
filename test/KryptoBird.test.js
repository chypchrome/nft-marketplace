const {assert} = require('chai')
const KryptoBird = artifacts.require('./Kryptobird')

//check for chai
require('chai')
.use(require('chai-as-promised'))
.should()

contract ('KryptoBird', (accounts) => {
  let contract
  //Before tells test to run this first, before anything else. Swift is so much smarter compared to this shit.
  before( async ()=> {
    contract = await KryptoBird.deployed()
  })

  //testing container -- describe
  describe('deployment', async()=> {
    //test samples with writing it.
    it('deploy successfully', async() => {
      contract = await KryptoBird.deployed()
      const address = contract.address;
      assert.notEqual(address, "cannot be empty")
      assert.notEqual(address, null)
      assert.notEqual(address, 0x0)
      assert.notEqual(address, undefined)
    })

    //Second test here.

    it('name and symbol match', async() => {
      // let name = contract.name()
      let name = await contract.name()
      let symbol = await contract.symbol()
      assert.equal(name, "KryptoBird")
      assert.equal(symbol, "KBIRDZ")
    })

    //Seems like writing await for the contract name and symbol seems a little redundant.
  })

  describe('minting', async()=> {
    it('creates a new token', async() => {
      const result = await contract.mint('1')
      const totalSupply = await contract.totalSupply()

      assert.equal(totalSupply, 1)
      const event = result.logs[0].args

      assert.equal(event._from, "0x0000000000000000000000000000000000000000", "from is the contract")
      assert.equal(event._to, accounts[0], "to is msg.sender")

      //Failure
      await contract.mint('1').should.be.rejected;

    })
  })

  //New Test for indexing through the kbirdz. yo.
  describe('indexing', async()=> {
    it('lists the kryptoBirdz', async() => {

      await contract.mint('2')
      await contract.mint('3')
      await contract.mint('4')

      //Duh move the totalSupply check to after the minting. Passes :)))
      const totalSupply = await contract.totalSupply()

      let result = []
      let kryptoBird

      //Obviously loop through and add them to the array.
      for (i = 1; i <= totalSupply; i++) {
        kryptoBird = await contract.kryptoBirdz(i - 1)
        result.push(kryptoBird)
      }

      let arrayShould = ["1", "2", "3", "4"]
      assert.equal(result.join(','), arrayShould.join(','))

    })
  })
})
