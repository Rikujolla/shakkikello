// Function gridToFEN(), row 12
// Function fenToGRID(), row 70
// Function isChess(), row 174
// Function cancelMove(), row 218
// Function isChessPure(), row 286
// Function midSquareCheck(), row 342
// Function doMove(), row 402
// Function whiteinMate(), row 461
// Function startGame(), row 608
// Function pauseGame(), row 637
// Function continueGame(), row 648

/////////////////////////////////////////////////////////
// this function transforms grid notation to FEN-notation
/////////////////////////////////////////////////////////
function gridToFEN() {
    opsi.recentMove = hopo.test;
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
    if (moveMent.currentMove == "promotion") {hopo.test = hopo.test + promotedShort}

}

/////////////////////////////////////////////////////////
// this function transforms FEN notation to grid-notation
/////////////////////////////////////////////////////////

function fenToGRID() {
    opsi.recentMove = hopo.test;
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


    feni.stringHelper = hopo.test.slice(1,2);
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


    feni.stringHelper = hopo.test.slice(3,4);
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

}

///////////////////////////////////////////////////////////////////////////////////////
// Function checks if after move the Chess is still on. If so the movement is cancelled.
// That is done by testing all the opponent pieces with a trial to capture the king. If success the chess state is still on.
///////////////////////////////////////////////////////////////////////////////////////

function isChess() {
    feni.feniWhiteChess = false;
    feni.feniBlackChess = false;
    moveMent.chessTest = true;
    feni.temptoIndex = toIndex;
    feni.tempfromIndex = fromIndex;
    for(feni.ax = 0; feni.ax < 64; feni.ax = feni.ax+1){
        if (tilat.valko) {
            toIndex=feni.feniWkingInd;
        }
        else {
            toIndex=feni.feniBkingInd;
        }

        fromIndex = feni.ax;

        if (tilat.valko && galeryModel.get(feni.ax).color === "b"
                || tilat.musta && galeryModel.get(feni.ax).color === "w") {
            moveMent.canBemoved = true;  //palautettava falseksi joskus??
            moveMent.itemMoved=galeryModel.get(feni.ax).piece;
            moveMent.sameColor();
            moveMent.isLegalmove();
            if (moveMent.moveLegal){
                feni.chessIsOn = true; //
            }
        }


    }

    toIndex = feni.temptoIndex;
    fromIndex = feni.tempfromIndex;
    moveMent.chessTest = false;
    feni.chessTestDone = true;
}

///////////////////////////////////////////////////////////////////////
// Function cancels the move
////////////////////////////////////////////////////////////////

function cancelMove() {
    // Enabling the grid for white inputs
    if (tilat.valko) {feni.feniWhite = true;}
    // Returning the moved piece to it's original position.
    galeryModel.set(movedPieces.get(0).indeksos,{"color":movedPieces.get(0).color, "piece":movedPieces.get(0).piece})
    // Returning the captured piece to it's original position
    galeryModel.set(movedPieces.get(1).indeksos,{"color":movedPieces.get(1).color, "piece":movedPieces.get(1).piece})
    moveStarted=false;
    moveMent.moveLegal=false;
    if (tilat.valko && moveMent.wenpassant > -1){
        galeryModel.set(moveMent.wenpassant,{"color":"e"})
        moveMent.wenpassant = -1;
    }
    if (tilat.musta && moveMent.benpassant > -1){
        galeryModel.set(moveMent.benpassant,{"color":"e"})
        moveMent.benpassant = -1;
    }
    feni.chessIsOn = false;

    // king index backing
    if (movedPieces.get(0).piece === "images/K.png"){
        feni.feniWkingInd = movedPieces.get(0).indeksos;
    }
    if (movedPieces.get(0).piece === "images/k.png"){
        feni.feniBkingInd = movedPieces.get(0).indeksos;
    }

    // Backing rook in castling
    if (moveMent.currentMove == "castling") {
        // Setting rook bck
        galeryModel.set(movedPieces.get(2).indeksos,{"color":movedPieces.get(2).color, "piece":movedPieces.get(2).piece})
        //Setting empty back
        galeryModel.set(movedPieces.get(3).indeksos,{"color":movedPieces.get(3).color, "piece":movedPieces.get(3).piece})
        if (tilat.valko) {
            moveMent.castlingWpossible = true;
        }
        else {
            moveMent.castlingBpossible = true;
        }

    }
    // Backing queen to pawn in promotion
    if (moveMent.currentMove == "promotion") {
        galeryModel.set(movedPieces.get(2).indeksos,{"color":movedPieces.get(2).color, "piece":movedPieces.get(2).piece})
    }
    // Backing queen to pawn in enpassant
    if (moveMent.currentMove == "enpassant") {
        galeryModel.set(movedPieces.get(2).indeksos,{"color":movedPieces.get(2).color, "piece":movedPieces.get(2).piece})
    }

    moveMent.midSquareCheckki = false;
    moveMent.currentMove = "";

    // castling or wenpassant doesnt work yet (movelist.index 2)
    //also  promotion to queen may not be cancelled

}

///////////////////////////////////////////////////////////////////////////////////////
// Function checks if Chess is  on. Used for notifications and castling checks
///////////////////////////////////////////////////////////////////////////////////////

function isChessPure() {
    feni.feniWhiteChess = false;
    feni.feniBlackChess = false;
    moveMent.chessTest = true;
    feni.temptoIndex = toIndex;
    feni.tempfromIndex = fromIndex;
    for(feni.ax = 0; feni.ax < 64; feni.ax = feni.ax+1){
        if (tilat.valko) {
            toIndex=feni.feniWkingInd;
        }
        else {
            toIndex=feni.feniBkingInd;
        }

        fromIndex = feni.ax;

        if (tilat.valko && galeryModel.get(feni.ax).color === "b") {
            moveMent.canBemoved = true;  //
            moveMent.itemMoved=galeryModel.get(feni.ax).piece;
            moveMent.sameColor();
            moveMent.isLegalmove();
            if (moveMent.moveLegal){
                feni.feniWhiteChess = true;
                if (isMyStart) {
                    feni.lowerMessage = feni.messages[0].msg;
                }
                else {
                    feni.upperMessage = feni.messages[0].msg;
                }
            }
        }

        else if (tilat.musta && galeryModel.get(feni.ax).color === "w") {
            moveMent.canBemoved = true;  //To enable the tests
            moveMent.itemMoved=galeryModel.get(feni.ax).piece;
            moveMent.sameColor();
            moveMent.isLegalmove();
            if (moveMent.moveLegal){
                feni.feniBlackChess = true;
                if (isMyStart) {
                    feni.upperMessage = feni.messages[0].msg;
                }
                else {
                    feni.lowerMessage = feni.messages[0].msg;
                }
            }

        }
    }

    toIndex = feni.temptoIndex;
    fromIndex = feni.tempfromIndex;
    // Resetting values to defaults after checks
    moveMent.canBemoved = false;
    moveMent.moveLegal = false;
    moveMent.chessTest = false;

}

///////////////////////////////////////////////////////////////////////////////////////
// Function checks if the king tries to jump over the checked square in castling.
// If so the move will be cancelled.
///////////////////////////////////////////////////////////////////////////////////////

function midSquareCheck() {
    moveMent.chessTest = true;
    feni.temptoIndex = toIndex;
    feni.tempfromIndex = fromIndex;
    for(feni.ax = 0; feni.ax < 64; feni.ax = feni.ax+1){
        toIndex = moveMent.midSquareInd;

        fromIndex = feni.ax;

        if (tilat.valko && galeryModel.get(feni.ax).color === "b") {
            moveMent.canBemoved = true;  //
            moveMent.itemMoved=galeryModel.get(feni.ax).piece;
            moveMent.sameColor();
            moveMent.isLegalmove();
            if (moveMent.moveLegal){
                moveMent.midSquareCheckki = true;
            }
        }

        else if (tilat.musta && galeryModel.get(feni.ax).color === "w") {
            moveMent.canBemoved = true;  //To enable the tests
            moveMent.itemMoved=galeryModel.get(feni.ax).piece;
            moveMent.sameColor();
            moveMent.isLegalmove();
            if (moveMent.moveLegal){
                moveMent.midSquareCheckki = true;
            }
        }
    }

    toIndex = feni.temptoIndex;
    fromIndex = feni.tempfromIndex;
    // Resetting values to defaults after checks
    moveMent.canBemoved = false;
    moveMent.moveLegal = false;
    moveMent.chessTest = false;
    feni.midSquareTestDone = true;
}

///////////////////////////////////////////////////////////////////////////////////////
// Function does the move
///////////////////////////////////////////////////////////////////////////////////////

function doMove() {

    if (tilat.valko && !feni.chessIsOn){
        if (isMyStart) {
            feni.lowerMessage = "";
        }
        else {
            feni.upperMessage = "";
        }

        gridToFEN();
        if (moveMent.currentMove == "enpassant") {blackCaptured.append({"captured":"images/p.png"})}
        if (movedPieces.get(1).piece !== "images/empty.png") {
            blackCaptured.append({"captured":movedPieces.get(1).piece})
        }
        moveMent.currentMove = "";
        if (movedPieces.get(0).piece === "images/K.png") {moveMent.wKingMoved = true;}
        moveMent.midSquareCheckki = false;
        Mytab.addMove();
        if (playMode == "othDevice") {
            conTcpSrv.smove = hopo.test;
            conTcpCli.requestNewFortune();
            conTcpSrv.waitmove = conTcpCli.cmove;
        }
        vuoro.vaihdaMustalle();
    }

    else if (tilat.musta && !feni.chessIsOn) {
        if (isMyStart) {
            feni.upperMessage = "";
        }
        else {
            feni.lowerMessage = "";
        }

        gridToFEN();
        if (moveMent.currentMove == "enpassant") {whiteCaptured.append({"captured":"images/P.png"})}
        if (movedPieces.get(1).piece !== "images/empty.png") {
            whiteCaptured.append({"captured":movedPieces.get(1).piece})
        }
        moveMent.currentMove = "";
        if (movedPieces.get(0).piece === "images/k.png") {moveMent.bKingMoved = true;}
        moveMent.midSquareCheckki = false;
        Mytab.addMove();
        if (playMode == "othDevice") {
            conTcpSrv.smove = hopo.test;
            conTcpCli.requestNewFortune();
            conTcpSrv.waitmove = conTcpCli.cmove;
        }
        vuoro.vaihdaValkealle();
    }

    isChessPure();
    opsi.recentMove = hopo.test; //only effective for stockfish game
    movesDone = movesDone + opsi.recentMove;  // Maybe needed in future
    opsi.movesTotal++;
    if (openingMode == 1 || openingMode == 2 || openingMode == 3) {
        Myops.inOpenings();
    }
    // Recording the move to the allMoves list
    allMoves.append({"moveNo":opsi.movesTotal, "movedColor":movedPieces.get(0).color, "movedPiece":movedPieces.get(0).piece, "movedFrom":movedPieces.get(0).indeksos})
    allMoves.set(opsi.movesTotal, {"capturedColor":movedPieces.get(1).color, "capturedPiece":movedPieces.get(1).piece, "capturedTo":movedPieces.get(1).indeksos})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).movedColor, allMoves.get(opsi.movesTotal).movedPiece, allMoves.get(opsi.movesTotal).movedFrom)
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).capturedColor, allMoves.get(opsi.movesTotal).capturedPiece, allMoves.get(opsi.movesTotal).capturedTo)
    allMoves.set(opsi.movesTotal, {"pairColor":movedPieces.get(2).color, "pairPiece":movedPieces.get(2).piece, "pairFrom":movedPieces.get(2).indeksos})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).pairColor, allMoves.get(opsi.movesTotal).pairPiece, allMoves.get(opsi.movesTotal).pairFrom)
    allMoves.set(opsi.movesTotal, {"pairCapturesColor":movedPieces.get(3).color, "pairCaptures":movedPieces.get(3).piece, "pairTo":movedPieces.get(3).indeksos})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).pairCapturesColor, allMoves.get(opsi.movesTotal).pairCaptures, allMoves.get(opsi.movesTotal).pairTo)
    allMoves.set(opsi.movesTotal, {"enpColor":movedPieces.get(4).color, "enpPiece":movedPieces.get(4).piece, "enpInd":movedPieces.get(4).indeksos})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).enpColor, allMoves.get(opsi.movesTotal).enpPiece, allMoves.get(opsi.movesTotal).enpInd)
    //console.log(whiteTimeAccum0_temp, blackTimeAccum0_temp)
    allMoves.set(opsi.movesTotal, {"whiteTimeMove":whiteTimeAccum0_temp, "blackTimeMove":blackTimeAccum0_temp})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).whiteTimeMove, allMoves.get(opsi.movesTotal).blackTimeMove)
    allMoves.set(opsi.movesTotal, {"whiteCapturedCount":whiteCaptured.count, "blackCapturedCount":blackCaptured.count})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).whiteCapturedCount, allMoves.get(opsi.movesTotal).blackCapturedCount)
    movesNoScanned = opsi.movesTotal;
}

///////////////////////////////////////////////////////
// Function checks if white is in mate condition
////////////////////////////////////////////

function iswhiteInMate() {
    //console.log(opsi.movesTotal)
    for(var i = 0; i < 64; i++){
        whiteInMate = true;
    }
    if (whiteInMate) {
        //console.log("White is in mate")
    }
    else {
        //console.log("White is not in mate")
    }
}

// Function checks if piece is movable

function isMovableB() {
    if (colorTobemoved == "b" && tilat.musta) {
        canBemoved = true;
        galeryModel.set(fromIndex,{"frameop":100});
    }
    else if (colorTobemoved == "w" && tilat.valko) {
        canBemoved = true;
        galeryModel.set(fromIndex,{"frameop":100});
    }
    else {
        canBemoved = false;
    }
}



function isLegalmoveB() {

}

function othDeviceMoveBlack() {
    fenToGRID()
    blackTimeAccum0 = conTcpCli.ctime;
    blackTimeTotal = blackTimeAccum0;
    blackTimeAccum = 0;
    // Saving moves for captured pieces //Possible BUG in fast play in next line, could be related to narrow timeslot where you can select piece on opponents turn. Have to follow
    movedPieces.set(0,{"color":galeryModel.get(fromIndex).color, "piece":galeryModel.get(fromIndex).piece, "indeksos":fromIndex}) //Piece moved
    movedPieces.set(1,{"color":galeryModel.get(toIndex).color, "piece":galeryModel.get(toIndex).piece, "indeksos":toIndex}) //Piece captured

    galeryModel.set(toIndex,{"color":galeryModel.get(fromIndex).color, "piece":galeryModel.get(fromIndex).piece})
    galeryModel.set(fromIndex,{"color":"e", "piece":"images/empty.png"})
    // If castling, moving the rook also
    if (Math.abs(toIndex-fromIndex)==2 && galeryModel.get(toIndex).piece === "images/k.png") {
        if (toIndex == 6){
            galeryModel.set(5,{"color":"b", "piece":"images/r.png"})
            galeryModel.set(7,{"color":"e", "piece":"images/empty.png"})
        }
        else {
            galeryModel.set(3,{"color":"b", "piece":"images/r.png"})
            galeryModel.set(0,{"color":"e", "piece":"images/empty.png"})
        }
    }
    // If blacks move gives enpassant possibility to whiteTimer
    if (((fromIndex-toIndex) == -16) && galeryModel.get(toIndex).piece === "images/p.png") {
        moveMent.benpassant = toIndex-8;
        galeryModel.set(moveMent.benpassant,{"color":"bp"})
    }
    // If white gives enpassant possibility and it is utilized let's print a board accordingly
    if (toIndex != -1 && toIndex == moveMent.wenpassant && galeryModel.get(toIndex).piece === "images/p.png") {
        galeryModel.set((toIndex-8),{"color":"e", "piece":"images/empty.png"});
        moveMent.currentMove = "enpassant";
        moveMent.wenpassant = -1;
    }
    // Adding moves to captures list
    if (moveMent.currentMove == "enpassant") {
        whiteCaptured.append({"captured":"images/P.png"});
        moveMent.currentMove = "";
    }
    if (movedPieces.get(1).piece !== "images/empty.png") {
        whiteCaptured.append({"captured":movedPieces.get(1).piece})
    }

    // If pawn reaches the last line let's guess the promotion to be a queen. Have to correct in future some how

    if (toIndex > 55 && galeryModel.get(toIndex).piece === "images/p.png") {
        galeryModel.set(toIndex, {"piece": "images/q.png"});
    }
    feni.lowerMessage = "";
    feni.upperMessage = "";
    Mytab.addMove();
    vuoro.vaihdaValkealle();
    isChessPure();
    movesDone = movesDone + opsi.recentMove; // Adding the move for openings comparison
    opsi.movesTotal++;
    galeryModel.set(fromIndex,{"recmove":opsi.movesTotal});
    galeryModel.set(toIndex,{"recmove":opsi.movesTotal});
    feni.feniBlackReady2 = false;
    // Recording move to the allMoves list
    allMoves.append({"moveNo":opsi.movesTotal})

    whiteMatetimer.start();

}

function othDeviceMoveWhite() {
    Myfunks.fenToGRID()
    whiteTimeAccum0 = conTcpCli.ctime;
    whiteTimeTotal = whiteTimeAccum0;
    whiteTimeAccum = 0;
    // Saving moves for captured pieces
    movedPieces.set(0,{"color":galeryModel.get(fromIndex).color, "piece":galeryModel.get(fromIndex).piece, "indeksos":fromIndex}) //Piece moved
    movedPieces.set(1,{"color":galeryModel.get(toIndex).color, "piece":galeryModel.get(toIndex).piece, "indeksos":toIndex}) //Piece captured

    galeryModel.set(toIndex,{"color":galeryModel.get(fromIndex).color, "piece":galeryModel.get(fromIndex).piece})
    galeryModel.set(fromIndex,{"color":"e", "piece":"images/empty.png"})
    // If castling, moving the rook also
    if (Math.abs(toIndex-fromIndex)==2 && galeryModel.get(toIndex).piece === "images/K.png") {
        if (toIndex == 62){
            galeryModel.set(61,{"color":"w", "piece":"images/R.png"})
            galeryModel.set(63,{"color":"e", "piece":"images/empty.png"})
        }
        else {
            galeryModel.set(59,{"color":"w", "piece":"images/R.png"})
            galeryModel.set(56,{"color":"e", "piece":"images/empty.png"})
        }
    }
    // If whites move gives enpassant possibility to whiteTimer
    if (((fromIndex-toIndex) == 16) && galeryModel.get(toIndex).piece === "images/P.png") {
        moveMent.wenpassant = toIndex+8
        galeryModel.set(moveMent.wenpassant,{"color":"wp"})
    }
    // If black gives enpassant possibility and it is utilized let's print a board accordingly
    if (toIndex != -1 && toIndex == moveMent.benpassant && galeryModel.get(toIndex).piece === "images/P.png") {
        galeryModel.set((toIndex+8),{"color":"e", "piece":"images/empty.png"});
        moveMent.currentMove = "enpassant";
        moveMent.benpassant = -1;
    }
    // Adding moves to captures list
    if (moveMent.currentMove == "enpassant") {
        blackCaptured.append({"captured":"images/p.png"});
        moveMent.currentMove = "";
    }
    if (movedPieces.get(1).piece !== "images/empty.png") {
        blackCaptured.append({"captured":movedPieces.get(1).piece})
    }

    // If pawn reaches the last line let's gues the promotion to be a queen. Have to correct in future some how

    if (toIndex < 8 && galeryModel.get(toIndex).piece === "images/P.png") {
        galeryModel.set(toIndex, {"piece": "images/Q.png"});
    }
    feni.lowerMessage = "";
    feni.upperMessage = "";
    Mytab.addMove();
    vuoro.vaihdaMustalle();
    Myfunks.isChessPure();
    movesDone = movesDone + opsi.recentMove; // Adding the move for openings comparison
    opsi.movesTotal++;
    galeryModel.set(fromIndex,{"recmove":opsi.movesTotal});
    galeryModel.set(toIndex,{"recmove":opsi.movesTotal});
    feni.feniWhiteReady2 = false;
    // Recording move to the allMoves list
    allMoves.append({"moveNo":opsi.movesTotal})


}

function startGame () {
    hopo.stoDepth = stockfishDepth;
    hopo.stoMovetime = stockfishMovetime;
    hopo.stoSkill = stockfishSkill;
    if (!tilat.pelialkoi) {
        if (playMode == "stockfish") {hopo.initio();}
        //kripti.lisaa();
        if (isMyStart) {
            feni.stockfishFirstmove = false
            feni.feniWhiteReady = false
            feni.feniWhite = true
        }
        else {
            feni.stockfishFirstmove = true
            feni.feniWhiteReady = true
            feni.feniWhite = false
        }
    }
    tilat.aloitaPeli();
    tilat.juoksee = !tilat.juoksee;
    startti.timeAsetus();
    tilat.vaihdaTila();
    maharollisuuret = qsTr("Reset");
    conTcpSrv.waitmove = "";
    conTcpCli.cmove = "";
    conTcpSrv.smove = "";

}

function pauseGame () {
    tilat.juoksee = !tilat.juoksee;
    startti.timeAsetus();
    tilat.vaihdaTila();
    maharollisuuret = qsTr("Reset");
    /*conTcpSrv.waitmove = "";
    conTcpCli.cmove = "";
    conTcpSrv.smove = "";*/

}

function continueGame () {
    var limit = allMoves.count-1;
    for (var i=limit; i>movesNoScanned; i--){
        allMoves.remove(i)
    }
    // Removing extra captured whites
    limit = whiteCaptured.count-1
    for (i=limit;i > allMoves.get(movesNoScanned).whiteCapturedCount-1;i--) {
        whiteCaptured.remove(i)
    }
    // Removing extra captured blacks
    limit = blackCaptured.count-1
    for (i=limit;i > allMoves.get(movesNoScanned).blackCapturedCount-1;i--) {
        blackCaptured.remove(i)
    }

    opsi.movesTotal =movesNoScanned; //Setting new maximum movecount

    pauseMillsecs = pauseMillsecs + pureMillsecs
    tilat.juoksee = !tilat.juoksee;
    startti.timeAsetus();
    tilat.vaihdaTila();
    maharollisuuret = qsTr("Reset");
    /*conTcpSrv.waitmove = "";
    conTcpCli.cmove = "";
    conTcpSrv.smove = "";*/

}
    /////////////////////////////
    // This is modified from the function cancelMove, in future maybe evaluating if the same function can be used for backing and canceling
    /////////////////////////////

function moveBack() {

    // Returning the moved piece to it's previous position.
    galeryModel.set(allMoves.get(movesNoScanned).movedFrom,{"color":allMoves.get(movesNoScanned).movedColor, "piece":allMoves.get(movesNoScanned).movedPiece})

    // Returning the captured piece to it's original position
    galeryModel.set(allMoves.get(movesNoScanned).capturedTo,{"color":allMoves.get(movesNoScanned).capturedColor, "piece":allMoves.get(movesNoScanned).capturedPiece})

    // Visual adjustments and enpassant fix
    for (var i=0;i<64; i++){
        galeryModel.set(i,{"frameop": 0, "recmove":-1}); // Removing last move squares
        if (galeryModel.get(i).color ==="wp" || galeryModel.get(i).color ==="bp"){
            galeryModel.set(i,{"color":"e", "piece":"images/empty.png"}); // Make enpassant possibilities empty, later fill values for last move
        }
    }

    // Returning the captured piece in enpassant and the moved rook in the castling
    if (allMoves.get(movesNoScanned).pairColor !== "x" && allMoves.get(movesNoScanned).pairFrom > 0){
        galeryModel.set(allMoves.get(movesNoScanned).pairFrom,{"color":allMoves.get(movesNoScanned).pairColor, "piece":allMoves.get(movesNoScanned).pairPiece})
    }

    // Returning the empty piece in the castling to the place the rook visited
    if (allMoves.get(movesNoScanned).pairCapturesColor !== "x" && allMoves.get(movesNoScanned).pairTo > 0){
        galeryModel.set(allMoves.get(movesNoScanned).pairTo,{"color":allMoves.get(movesNoScanned).pairCapturesColor, "piece":allMoves.get(movesNoScanned).pairCaptures})
    }

    // REturning time values
    if (allMoves.get(movesNoScanned).movedColor === "w"){
        if (movesNoScanned === opsi.movesTotal){ // First move has to be reduced separate way
            pureMillsecs = 0;
            pauseMillsecs = 0;
            blackTimeTotal = blackTimeAccum0
            blackTimeAccum = 0;
            var label_sec_b = (mustamax*1000 - (blackTimeTotal-blackTimeTotal%1000))/1000%60;
            var label_min_b = (mustamax*1000 - (blackTimeTotal-blackTimeTotal%1000)-label_sec_b*1000)/60000;
            label_time_b = label_min_b + ":" + (label_sec_b < 10 ? "0" : "") + label_sec_b
        }
        whiteTimeAccum = 0;
        whiteTimeAccum0_temp = allMoves.get(movesNoScanned).whiteTimeMove;
        whiteTimeAccum0 = allMoves.get(movesNoScanned).whiteTimeMove;
        whiteTimeTotal = allMoves.get(movesNoScanned).whiteTimeMove;
        var label_sec_w = (valkomax*1000 - (whiteTimeTotal-whiteTimeTotal%1000))/1000%60;
        var label_min_w = (valkomax*1000 - (whiteTimeTotal-whiteTimeTotal%1000)-label_sec_w*1000)/60000;
        label_time_w = label_min_w + ":" + (label_sec_w < 10 ? "0" : "") + label_sec_w

    }
    else {
        if (movesNoScanned === opsi.movesTotal){ // First move has to be reduced separate way
            pureMillsecs = 0;
            pauseMillsecs = 0;
            whiteTimeTotal = whiteTimeAccum0
            whiteTimeAccum = 0;
            label_sec_w = (valkomax*1000 - (whiteTimeTotal-whiteTimeTotal%1000))/1000%60;
            label_min_w = (valkomax*1000 - (whiteTimeTotal-whiteTimeTotal%1000)-label_sec_w*1000)/60000;
            label_time_w = label_min_w + ":" + (label_sec_w < 10 ? "0" : "") + label_sec_w
        }
        blackTimeAccum = 0;
        blackTimeAccum0_temp = allMoves.get(movesNoScanned).blackTimeMove;
        blackTimeAccum0 = allMoves.get(movesNoScanned).blackTimeMove;
        blackTimeTotal = allMoves.get(movesNoScanned).blackTimeMove;
        label_sec_b = (mustamax*1000 - (blackTimeTotal-blackTimeTotal%1000))/1000%60;
        label_min_b = (mustamax*1000 - (blackTimeTotal-blackTimeTotal%1000)-label_sec_b*1000)/60000;
        label_time_b = label_min_b + ":" + (label_sec_b < 10 ? "0" : "") + label_sec_b
    }

    //feni.chessIsOn = false;// is this needed
    //moveMent.midSquareCheckki = false;// is this needed
    //moveMent.currentMove = "";// is this needed

    movesNoScanned--; //
    // Setting previous move values for enpassant to enable the enpassant move
    if (allMoves.get(movesNoScanned).enpColor !== "e" && allMoves.get(movesNoScanned).enpInd > 0){
        galeryModel.set(allMoves.get(movesNoScanned).enpInd,{"color":allMoves.get(movesNoScanned).enpColor, "piece":allMoves.get(movesNoScanned).enpPiece})
    }

    if (allMoves.get(movesNoScanned).movedColor === "w")
    {
        feni.feniWhite = false;
        feni.feniBlack = true;
        tilat.valko=false;
        tilat.musta=true;
    }
    else {
        feni.feniWhite = true;
        feni.feniBlack = false;
        tilat.valko=true;
        tilat.musta=false;
    }
}

