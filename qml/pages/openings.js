// Function inOpenings(), row 8

/////////////////////////////////////////////////////////
// this function tests if the move chain reflects some opening
/////////////////////////////////////////////////////////


function inOpenings() {
    // The loop finds the possible moves to selOpenings array
    // If opening still valid, no change is evaluated
    if (opsi.openingSelected.slice(0,4*opsi.movesTotal) == movesDone
            && opsi.openingSelected.slice(4*opsi.movesTotal,4*opsi.movesTotal+1) !== "") {
    }
    // Searching valid opening
    else if (openingMode == 3){
        if (openingGameMoves.slice(0,4*opsi.movesTotal) == movesDone
                && openingGameMoves.slice(4*opsi.movesTotal,4*opsi.movesTotal+1) !== "") {
            opsi.openingSelected = openingGameMoves;
            opsi.openingPossible = true;
            console.log("Opening 3 ", openingGameMoves)
        }
        else  {
            opsi.openingSelected = "";
            opsi.openingPossible = false;
        }
    }

    else {
        for(var i = 0; i < opsi.openings.length; i = i+1){
            opsi.openingCompare = opsi.openings[i].moves;
            if (opsi.openingCompare.slice(0,4*opsi.movesTotal) == movesDone
                    && opsi.openingCompare.slice(4*opsi.movesTotal,4*opsi.movesTotal+1) !== "") {
                if (openingMode == 1) {
                    opsi.selOpenings.push(opsi.openings[i].moves);
                    console.log("Possible opening", opsi.openings[i].eco);
                }
                else if (openingMode == 2 && opsi.openings[i].eco == openingECO) {
                    opsi.selOpenings.push(opsi.openings[i].moves);
                    console.log("ECO opening", opsi.openings[i].eco);
                }
            }
            else {
                // Nothing
            }
        }
        console.log("selected moves",opsi.selOpenings);
        // Selecting random opening
        if (opsi.selOpenings.length>0) {
            opsi.rantomi = Math.random()*opsi.selOpenings.length;
            opsi.openingSelected = opsi.selOpenings[opsi.rantomi];
            opsi.openingPossible = true;
            opsi.selOpenings.length = 0; //Emptying the selected moves list
        }
        else {
            opsi.openingSelected = "";
            opsi.openingPossible = false;
        }
        console.log("Selected opening", opsi.openingSelected)
    }
}
