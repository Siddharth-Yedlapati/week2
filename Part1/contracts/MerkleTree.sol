//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import { PoseidonT3 } from "./Poseidon.sol"; //an existing library to perform Poseidon hash on solidity
import "./verifier.sol"; //inherits with the MerkleTreeInclusionProof verifier contract

contract MerkleTree is Verifier {
    uint256[] public hashes; // the Merkle tree in flattened array form
    uint256 public index = 0; // the current index of the first unfilled leaf
    uint256 public root; // the current Merkle root

    constructor() {
        // [assignment] initialize a Merkle tree of 8 with blank leaves
        uint i;
        uint j;
        j = 0;
        for(i = 0; i < 15; i++)
        {
        	hashes.push(0);
        }
        
        for(i = 8; i < 15; i++)
        {
        	hashes[i] = PoseidonT3.poseidon([hashes[j], hashes[j+1]]);
        	j = j + 2;
        }
        root = hashes[14];
    }

    function insertLeaf(uint256 hashedLeaf) public returns (uint256) {
        // [assignment] insert a hashed leaf into the Merkle tree
        uint temp1;
        uint temp2;
        uint temp3;
        // require(index < 8, "No more leaves can be added into the tree");
        hashes[index] = hashedLeaf;
        temp3 = index;
        while(temp3 != 14){
        	if(temp3%2 == 0){
        		temp1 = hashes[temp3];
        		temp2 = hashes[temp3 + 1];
        	}
        	else{
        		temp1 = hashes[temp3 - 1];
        		temp2 = hashes[temp3];
        	}
        	temp3 = 8 + (temp3/2);
        	hashes[temp3] = PoseidonT3.poseidon([temp1, temp2]);
        }
        root = hashes[temp3];
        index++;
        return root;
        
        
        
    }

    function verify(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[1] memory input
        ) public view returns (bool) {

        // [assignment] verify an inclusion proof and check that the proof root matches current root
        return verifyProof(a, b, c, input);
    }
}
