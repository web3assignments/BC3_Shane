import { Component, OnInit } from '@angular/core';
import Web3 from 'web3';

@Component({
  selector: 'app-pull',
  templateUrl: './pull.component.html',
  styleUrls: ['./pull.component.scss']
})
export class PullComponent implements OnInit {
  epicFive: any;
  units!: string;
  singleSuccess!: string;
  singleError!: string;
  tenSuccess!: string;
  tenError!: string;
  unitsError!: string;
  fromAddress!: string;

  constructor() { }

  ngOnInit(): void {
    const tokenAbi = require('../../assets/contract-info/epicfive.json');

    let web3 = new Web3(Web3.givenProvider || "http://localhost:8545");
    const network = web3.eth.net.getId().then((res: any) => {
      if (typeof res === 'undefined' || res != 4) { 
        console.log("Please select Rinkeby test network");
      } else {
        console.log("Ethereum network: Rinkeby")
      }
    });

    const accounts = web3.eth.getAccounts().then((res: any) => {
      this.fromAddress = res[0];
      console.log(this.fromAddress);
    });

    var addr = web3.eth.ens.getAddress('epicfivefinal.eth').then( (address) => {
      this.epicFive = new web3.eth.Contract(tokenAbi, address);
      this.epicFive.events.Summon({fromBlock: "latest"}, (error: any, event: any) =>{
        console.log(event.returnValues.unit);
      });
      console.log(this.epicFive);
    });
  }

  pullSingleUnit() {
    this.epicFive.methods.Pull(1).send({from: this.fromAddress}).then((res: any) => {
      this.singleSuccess = res;
      console.log(res);
    }).catch((err: any) => {
      this.singleError = err;
      console.error(err);
    });
  }

  pullTenUnits() {
    this.epicFive.methods.Pull(10).send({from: this.fromAddress}).then((res: any) => {
      this.tenSuccess = res;
      console.log(res);
    }).catch((err: any) => {
      this.tenError = err;
      console.error(err);
    });
  }

}
