// Function inOpenings(), row 8

/////////////////////////////////////////////////////////
// this function tests if the move chain reflects some opening
/////////////////////////////////////////////////////////


function inOpenings(recMove) {
    // Removing old openinghints from board
    for (var i=0;i<64; i++){
        galeryModel.set(i,{"openingop": 0});
    }

    // Promotion evaluation to help find if move is 5 letters
    if (recMove.length == 5){
        opsi.promotionsIncluded = opsi.promotionsIncluded + 1
    }

    var _moveLength = 4*opsi.movesTotal + opsi.promotionsIncluded

    // The loop finds the possible moves to selOpenings array
    // If opening still valid, no change is evaluated
    var nextMoveinOpening
    if (opsi.openingSelected.slice(0,_moveLength) == movesDone
            && opsi.openingSelected.slice(_moveLength,_moveLength+1) !== "") {
    }
    // Searching valid opening
    else if (openingMode == 3){
        if (openingGameMoves.slice(0,_moveLength) == movesDone
                && openingGameMoves.slice(4*_moveLength,_moveLength+1) !== "") {
            opsi.openingSelected = openingGameMoves;
            opsi.openingPossible = true;
        }
        else  {
            opsi.openingSelected = "";
            opsi.openingPossible = false;
        }
    }

    else {
        for(i = 0; i < opsi.openings.length; i = i+1){
            opsi.openingCompare = opsi.openings[i].moves;
            if (opsi.openingCompare.slice(0,_moveLength) == movesDone
                    && opsi.openingCompare.slice(_moveLength,_moveLength+1) !== "") {
                if (openingMode == 1) {
                    opsi.selOpenings.push(opsi.openings[i].moves);
                    //console.log("Possible opening", opsi.openings[i].eco);
                }
                else if (openingMode == 2 && opsi.openings[i].eco == openingECO) {
                    opsi.selOpenings.push(opsi.openings[i].moves);
                    //console.log("ECO opening", opsi.openings[i].eco);
                }
            }
            else {
                // Nothing
            }
        }
        //console.log("selected moves",opsi.selOpenings);
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
    //Next code marks the next move in the opening
    nextMoveinOpening = opsi.openingSelected.slice(_moveLength,_moveLength+4)
    if (nextMoveinOpening.length >3){
        hintToGRID(nextMoveinOpening)
        //console.log("Selected opening test", opsi.openingSelected)
    }
    else {
        //console.log("Opening played", opsi.openingPossible)
    }

}

// This function is used to set parameter openinop. It can be the next move in opening or Stockfish hint

function hintToGRID(fen) {
    //opsi.recentMove = hopo.test;
    //var _stringHelper = fen.slice(0,1);
    var _strHelp1 = fen.slice(0,1);
    var _strHelp2 = fen.slice(1,2);
    gridSolver(_strHelp1, _strHelp2);
    _strHelp1 = fen.slice(2,3);
    _strHelp2 = fen.slice(3,4);
    gridSolver(_strHelp1, _strHelp2);
}

function gridSolver(strH1, strH2) {

    //
    var openingInd

    var _feniHelper
    switch (strH1) {
    case "a": _feniHelper = 0
        break;
    case "b": _feniHelper = 1
        break;
    case "c": _feniHelper = 2
        break;
    case "d": _feniHelper = 3
        break;
    case "e": _feniHelper = 4
        break;
    case "f": _feniHelper = 5
        break;
    case "g": _feniHelper = 6
        break;
    case "h": _feniHelper = 7
        break;
    default: _feniHelper = 8  // This has to be outside limits and error
    }

    switch (strH2) {
    case "1": _feniHelper = _feniHelper+56
        break;
    case "2": _feniHelper = _feniHelper+48
        break;
    case "3": _feniHelper = _feniHelper+40
        break;
    case "4": _feniHelper = _feniHelper+32
        break;
    case "5": _feniHelper = _feniHelper+24
        break;
    case "6": _feniHelper = _feniHelper+16
        break;
    case "7": _feniHelper = _feniHelper+8
        break;
    case "8": _feniHelper = _feniHelper
        break;
    default: _feniHelper = 88 // This has to be outside limits and error

    }

    openingInd=_feniHelper;
    //console.log(openingInd)

    galeryModel.set(openingInd,{"openingop":100});
}

