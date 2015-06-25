// Function gridToFEN(), row 7
// Function fenToGRID(), row 65
// Function isChess(), row 169
// Function cancelMove(), row 204

/////////////////////////////////////////////////////////
// this function transforms grid notation to FEN-notation
/////////////////////////////////////////////////////////
function gridToFEN() {
    console.log("Valkoisen siirto, FEN ",fromIndex, toIndex)
    hopo.test = "";
    switch (fromIndex%8) {
    case 0: feni.startFeni= "a"
        break;
    case 1: feni.startFeni= "b"
        break;
    case 2: feni.startFeni= "c"
        break;
    case 3: feni.startFeni= "d"
        break;
    case 4: feni.startFeni= "e"
        break;
    case 5: feni.startFeni= "f"
        break;
    case 6: feni.startFeni= "g"
        break;
    case 7: feni.startFeni= "h"
        break;

    default: feni.startFeni = "m" //mistake
    }
    feni.stopFeni = 8-(fromIndex-fromIndex%8)/8;
    hopo.test = feni.startFeni+feni.stopFeni;

    switch (toIndex%8) {
    case 0: feni.startFeni= "a"
        break;
    case 1: feni.startFeni= "b"
        break;
    case 2: feni.startFeni= "c"
        break;
    case 3: feni.startFeni= "d"
        break;
    case 4: feni.startFeni= "e"
        break;
    case 5: feni.startFeni= "f"
        break;
    case 6: feni.startFeni= "g"
        break;
    case 7: feni.startFeni= "h"
        break;

    default: feni.startFeni = "m" //mistake
    }
    feni.stopFeni = 8-(toIndex-toIndex%8)/8;
    hopo.test = hopo.test+feni.startFeni+feni.stopFeni;
    feni.feniReady = true;

    console.log(hopo.test);

}

/////////////////////////////////////////////////////////
// this function transforms FEN notation to grid-notation
/////////////////////////////////////////////////////////

function fenToGRID() {
    console.log(hopo.test)
    feni.stringHelper = hopo.test.slice(0,1);
    switch (feni.stringHelper) {
    case "a": feni.feniHelper = 0
        break;
    case "b": feni.feniHelper = 1
        break;
    case "c": feni.feniHelper = 2
        break;
    case "d": feni.feniHelper = 3
        break;
    case "e": feni.feniHelper = 4
        break;
    case "f": feni.feniHelper = 5
        break;
    case "g": feni.feniHelper = 6
        break;
    case "h": feni.feniHelper = 7
        break;
    default: feni.feniHelper = 8
    }

//    console.log(feni.feniHelper)

    feni.stringHelper = hopo.test.slice(1,2);
    console.log(feni.stringHelper)
    switch (feni.stringHelper) {
    case "1": feni.feniHelper = feni.feniHelper+56
        break;
    case "2": feni.feniHelper = feni.feniHelper+48
        break;
    case "3": feni.feniHelper = feni.feniHelper+40
        break;
    case "4": feni.feniHelper = feni.feniHelper+32
        break;
    case "5": feni.feniHelper = feni.feniHelper+24
        break;
    case "6": feni.feniHelper = feni.feniHelper+16
        break;
    case "7": feni.feniHelper = feni.feniHelper+8
        break;
    case "8": feni.feniHelper = feni.feniHelper
        break;
    default: feni.feniHelper = 88

    }
    fromIndex=feni.feniHelper;
//    console.log(fromIndex)

    feni.stringHelper = hopo.test.slice(2,3);
    switch (feni.stringHelper) {
    case "a": feni.feniHelper = 0
        break;
    case "b": feni.feniHelper = 1
        break;
    case "c": feni.feniHelper = 2
        break;
    case "d": feni.feniHelper = 3
        break;
    case "e": feni.feniHelper = 4
        break;
    case "f": feni.feniHelper = 5
        break;
    case "g": feni.feniHelper = 6
        break;
    case "h": feni.feniHelper = 7
        break;
    default: feni.feniHelper = 8
    }

//    console.log(feni.feniHelper)

    feni.stringHelper = hopo.test.slice(3,4);
    console.log(feni.stringHelper)
    switch (feni.stringHelper) {
    case "1": feni.feniHelper = feni.feniHelper+56
        break;
    case "2": feni.feniHelper = feni.feniHelper+48
        break;
    case "3": feni.feniHelper = feni.feniHelper+40
        break;
    case "4": feni.feniHelper = feni.feniHelper+32
        break;
    case "5": feni.feniHelper = feni.feniHelper+24
        break;
    case "6": feni.feniHelper = feni.feniHelper+16
        break;
    case "7": feni.feniHelper = feni.feniHelper+8
        break;
    case "8": feni.feniHelper = feni.feniHelper
        break;
    default: feni.feniHelper = 88

    }
    toIndex=feni.feniHelper;
    console.log("mustan siirto ", fromIndex,toIndex)

}

///////////////////////////////////////////////////////////////////////////////////////
// Function checks if after move the Chess is still on. If so the movement is cancelled
///////////////////////////////////////////////////////////////////////////////////////

function isChess() {
    feni.feniWhiteChess = false;
    feni.feniBlackChess = false;
    feni.feniWkingInd = 60;
    feni.feniBkingInd = 4;
    feni.temptoIndex = toIndex;
    feni.tempfromIndex = fromIndex;

    for(feni.ax = 0; feni.ax < 64; feni.ax = feni.ax+1){
        //console.log(feni.ax);
        toIndex=feni.feniWkingInd;
        fromIndex = feni.ax;
        // ismovable


        // is legalmove


    }


    if (tilat.valko && feni.feniWhiteChess) {
        moveMent.moveLegal = false;
    }
    else if (tilat.musta && feni.feniBlackChess) {
        moveMent.moveLegal = true;
    }

    toIndex = feni.temptoIndex;
    fromIndex = feni.tempfromIndex;
    feni.chessIsOn = false; //// temporary
if (tilat.valko && !feni.chessIsOn){
    gridToFEN();
    vuoro.vaihdaMustalle();
}

}

///////////////////////////////////////////////////////////////////////
// Function cancels the move
////////////////////////////////////////////////////////////////

function cancelMove() {
    // Returning the moved piece to it's original position.
    galeryModel.set(movedPieces.get(0).indeksos,{"color":movedPieces.get(0).color, "piece":movedPieces.get(0).piece})
    console.log(movedPieces.get(0).indeksos,movedPieces.get(0).color, movedPieces.get(0).piece)
    // Returning the captured piece to it's original position
    galeryModel.set(movedPieces.get(1).indeksos,{"color":movedPieces.get(1).color, "piece":movedPieces.get(1).piece})
    console.log(movedPieces.get(1).indeksos,movedPieces.get(1).color, movedPieces.get(1).piece)
    moveStarted=false;
    moveMent.moveLegal=false;
    galeryModel.set(moveMent.wenpassant,{"color":"e"})
    moveMent.wenpassant = -1;

    // castling tai wenpassant (movelist.index 2)
//    feni.feniReady = false;
//    vuoro.vaihdaValkealle();

}
