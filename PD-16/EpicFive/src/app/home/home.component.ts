import { Component, OnInit } from '@angular/core';
import Web3 from 'web3';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
  fromAddress!: string;
  epicFive!: any;

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
      console.log(this.epicFive);
    });
  }

}