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

  constructor() { }

  ngOnInit(): void {
    const tokenAbi = require('../../assets/contract-info/epicfive.json');

    let web3 = new Web3(Web3.givenProvider || "http://localhost:8545");
    
    var Address = "0x29f51B24F8146B5dd065c6c0B504D1b58A317d77";
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
    this.epicFive.methods.pullSingleUnit().send({from:"0xEB3695CCc510e471857e306E7C17bb331DE06785"}).then((res: any) => {
      this.singleSuccess = res;
      console.log(res);
    }).catch((err: any) => {
      this.singleError = err;
      console.error(err);
    });
  }

  pullTenUnits() {
    this.epicFive.methods.pullTenUnits().send({from:"0xEB3695CCc510e471857e306E7C17bb331DE06785"}).then((res: any) => {
      this.tenSuccess = res;
      console.log(res);
    }).catch((err: any) => {
      this.tenError = err;
      console.error(err);
    });
  }

  getUnits() {
    this.epicFive.methods.getUnits().call().then((res: any) => {
      this.units = res;
      console.log(res);
    });
  }

}