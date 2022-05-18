pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/switcher.circom";

template CheckRoot(n) { // compute the root of a MerkleTree of n Levels 
    signal input leaves[2**n];
    signal output root;

    //[assignment] insert your code here to calculate the Merkle root from 2^n leaves
    var hashes[2**(n+1) - 1], i;
    var j = 0;
    component pos[2**n - 1];
    for(i = 2**n -1; i < 2**(n + 1) - 1; i++){
    	hashes[i] = leaves[j];
    	j++;
    }
    
    for(i = 2**n - 2; i >= 0; i--){
    	pos[i] = Poseidon(2);
    	pos[i].inputs[0] <== hashes[2*i + 1];
    	pos[i].inputs[1] <== hashes[2*i + 2];
    	hashes[i] = pos[i].out;
    }
    root <== hashes[0];
}

template MerkleTreeInclusionProof(n) {
    signal input leaf;
    signal input path_elements[n];
    signal input path_index[n]; // path index are 0's and 1's indicating whether the current element is on the left or right
    signal output root; // note that this is an OUTPUT signal

    //[assignment] insert your code here to compute the root from a leaf and elements along the path
    
    signal hashes[n + 1];
    hashes[0] <== leaf;
    component s[n];
    component h[n];
    
    for( var i = 0; i < n; i++){
    	h[i] = Poseidon(2);
	s[i] = Switcher();
	s[i].sel <== path_index[i];
	s[i].R <== path_elements[i];
	s[i].L <== hashes[0];
	
	h[i].inputs[0] <== s[i].outL;
	h[i].inputs[1] <== s[i].outR;
	
	hashes[i + 1] <== h[i].out;
	
    }
    
    root <== hashes[n];
}
