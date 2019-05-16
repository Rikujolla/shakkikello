// Function gridToFEN(), row 12
// Function fenToGRID(), row 70
// Function isChess(), row 174
// Function cancelMove(), row 218
// Function isChessPure(), row 286
// Function midSquareCheck(), row 342
// Function doMove(), row 402
// Function whiteinMate(), row 454
// Function startGame(), row 608
// Function pauseGame(), row 637
// Function continueGame(), row 648

/////////////////////////////////////////////////////////
// this function transforms grid notation to FEN-notation
/////////////////////////////////////////////////////////
function gridToFEN(fromInd, toInd) {
    opsi.recentMove = hopo.test;
    hopo.test = "";
    var startFeni = "";
    var stopFeni = "";
    switch (fromInd%8) {
    case 0: startFeni= "a"
        break;
    case 1: startFeni= "b"
        break;
    case 2: startFeni= "c"
        break;
    case 3: startFeni= "d"
        break;
    case 4: startFeni= "e"
        break;
    case 5: startFeni= "f"
        break;
    case 6: startFeni= "g"
        break;
    case 7: startFeni= "h"
        break;

    default: startFeni = "m" //mistake
    }
    stopFeni = 8-(fromInd-fromInd%8)/8;
    hopo.test = startFeni+stopFeni;

    switch (toInd%8) {
    case 0: startFeni= "a"
        break;
    case 1: startFeni= "b"
        break;
    case 2: startFeni= "c"
        break;
    case 3: startFeni= "d"
        break;
    case 4: startFeni= "e"
        break;
    case 5: startFeni= "f"
        break;
    case 6: startFeni= "g"
        break;
    case 7: startFeni= "h"
        break;

    default: startFeni = "m" //mistake
    }
    stopFeni = 8-(toInd-toInd%8)/8;
    hopo.test = hopo.test+startFeni+stopFeni;
    if (currentMove == "promotion") {hopo.test = hopo.test + promotedShort}

}

/////////////////////////////////////////////////////////
// this function transforms FEN notation to grid-notation
/////////////////////////////////////////////////////////

function fenToGRID() {
    opsi.recentMove = hopo.test;
    var stringHelper = hopo.test.slice(0,1);
    switch (stringHelper) {
    case "a": feniHelper = 0
        break;
    case "b": feniHelper = 1
        break;
    case "c": feniHelper = 2
        break;
    case "d": feniHelper = 3
        break;
    case "e": feniHelper = 4
        break;
    case "f": feniHelper = 5
        break;
    case "g": feniHelper = 6
        break;
    case "h": feniHelper = 7
        break;
    default: feniHelper = 8
    }


    stringHelper = hopo.test.slice(1,2);
    switch (stringHelper) {
    case "1": feniHelper = feniHelper+56
        break;
    case "2": feniHelper = feniHelper+48
        break;
    case "3": feniHelper = feniHelper+40
        break;
    case "4": feniHelper = feniHelper+32
        break;
    case "5": feniHelper = feniHelper+24
        break;
    case "6": feniHelper = feniHelper+16
        break;
    case "7": feniHelper = feniHelper+8
        break;
    case "8": feniHelper = feniHelper
        break;
    default: feniHelper = 88

    }
    fromIndex=feniHelper;

    stringHelper = hopo.test.slice(2,3);
    switch (stringHelper) {
    case "a": feniHelper = 0
        break;
    case "b": feniHelper = 1
        break;
    case "c": feniHelper = 2
        break;
    case "d": feniHelper = 3
        break;
    case "e": feniHelper = 4
        break;
    case "f": feniHelper = 5
        break;
    case "g": feniHelper = 6
        break;
    case "h": feniHelper = 7
        break;
    default: feniHelper = 8
    }


    stringHelper = hopo.test.slice(3,4);
    switch (stringHelper) {
    case "1": feniHelper = feniHelper+56
        break;
    case "2": feniHelper = feniHelper+48
        break;
    case "3": feniHelper = feniHelper+40
        break;
    case "4": feniHelper = feniHelper+32
        break;
    case "5": feniHelper = feniHelper+24
        break;
    case "6": feniHelper = feniHelper+16
        break;
    case "7": feniHelper = feniHelper+8
        break;
    case "8": feniHelper = feniHelper
        break;
    default: feniHelper = 88

    }
    toIndex=feniHelper;

}

///////////////////////////////////////////////////////////////////////////////////////
// Function checks if after move the Chess is still on. If so the movement is cancelled.
// That is done by testing all the opponent pieces with a trial to capture the king. If success the chess state is still on.
///////////////////////////////////////////////////////////////////////////////////////
function isChess_new(_i_trial_move, _j_trial_move) {
    var _chessIsStillOn = false;
    var doVisual = false;
    var _piece0 = galeryModel.get(_i_trial_move).piece
    var _color0 = galeryModel.get(_i_trial_move).color
    var _index0 = galeryModel.get(_i_trial_move).indeksos
    for(var i = 0; i < 64; i = i+1){ // i is virtual fromIndex
        if (tilat.valko) {
            if (_i_trial_move === feniWkingInd) {
                var j = _j_trial_move; // If king was moved, lets move king position accordingly for the test
                var _piece = galeryModel.get(i).piece
                var _color = galeryModel.get(i).color
            }
            else {
                j = feniWkingInd; // j is a virtual toIndex of a white king
                _piece = galeryModel.get(i).piece
                _color = galeryModel.get(i).color
            }
        }
        else { // need to modify like above for white
            j = feniBkingInd;
            _piece = galeryModel.get(i).piece
            _color = galeryModel.get(i).color
        }

        if (tilat.valko && _color === "b"
                || tilat.musta && _color === "w") {
            if (Mymove.isLegalmove(doVisual, i, j, _piece, test_state)){ //talle pitaisi antaa muuttunut pelilauta, jotta osaa laskea oikein
                _chessIsStillOn = true; //
            }
        }
    }
    return _chessIsStillOn;
    //chessTestDone = true;
}


function isChess(_i_trial_move, _j_trial_move) {
    var doVisual = false;
    feniWhiteChess = false; // Check if this can be removed
    feniBlackChess = false; // Check if this can be removed
    //var _piece0 = galeryModel.get(_i_trial_move).piece
    //var _color0 = galeryModel.get(_i_trial_move).color
    for(var i = 0; i < 64; i = i+1){ // i is virtual fromIndex
        if (tilat.valko) {
            if (_i_trial_move === feniWkingInd) {
                var j = _j_trial_move; // If king was moved, lets move king position accordingly for the test
                var _piece = galeryModel.get(i).piece
                var _color = galeryModel.get(i).color
            }
            else {
                j = feniWkingInd; // j is a virtual toIndex of a white king
                _piece = galeryModel.get(i).piece
                _color = galeryModel.get(i).color
            }
        }
        else { // need to modify like above for white
            j = feniBkingInd;
            _piece = galeryModel.get(i).piece
            _color = galeryModel.get(i).color
        }

        if (tilat.valko && _color === "b"
                || tilat.musta && _color === "w") {
            if (Mymove.isLegalmove(doVisual, i, j, _piece, test_state)){
                chessIsOn = true; //
            }
        }
    }

    chessTestDone = true;
}

///////////////////////////////////////////////////////////////////////
// Function cancels the move
////////////////////////////////////////////////////////////////

function cancelMove() {
    // Enabling the grid for white inputs
    if (tilat.valko) {feniWhite = true;}
    // Returning the moved piece to it's original position.
    galeryModel.set(movedPieces.get(0).indeksos,{"color":movedPieces.get(0).color, "piece":movedPieces.get(0).piece})
    // Returning the captured piece to it's original position
    galeryModel.set(movedPieces.get(1).indeksos,{"color":movedPieces.get(1).color, "piece":movedPieces.get(1).piece})
    moveStarted=false;
    moveLegal=false;
    if (tilat.valko && wenpassant > -1){
        galeryModel.set(wenpassant,{"color":"e"})
        wenpassant = -1;
    }
    if (tilat.musta && benpassant > -1){
        galeryModel.set(benpassant,{"color":"e"})
        benpassant = -1;
    }
    chessIsOn = false;

    // king index backing
    if (movedPieces.get(0).piece === piePat + "K.png"){
        feniWkingInd = movedPieces.get(0).indeksos;
    }
    if (movedPieces.get(0).piece === piePat + "k.png"){
        feniBkingInd = movedPieces.get(0).indeksos;
    }

    // Backing rook in castling
    if (currentMove == "castling") {
        // Setting rook bck
        galeryModel.set(movedPieces.get(2).indeksos,{"color":movedPieces.get(2).color, "piece":movedPieces.get(2).piece})
        //Setting empty back
        galeryModel.set(movedPieces.get(3).indeksos,{"color":movedPieces.get(3).color, "piece":movedPieces.get(3).piece})
        if (tilat.valko) {
            castlingWpossible = true;
        }
        else {
            castlingBpossible = true;
        }

    }
    // Backing queen to pawn in promotion
    if (currentMove == "promotion") {
        galeryModel.set(movedPieces.get(2).indeksos,{"color":movedPieces.get(2).color, "piece":movedPieces.get(2).piece})
    }
    // Backing queen to pawn in enpassant
    if (currentMove == "enpassant") {
        galeryModel.set(movedPieces.get(2).indeksos,{"color":movedPieces.get(2).color, "piece":movedPieces.get(2).piece})
    }

    midSquareCheckki = false;
    currentMove = "";

    // castling or wenpassant doesnt work yet (movelist.index 2)
    //also  promotion to queen may not be cancelled

}

///////////////////////////////////////////////////////////////////////////////////////
// Function checks if Chess is  on. Used for notifications and castling checks
///////////////////////////////////////////////////////////////////////////////////////

function isChessPure() {
    var doVisual = false;
    feniWhiteChess = false;
    feniBlackChess = false;
    for(var i = 0; i < 64; i = i+1){
        if (tilat.valko) {
            var j = feniWkingInd;
        }
        else {
            j = feniBkingInd;
        }

        if (tilat.valko && galeryModel.get(i).color === "b") {
            if (Mymove.isLegalmove(doVisual, i, j, galeryModel.get(i).piece, test_state)){
                feniWhiteChess = true;
                if (isMyStart) {
                    lowerMessage = messages[0].msg;
                }
                else {
                    upperMessage = messages[0].msg;
                }
            }
        }

        else if (tilat.musta && galeryModel.get(i).color === "w") {
            if (Mymove.isLegalmove(doVisual, i, j, galeryModel.get(i).piece, test_state)){
                feniBlackChess = true;
                if (isMyStart) {
                    upperMessage = messages[0].msg;
                }
                else {
                    lowerMessage = messages[0].msg;
                }
            }

        }
    }


}

///////////////////////////////////////////////////////////////////////////////////////
// Function checks if the king tries to jump over the checked square in castling.
// If so the move will be cancelled.
///////////////////////////////////////////////////////////////////////////////////////

function midSquareCheck() {
    var doVisual = false;
    for(var i = 0; i < 64; i = i+1){
        var j = midSquareInd; // Virtual toIndex

        if (tilat.valko && galeryModel.get(i).color === "b") {
            if (Mymove.isLegalmove(doVisual, i, j, galeryModel.get(i).piece, test_state)){
                midSquareCheckki = true;
            }
        }

        else if (tilat.musta && galeryModel.get(i).color === "w") {
            if (Mymove.isLegalmove(doVisual, i, j, galeryModel.get(i).piece, test_state)){
                midSquareCheckki = true;
            }
        }
    }

    midSquareTestDone = true;
}

///////////////////////////////////////////////////////////////////////////////////////
// Function does the move
///////////////////////////////////////////////////////////////////////////////////////

function doMove() {

    if (tilat.valko && !chessIsOn){
        if (isMyStart) {
            lowerMessage = "";
        }
        else {
            upperMessage = "";
        }

        gridToFEN(fromIndex, toIndex);
        if (currentMove == "enpassant") {blackCaptured.append({"captured":piePat + "p.png"})}
        if (movedPieces.get(1).piece !== piePat + "empty.png") {
            blackCaptured.append({"captured":movedPieces.get(1).piece})
        }
        currentMove = "";
        if (movedPieces.get(0).piece === piePat + "K.png") {wKingMoved = true;}
        midSquareCheckki = false;
        Mytab.addMove();
        if (playMode == "othDevice") {
            conTcpSrv.smove = hopo.test;
            conTcpCli.requestNewFortune();
            conTcpSrv.waitmove = conTcpCli.cmove;
        }
        vuoro.vaihdaMustalle();
    }

    else if (tilat.musta && !chessIsOn) {
        if (isMyStart) {
            upperMessage = "";
        }
        else {
            lowerMessage = "";
        }

        gridToFEN(fromIndex, toIndex);
        if (currentMove == "enpassant") {whiteCaptured.append({"captured":piePat + "P.png"})}
        if (movedPieces.get(1).piece !== piePat + "empty.png") {
            whiteCaptured.append({"captured":movedPieces.get(1).piece})
        }
        currentMove = "";
        if (movedPieces.get(0).piece === piePat + "k.png") {bKingMoved = true;}
        midSquareCheckki = false;
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

    recordMove();
    /*// Recording the move to the allMoves list
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
    allMoves.set(opsi.movesTotal, {"wKingInd":feni.feniWkingInd, "bKingInd":feni.feniBkingInd})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).wKingInd, allMoves.get(opsi.movesTotal).bKingInd)
    allMoves.set(opsi.movesTotal, {"wkingmoved":wKingMoved, "bkingmoved":bKingMoved})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).wkingmoved, allMoves.get(opsi.movesTotal).bkingmoved)
    allMoves.set(opsi.movesTotal, {"wcastlingPos":castlingWpossible, "bcastlingPos":castlingBpossible})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).wcastlingPos, allMoves.get(opsi.movesTotal).bcastlingPos)
    allMoves.set(opsi.movesTotal, {"whiteTimeMove":whiteTimeTotal_temp, "blackTimeMove":blackTimeTotal_temp})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).whiteTimeMove, allMoves.get(opsi.movesTotal).blackTimeMove)
    allMoves.set(opsi.movesTotal, {"whiteCapturedCount":whiteCaptured.count, "blackCapturedCount":blackCaptured.count})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).whiteCapturedCount, allMoves.get(opsi.movesTotal).blackCapturedCount)*/
    movesNoScanned = opsi.movesTotal;
}

function recordMove() {
    // Recording the move to the allMoves list
    //allMoves.append({"moveNo":opsi.movesTotal, "movedColor":movedPieces.get(0).color, "movedPiece":movedPieces.get(0).piece, "movedFrom":movedPieces.get(0).indeksos})
    allMoves.set(opsi.movesTotal, {"moveNo":opsi.movesTotal, "movedColor":movedPieces.get(0).color, "movedPiece":movedPieces.get(0).piece, "movedFrom":movedPieces.get(0).indeksos})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).movedColor, allMoves.get(opsi.movesTotal).movedPiece, allMoves.get(opsi.movesTotal).movedFrom)
    allMoves.set(opsi.movesTotal, {"capturedColor":movedPieces.get(1).color, "capturedPiece":movedPieces.get(1).piece, "capturedTo":movedPieces.get(1).indeksos})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).capturedColor, allMoves.get(opsi.movesTotal).capturedPiece, allMoves.get(opsi.movesTotal).capturedTo)
    allMoves.set(opsi.movesTotal, {"pairColor":movedPieces.get(2).color, "pairPiece":movedPieces.get(2).piece, "pairFrom":movedPieces.get(2).indeksos})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).pairColor, allMoves.get(opsi.movesTotal).pairPiece, allMoves.get(opsi.movesTotal).pairFrom)
    allMoves.set(opsi.movesTotal, {"pairCapturesColor":movedPieces.get(3).color, "pairCaptures":movedPieces.get(3).piece, "pairTo":movedPieces.get(3).indeksos})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).pairCapturesColor, allMoves.get(opsi.movesTotal).pairCaptures, allMoves.get(opsi.movesTotal).pairTo)
    allMoves.set(opsi.movesTotal, {"enpColor":movedPieces.get(4).color, "enpPiece":movedPieces.get(4).piece, "enpInd":movedPieces.get(4).indeksos})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).enpColor, allMoves.get(opsi.movesTotal).enpPiece, allMoves.get(opsi.movesTotal).enpInd)
    allMoves.set(opsi.movesTotal, {"wKingInd":feniWkingInd, "bKingInd":feniBkingInd})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).wKingInd, allMoves.get(opsi.movesTotal).bKingInd)
    allMoves.set(opsi.movesTotal, {"wkingmoved":wKingMoved, "bkingmoved":bKingMoved})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).wkingmoved, allMoves.get(opsi.movesTotal).bkingmoved)
    allMoves.set(opsi.movesTotal, {"wcastlingPos":castlingWpossible, "bcastlingPos":castlingBpossible})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).wcastlingPos, allMoves.get(opsi.movesTotal).bcastlingPos)
    allMoves.set(opsi.movesTotal, {"whiteTimeMove":whiteTimeTotal_temp, "blackTimeMove":blackTimeTotal_temp})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).whiteTimeMove, allMoves.get(opsi.movesTotal).blackTimeMove)
    allMoves.set(opsi.movesTotal, {"whiteCapturedCount":whiteCaptured.count, "blackCapturedCount":blackCaptured.count})
    //console.log(allMoves.get(opsi.movesTotal).moveNo, allMoves.get(opsi.movesTotal).whiteCapturedCount, allMoves.get(opsi.movesTotal).blackCapturedCount)

}

///////////////////////////////////////////////////////
// Function checks if white is in mate condition. First we test that are there legal moves, if yes we check if chess is still on. If so, mate or stalemate
////////////////////////////////////////////

function iswhiteInMate() {
    var doVisual = 0;
    var i_trial_move = -1;
    var j_trial_move = -1;
    var _moved_piece = ""
    var _moved_color = ""
    var _king_index = -1
    for(var i = 0; i < 64; i++){
        if (galeryModel.get(i).color === "w") {
            for(var j = 0; j < 64; j++){
                if (galeryModel.get(j).color === "b" || galeryModel.get(j).color === "e"){
                    if (Mymove.isLegalmove(doVisual, i, j, galeryModel.get(i).piece, test_state)) {
                        console.log ("Move is legal", i, j, galeryModel.get(i).piece);
                        i_trial_move = i;
                        j_trial_move = j;
                        if (!isChess_new(i,j)){
                            console.log("Some can be moved");
                            i = 64;
                            break;
                        }
                    }
                    else if (i===63 && j===63) {
                        console.log("Mate");
                    }
                }
            }
        }
    }
    for(i = 0; i < 64; i++){

    isChess_new(i,j)

    }
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
    galeryModel.set(fromIndex,{"color":"e", "piece":piePat + "empty.png"})
    // If castling, moving the rook also
    if (Math.abs(toIndex-fromIndex)==2 && galeryModel.get(toIndex).piece === piePat + "k.png") {
        if (toIndex == 6){
            galeryModel.set(5,{"color":"b", "piece":piePat + "r.png"})
            galeryModel.set(7,{"color":"e", "piece":piePat + "empty.png"})
        }
        else {
            galeryModel.set(3,{"color":"b", "piece":piePat + "r.png"})
            galeryModel.set(0,{"color":"e", "piece":piePat + "empty.png"})
        }
    }
    // If blacks move gives enpassant possibility to whiteTimer
    if (((fromIndex-toIndex) == -16) && galeryModel.get(toIndex).piece === piePat + "p.png") {
        benpassant = toIndex-8;
        galeryModel.set(benpassant,{"color":"bp"})
    }
    // If white gives enpassant possibility and it is utilized let's print a board accordingly
    if (toIndex != -1 && toIndex == wenpassant && galeryModel.get(toIndex).piece === piePat + "p.png") {
        galeryModel.set((toIndex-8),{"color":"e", "piece":piePat + "empty.png"});
        currentMove = "enpassant";
        wenpassant = -1;
    }
    // Adding moves to captures list
    if (currentMove == "enpassant") {
        whiteCaptured.append({"captured":piePat + "P.png"});
        currentMove = "";
    }
    if (movedPieces.get(1).piece !== piePat + "empty.png") {
        whiteCaptured.append({"captured":movedPieces.get(1).piece})
    }

    // If pawn reaches the last line let's guess the promotion to be a queen. Have to correct in future some how

    if (toIndex > 55 && galeryModel.get(toIndex).piece === piePat + "p.png") {
        galeryModel.set(toIndex, {"piece": piePat + "q.png"});
    }
    lowerMessage = "";
    upperMessage = "";
    Mytab.addMove();
    vuoro.vaihdaValkealle();
    isChessPure();
    movesDone = movesDone + opsi.recentMove; // Adding the move for openings comparison
    opsi.movesTotal++;
    galeryModel.set(fromIndex,{"recmove":opsi.movesTotal});
    galeryModel.set(toIndex,{"recmove":opsi.movesTotal});
    feniBlackReady2 = false;
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
    galeryModel.set(fromIndex,{"color":"e", "piece":piePat + "empty.png"})
    // If castling, moving the rook also
    if (Math.abs(toIndex-fromIndex)==2 && galeryModel.get(toIndex).piece === piePat + "K.png") {
        if (toIndex == 62){
            galeryModel.set(61,{"color":"w", "piece":piePat + "R.png"})
            galeryModel.set(63,{"color":"e", "piece":piePat + "empty.png"})
        }
        else {
            galeryModel.set(59,{"color":"w", "piece":piePat + "R.png"})
            galeryModel.set(56,{"color":"e", "piece":piePat + "empty.png"})
        }
    }
    // If whites move gives enpassant possibility to whiteTimer
    if (((fromIndex-toIndex) == 16) && galeryModel.get(toIndex).piece === piePat + "P.png") {
        wenpassant = toIndex+8
        galeryModel.set(wenpassant,{"color":"wp"})
    }
    // If black gives enpassant possibility and it is utilized let's print a board accordingly
    if (toIndex != -1 && toIndex == benpassant && galeryModel.get(toIndex).piece === piePat + "P.png") {
        galeryModel.set((toIndex+8),{"color":"e", "piece":piePat + "empty.png"});
        currentMove = "enpassant";
        benpassant = -1;
    }
    // Adding moves to captures list
    if (currentMove == "enpassant") {
        blackCaptured.append({"captured":piePat + "p.png"});
        currentMove = "";
    }
    if (movedPieces.get(1).piece !== piePat + "empty.png") {
        blackCaptured.append({"captured":movedPieces.get(1).piece})
    }

    // If pawn reaches the last line let's gues the promotion to be a queen. Have to correct in future some how

    if (toIndex < 8 && galeryModel.get(toIndex).piece === piePat + "P.png") {
        galeryModel.set(toIndex, {"piece": piePat + "Q.png"});
    }
    lowerMessage = "";
    upperMessage = "";
    Mytab.addMove();
    vuoro.vaihdaMustalle();
    Myfunks.isChessPure();
    movesDone = movesDone + opsi.recentMove; // Adding the move for openings comparison
    opsi.movesTotal++;
    galeryModel.set(fromIndex,{"recmove":opsi.movesTotal});
    galeryModel.set(toIndex,{"recmove":opsi.movesTotal});
    feniWhiteReady2 = false;
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
            stockfishFirstmove = false
            feniWhiteReady = false
            feniWhite = true
        }
        else {
            stockfishFirstmove = true
            feniWhiteReady = true
            feniWhite = false
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

    opsi.movesTotal = movesNoScanned; //Setting new maximum movecount
    if (playMode == "stockfish") {
        hopo.initio();
        for (i=1;i<movesNoScanned+1;i++){
            gridToFEN(allMoves.get(i).movedFrom, allMoves.get(i).capturedTo)
            //console.log(hopo.test)
            if (i=== movesNoScanned && i%2 === 1 && isMyStart) {
                hopo.inni();
                blackTimer.start()
                //console.log("Black continues", i)
            }
            else if (i=== movesNoScanned && i%2 === 0 && !isMyStart) {
                hopo.inni();
                whiteTimer.start()
                //console.log("White continues", i)
            }
            else {
                hopo.innio();
                // console.log("Move to stack", i)
            }
        }
    }
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
            galeryModel.set(i,{"color":"e", "piece":piePat + "empty.png"}); // Make enpassant possibilities empty, later fill values for last move
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

    // Removing first extra seconds after move
    if (movesNoScanned === opsi.movesTotal) {
        pureMillsecs = 0;
        pauseMillsecs = 0;
    }

    if (allMoves.get(movesNoScanned).movedColor === "w"){
        if (movesNoScanned < 2){ // First moves times has to be set a separate way
            pureMillsecs = 0;
            pauseMillsecs = 0;
            whiteTimeTotal = 0
            whiteTimeAccum = 0;
            whiteTimeAccum0 = 0;
        }
        else {
            whiteTimeAccum = 0;
            whiteTimeTotal_temp = allMoves.get(movesNoScanned-2).whiteTimeMove;
            whiteTimeAccum0 = allMoves.get(movesNoScanned-2).whiteTimeMove;
            whiteTimeTotal = allMoves.get(movesNoScanned-2).whiteTimeMove;
            blackTimeTotal_temp = allMoves.get(movesNoScanned-1).blackTimeMove;
            blackTimeAccum0 = allMoves.get(movesNoScanned-1).blackTimeMove;
            blackTimeTotal = allMoves.get(movesNoScanned-1).blackTimeMove;
        }
    }
    else {
        if (movesNoScanned < 2){ // First moves times has to be set a separate way
            pureMillsecs = 0;
            pauseMillsecs = 0;
            blackTimeTotal = 0
            blackTimeAccum = 0;
            blackTimeAccum0 = 0;
        }
        else {
            blackTimeAccum = 0;
            blackTimeTotal_temp = allMoves.get(movesNoScanned-2).blackTimeMove;
            blackTimeAccum0 = allMoves.get(movesNoScanned-2).blackTimeMove;
            blackTimeTotal = allMoves.get(movesNoScanned-2).blackTimeMove;
            whiteTimeTotal_temp = allMoves.get(movesNoScanned-1).whiteTimeMove;
            whiteTimeAccum0 = allMoves.get(movesNoScanned-1).whiteTimeMove;
            whiteTimeTotal = allMoves.get(movesNoScanned-1).whiteTimeMove;
        }
    }
    var label_sec_w = (valkomax*1000 - (whiteTimeTotal-whiteTimeTotal%1000))/1000%60;
    var label_min_w = (valkomax*1000 - (whiteTimeTotal-whiteTimeTotal%1000)-label_sec_w*1000)/60000;
    label_time_w = label_min_w + ":" + (label_sec_w < 10 ? "0" : "") + label_sec_w
    var label_sec_b = (mustamax*1000 - (blackTimeTotal-blackTimeTotal%1000))/1000%60;
    var label_min_b = (mustamax*1000 - (blackTimeTotal-blackTimeTotal%1000)-label_sec_b*1000)/60000;
    label_time_b = label_min_b + ":" + (label_sec_b < 10 ? "0" : "") + label_sec_b


    //feni.chessIsOn = false;// is this needed
    //midSquareCheckki = false;// is this needed
    //currentMove = "";// is this needed


    movesNoScanned--; //

    // King index setting
    feniWkingInd = allMoves.get(movesNoScanned).wKingInd
    feniBkingInd = allMoves.get(movesNoScanned).bKingInd

    // Set true if king moved
    wKingMoved = allMoves.get(movesNoScanned).wkingmoved
    bKingMoved = allMoves.get(movesNoScanned).bkingmoved

    // Set true if castling possible
    castlingWpossible = allMoves.get(movesNoScanned).wcastlingPos
    castlingBpossible = allMoves.get(movesNoScanned).bcastlingPos

    // Setting previous move values for enpassant to enable the enpassant move
    if (allMoves.get(movesNoScanned).enpColor !== "e" && allMoves.get(movesNoScanned).enpInd > 0){
        galeryModel.set(allMoves.get(movesNoScanned).enpInd,{"color":allMoves.get(movesNoScanned).enpColor, "piece":allMoves.get(movesNoScanned).enpPiece})
    }

    if (allMoves.get(movesNoScanned).movedColor === "w")
    {
        feniWhite = false;
        feniBlack = true;
        tilat.valko=false;
        tilat.musta=true;
    }
    else {
        feniWhite = true;
        feniBlack = false;
        tilat.valko=true;
        tilat.musta=false;
    }
}
function moveForward () {
    movesNoScanned++; //

    // Forwarding the moved piece to it's next position.
    galeryModel.set(allMoves.get(movesNoScanned).capturedTo,{"color":allMoves.get(movesNoScanned).movedColor, "piece":allMoves.get(movesNoScanned).movedPiece})

    // Inserting the empty piece to the place move started
    galeryModel.set(allMoves.get(movesNoScanned).movedFrom,{"color":"e", "piece":piePat + "empty.png"})

    // Removing enpassant values
    for (var i=0;i<64; i++){
        //galeryModel.set(i,{"frameop": 0, "recmove":-1}); // Removing last move squares
        if (galeryModel.get(i).color ==="wp" || galeryModel.get(i).color ==="bp"){
            galeryModel.set(i,{"color":"e", "piece":piePat + "empty.png"}); // Make enpassant possibilities empty, later fill values for the last move
        }
    }
    // Setting enpassant to enable the enpassant move if the game restarts at this point
    if (allMoves.get(movesNoScanned).enpColor !== "e" && allMoves.get(movesNoScanned).enpInd > 0){
        galeryModel.set(allMoves.get(movesNoScanned).enpInd,{"color":allMoves.get(movesNoScanned).enpColor, "piece":allMoves.get(movesNoScanned).enpPiece})
    }

    // Moving the captured piece in enpassant and the rook in the castling
    if (allMoves.get(movesNoScanned).pairColor !== "x" && allMoves.get(movesNoScanned).pairFrom > 0){
        galeryModel.set(allMoves.get(movesNoScanned).pairTo,{"color":allMoves.get(movesNoScanned).pairColor, "piece":allMoves.get(movesNoScanned).pairPiece})
    }

    // Setting the empty piece in the castling to the place where rook started
    if (allMoves.get(movesNoScanned).pairCapturesColor !== "x" && allMoves.get(movesNoScanned).pairTo > 0){
        galeryModel.set(allMoves.get(movesNoScanned).pairFrom,{"color":"e", "piece":piePat + "empty.png"})
    }
    // King index setting for chess checks
    feniWkingInd = allMoves.get(movesNoScanned).wKingInd
    feniBkingInd = allMoves.get(movesNoScanned).bKingInd

    // Set true if king moved
    wKingMoved = allMoves.get(movesNoScanned).wkingmoved
    bKingMoved = allMoves.get(movesNoScanned).bkingmoved

    // Set true if castling possible
    castlingWpossible = allMoves.get(movesNoScanned).wcastlingPos
    castlingBpossible = allMoves.get(movesNoScanned).bcastlingPos

    // Returning time values
    if (allMoves.get(movesNoScanned).movedColor === "w"){
        whiteTimeAccum = 0;
        whiteTimeTotal_temp = allMoves.get(movesNoScanned).whiteTimeMove;
        whiteTimeAccum0 = allMoves.get(movesNoScanned).whiteTimeMove;
        whiteTimeTotal = allMoves.get(movesNoScanned).whiteTimeMove;
        var label_sec_w = (valkomax*1000 - (whiteTimeTotal-whiteTimeTotal%1000))/1000%60;
        var label_min_w = (valkomax*1000 - (whiteTimeTotal-whiteTimeTotal%1000)-label_sec_w*1000)/60000;
        label_time_w = label_min_w + ":" + (label_sec_w < 10 ? "0" : "") + label_sec_w

    }
    else {
        blackTimeAccum = 0;
        blackTimeTotal_temp = allMoves.get(movesNoScanned).blackTimeMove;
        blackTimeAccum0 = allMoves.get(movesNoScanned).blackTimeMove;
        blackTimeTotal = allMoves.get(movesNoScanned).blackTimeMove;
        var label_sec_b = (mustamax*1000 - (blackTimeTotal-blackTimeTotal%1000))/1000%60;
        var label_min_b = (mustamax*1000 - (blackTimeTotal-blackTimeTotal%1000)-label_sec_b*1000)/60000;
        label_time_b = label_min_b + ":" + (label_sec_b < 10 ? "0" : "") + label_sec_b
    }

    if (allMoves.get(movesNoScanned).movedColor === "w")
    {
        feniWhite = false;
        feniBlack = true;
        tilat.valko=false;
        tilat.musta=true;
    }
    else {
        feniWhite = true;
        feniBlack = false;
        tilat.valko=true;
        tilat.musta=false;
    }


}
