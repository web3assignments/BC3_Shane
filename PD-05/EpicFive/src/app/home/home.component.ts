import { Component, OnInit } from '@angular/core';
import Web3 from 'web3';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
  epicFive: any;
  balance!: string;
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
    
    var Address = "0xCaF3F4dA4F4f9FaE8A6De925eFE6F8f430f3e428";
    this.epicFive = new web3.eth.Contract(tokenAbi, Address);
    console.log(this.epicFive);
  }

  getBalance() {
    this.epicFive.methods.getBalance().call().then((res: any) => {
      this.balance = res;
      console.log(res);
    });
  }

  pullSingleUnit() {
    this.epicFive.methods.pullSingleUnit().send({from: this.fromAddress}).then((res: any) => {
      this.singleSuccess = res;
      console.log(res);
    }).catch((err: any) => {
      this.singleError = err;
      console.error(err);
    });
  }

  pullTenUnits() {
    this.epicFive.methods.pullTenUnits().send({from: this.fromAddress}).then((res: any) => {
      this.tenSuccess = res;
      console.log(res.events.Summon.returnValues['units']);
    }).catch((err: any) => {
      this.tenError = err;
      console.error(err);
    });
  }

  getUnits() {
    this.epicFive.methods.getUnits().call().then((res: any) => {
      this.units = res;
      console.log(res);
    }).catch((err: any) => {
      this.unitsError = err;
      console.log(err);
    });
  }

}