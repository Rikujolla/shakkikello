// Function inOpenings(), row 8

/////////////////////////////////////////////////////////
// this function tests iv the move chain reflects some opening
/////////////////////////////////////////////////////////


function inOpenings() {
    //opsi.openingPossible = false;
    //console.log("opening", openingMode);
    //opsi.rantomi = Math.random() * 9;
    console.log("openings", opsi.openings.length)
    // The loop finds the possible moves to selOpenings array
// Jos jo opening valid
    if (opsi.openingSelected.slice(0,4*opsi.movesTotal) == opsi.movesDone
            && opsi.openingSelected.slice(4*opsi.movesTotal,4*opsi.movesTotal+1) !== "") {
    }
    else {


    // Jos ei valid etsitään uusi
    for(opsi.yx = 0; opsi.yx < opsi.openings.length; opsi.yx = opsi.yx+1){
        opsi.openingCompare = opsi.openings[opsi.yx].moves;
        console.log("Tehdyt siirrot", opsi.movesTotal, opsi.movesDone);
        //console.log("eco", opsi.openingCompare.slice(4,8));
        if (opsi.openingCompare.slice(0,4*opsi.movesTotal) == opsi.movesDone
                && opsi.openingCompare.slice(4*opsi.movesTotal,4*opsi.movesTotal+1) !== "") {
            console.log("openissa ollaan", opsi.openings[opsi.yx].eco);
            //opsi.openingPossible = true;
//            break;
            opsi.selOpenings.push(opsi.openings[opsi.yx].moves);
        }
        else {
            // Nothing
        }
    }
    //console.log("pituus", opsi.selOpenings.length)
    console.log("selected moves",opsi.selOpenings);
    // Selecting random opening
    if (opsi.selOpenings.length>0) {
        opsi.rantomi = Math.random()*opsi.selOpenings.length;
        console.log("rand", opsi.rantomi);
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
