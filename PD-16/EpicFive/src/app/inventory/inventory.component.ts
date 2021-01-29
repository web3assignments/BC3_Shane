import { Component, OnInit, ViewChild } from '@angular/core';
import {MatPaginator} from '@angular/material/paginator';
import {MatSort} from '@angular/material/sort';
import {MatTableDataSource} from '@angular/material/table';
import Web3 from 'web3';

export interface Unit {
  name: string;
  rarity: number;
  level: number;
  skill: string;
}

@Component({
  selector: 'app-inventory',
  templateUrl: './inventory.component.html',
  styleUrls: ['./inventory.component.scss']
})
export class InventoryComponent implements OnInit {
  epicFive: any;
  units!: Unit[];
  unitsError!: string;
  fromAddress!: string;

  displayedColumns: string[] = ['name', 'rarity', 'level', 'skill'];
  dataSource!: MatTableDataSource<Unit>;

  @ViewChild(MatPaginator) paginator!: MatPaginator;
  @ViewChild(MatSort) sort!: MatSort;

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
      this.epicFive.methods.getUnits().call().then((res: any) => {
        this.units = res;
        this.dataSource = new MatTableDataSource(this.units);
        this.dataSource.paginator = this.paginator;
        this.dataSource.sort = this.sort;
        console.log(res);
      }).catch((err: any) => {
        this.unitsError = err;
        console.log(err);
      });
      console.log(this.epicFive);
    });

  }

  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

}
