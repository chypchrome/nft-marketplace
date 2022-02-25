import React, {Component} from "react";
import Web3 from "web3";
import detectEthereumProvider from '@metamask/detect-provider'
import KryptoBird from "../abis/KryptoBird.json"
import { FormControlStatic } from "react-bootstrap";
import { MDBCard, MDBCardBody, MDBCardTitle, MDBCardText, MDBCardImage, MDBBtn } from 'mdb-react-ui-kit';
import './App.css'

class App extends Component {

//Let's check if there's an ETH provider (metamask, MEW, etc.) and connected.
  async componentDidMount() {
    await this.loadWeb3();
    await this.loadBlockchainData();
  }

  async loadWeb3() {
    const provider = await detectEthereumProvider();
    //Check for modern browser. If provider, then let's log that it's working and access the window.


    if (provider) {
      console.log('Ethereum wallet is detected.')
      window.web3 = new Web3(provider)

      //For some reason it doesn't show that the wallet is connected on metamask wallet but the provider is enabled. 
      //It's simply not connecting. How do we connect?
    } else {
      console.log('no eth wallet detected.')
      window.alert('Please make sure Metamask is installed.')
    }

  }

  async loadBlockchainData() {
    //Let's try our discord frens solution 
    // const web3Eth = window.ethereum
    // const ethAccounts = await web3Eth.request({method: 'eth_requestAccounts'})

    const web3 = window.web3
    //use requestAccounts() instead of getAccounts()
    //So it seems like getAccounts works if you're already connected, if not you need to request. 

    // const accounts = await web3.eth.requestAccounts()

    try {
      const accounts = await window.ethereum.request({
        method: 'eth_requestAccounts'
      })

      this.setState({account: accounts[0]})
      console.log('accounts', accounts)
 
    } catch (error) {
      console.log(error);
      window.alert("Error" + ' ' + error.message)
    }

    
    const networkId = await web3.eth.net.getId()
    const networkData = KryptoBird.networks[networkId]
   
    
    if (networkData) {
      const abi =  KryptoBird.abi
      const networkDataAddress = networkData.address
      const contract = new web3.eth.Contract(abi, networkDataAddress)
      this.setState({contract: contract})

      //Call the total supply of the birds. 
      const totalSupply = await contract.methods.totalSupply().call()
      this.setState({totalSupply})

      //Create an array to store the kryptoBirdz in. 
      //load the kryptoBirdz

      for (let i = 1; i <= totalSupply; i++) {
        const kryptoBird = await contract.methods.kryptoBirdz(i - 1).call()
        //How do we handle the state on the front end?
        this.setState({
          kryptoBirdz: [...this.state.kryptoBirdz, kryptoBird]
        })

      }

    } else {
      window.alert("Smart Contract not deployed.")
    }
  }

  //With minting we need to specify the account. 
  mint = (kryptoBird) => {
    //The state of the contract is stored upon loading, so we load the contract from the state :D 
    //Creating a new instance would likely do some wild shit. 
    console.log('kryptoBird minting function', this.state.contract)

    this.state.contract.methods.mint(kryptoBird).send({from: this.state.account})
    .once('receipt', () =>{
      this.setState({
        kryptoBirdz: [...this.state.kryptoBirdz, kryptoBird]
      })

      this.render()
    })




  }

  constructor (props) {
    super(props);
    this.state = {
      account: '',
      contract: null,
      totalSupply: 0,
      kryptoBirdz: []
    }
  }
  

  render() {
    return (
      <div className="container-filled">
        {console.log(this.state.kryptoBirdz)}
        <nav className ='navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow'>
          <div className ='navbar-bran col-sm-3 col-md-3 mr-0' style={{color:'white'}}>
            Krypto Birdz NFTs (Non Fungible Tokens)
          </div>

          <ul className='navbar-nav px-3'>
          <li className='nav-item text-nowrap d-none d-sm-none d-sm-block'>
            <small className='text-white'>
              {this.state.account}
            </small>
          </li>
          </ul>
        </nav>

        <div className = 'container-fluid mt-1'>
          <div className='row'>
            <main role='main'
            className = 'col-lg-12 d-flex text-center'>
              <div className='content mr-auto ml-auto'
              style={{opacity: '0.8'}}>
                <h1 style={{color:'black'}}>KryptoBirdz - NFT Marketplace</h1>
                <form onSubmit={(event)=>{
                  event.preventDefault()
                  const kryptoBird = this.kryptoBird.value
                  this.mint(kryptoBird)
                }}>
                  <input
                  type='text'
                  placeholder='Add a file location'
                  className='form-control mb-1'
                  ref={(input)=>this.kryptoBird = input}
                  />

                  <input style={{margin:'6px'}}
                  type='submit'
                  className='btn btn-primary btn-black'
                  value='MINT' 
                  />

                </form>
              </div>
            </main>
          </div>
              <hr></hr>
              <div className="row textCenter"></div>
              {this.state.kryptoBirdz.map((kryptoBird, key)=> {
                return(
                  <div>
                    <div>
                      <MDBCard className="token img" style={{maxWidth: "22rem"}}> 
                      <MDBCardImage src={kryptoBird} position="top" height='250rem' style={{marginRight: "4px"}}/>
                      <MDBCardBody>
                      <MDBCardTitle>KryptoBirdz</MDBCardTitle>
                      <MDBCardText>Here are the types of kbirdz dawg</MDBCardText>
                      <MDBBtn href={kryptoBird}>Download</MDBBtn>
                      </MDBCardBody>
                      </MDBCard>
                    </div>
                  </div> 
                )
              })}

        </div>
      </div>
    )
  }
}


export default App;
