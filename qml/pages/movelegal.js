/////////////////////////////////////////////////////////////////////
// Function isMovable() checks whether the square has a movable piece
// _doVisual is used to differ real moves and various tests
/////////////////////////////////////////////////////////////////////

function isMovable(_doVisual) {
    //console.log("movelegal", _doVisual, _colorTobemoved)
    if (colorTobemoved === "b" && tilat.musta) {
        canBemoved = true;
        galeryModel.set(fromIndex,{"frameop":100});
    }
    else if (colorTobemoved === "w" && tilat.valko) {
        canBemoved = true;
        galeryModel.set(fromIndex,{"frameop":100});
    }
    else {
        canBemoved = false;
    }
}

////////////////////////////////////////
// This function determines legal moves
////////////////////////////////////////

function isLegalmove() {
    switch (itemMoved) {
    case piePat + "p.png":  // Black pawn
        // Normal move
        if (((fromIndex-toIndex) == -8) && galeryModel.get(toIndex).color === "e") {
            moveLegal = true; intLegal = 1;
            if (toIndex > 55 && !chessTest) {
                waitPromo = true
                turnWhite = false
                moveMent.pawnPromotion();
                itemMoved = piePat + "p.png";
                currentMove = "promotion";
                movedPieces.set(2,{"color":"b", "piece":piePat + "p.png", "indeksos":fromIndex})
                movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
            }
        }
        // Move of two rows from the start position
        else if (((fromIndex-toIndex) == -16) && galeryModel.get(toIndex).color === "e"
                 && galeryModel.get(toIndex-8).color === "e"
                 && (fromIndex < 16)) {
            moveLegal = true; intLegal = 1;
            benpassant = toIndex-8;
            galeryModel.set(benpassant,{"color":"bp"})
            movedPieces.set(0,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
            movedPieces.set(1,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
            movedPieces.set(2,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
            movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
            movedPieces.set(4,{"color":"bp", "piece":piePat + "empty.png", "indeksos":benpassant}) //Set enpassant values
        }
        // Capturing a piece
        else if (((fromIndex-toIndex) == -7) && Math.abs((toIndex+1-toIndex%8)/8-(fromIndex+1-fromIndex%8)/8) == 1
                 || ((fromIndex-toIndex) == -9) && Math.abs((toIndex+1-toIndex%8)/8-(fromIndex+1-fromIndex%8)/8) == 1) {
            if ((galeryModel.get(toIndex).color === "w")
                    ){
                moveLegal = true; intLegal = 1;
                if (toIndex > 55 && !chessTest) {
                    waitPromo = true
                    turnWhite = false
                    moveMent.pawnPromotion()
                    itemMoved = piePat + "p.png"
                    currentMove = "promotion";
                    movedPieces.set(2,{"color":"b", "piece":piePat + "p.png", "indeksos":fromIndex})
                    movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                }
            }
            // En passant
            else if (galeryModel.get(toIndex).color === "wp") {
                moveLegal = true;
                galeryModel.set((toIndex-8),{"color":"e", "piece":piePat + "empty.png"});
                currentMove = "enpassant";
                movedPieces.set(2,{"color":"w", "piece":piePat + "P.png", "indeksos":toIndex-8})
                movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                wenpassant = -1;
            }
            else {
                moveStarted=false;
                fromIndex=-1;
                toIndex=-1;
            }
        }

        else {
            moveStarted=false;
            fromIndex=-1;
            toIndex=-1;
        }
        break;
    case piePat + "P.png":
        // Normal move
        if (((fromIndex-toIndex) == 8) && galeryModel.get(toIndex).color === "e") {
            moveLegal = true; intLegal = 1;
            if (toIndex < 8 && !chessTest) {
                waitPromo = true
                turnWhite = true
                moveMent.pawnPromotion()
                itemMoved = piePat + "P.png"
                currentMove = "promotion";
                movedPieces.set(2,{"color":"w", "piece":piePat + "P.png", "indeksos":fromIndex})
                movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
            }
        }
        // Move of two rows from the start position
        else if (((fromIndex-toIndex) == 16) && galeryModel.get(toIndex).color === "e"
                 && galeryModel.get(toIndex+8).color === "e"
                 && (fromIndex > 47)) {
            moveLegal = true; intLegal = 1;
            wenpassant = toIndex+8;
            galeryModel.set(wenpassant,{"color":"wp"})
            movedPieces.set(0,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
            movedPieces.set(1,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
            movedPieces.set(2,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
            movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
            movedPieces.set(4,{"color":"wp", "piece":piePat + "empty.png", "indeksos":wenpassant}) //Set enpassant values
        }
        // Capturing a piece
        else if (((fromIndex-toIndex) == 7) && Math.abs((toIndex+1-toIndex%8)/8-(fromIndex+1-fromIndex%8)/8) == 1
                 || ((fromIndex-toIndex) == 9) && Math.abs((toIndex+1-toIndex%8)/8-(fromIndex+1-fromIndex%8)/8) == 1) {
            if ((galeryModel.get(toIndex).color === "b")
                    ){
                moveLegal = true; intLegal = 1;
                if (toIndex < 8 && !chessTest) {
                    waitPromo = true
                    turnWhite = true
                    moveMent.pawnPromotion()
                    itemMoved = piePat + "P.png"
                    currentMove = "promotion";
                    movedPieces.set(2,{"color":"w", "piece":piePat + "P.png", "indeksos":fromIndex})
                    movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                }
            }
            // En passant
            else if (galeryModel.get(toIndex).color === "bp") {
                moveLegal = true;
                galeryModel.set((toIndex+8),{"color":"e", "piece":piePat + "empty.png"});
                currentMove = "enpassant";
                movedPieces.set(2,{"color":"b", "piece":piePat + "p.png", "indeksos":toIndex+8})
                movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                benpassant = -1;
            }

            else {
                moveStarted=false;
                fromIndex=-1;
                toIndex=-1;
            }
        }

        else {
            moveStarted=false;
            fromIndex=-1;
            toIndex=-1;
        }
        break;
    case piePat + "k.png":
        if (Math.abs(rowfromInd-rowtoInd) < 2
                && galeryModel.get(toIndex).color !== "b"
                && Math.abs(coltoInd-colfromInd) < 2
                ) {
                moveLegal = true; intLegal = 1; //intLegal not needed any more to be removed from code
        }
            // Castling short
        else if ((toIndex == 6) && galeryModel.get(6).color === "e"
                 && galeryModel.get(5).color === "e" && fromIndex == 4
                 && castlingBpossible && !feni.feniBlackChess
                 && !bKingMoved) {
            moveLegal = true; intLegal = 1;
            galeryModel.set((5),{"color":"b", "piece":piePat + "r.png"});
            galeryModel.set((7),{"color":"e", "piece":piePat + "empty.png"});
            currentMove = "castling";
            castlingBpossible = false;
            midSquareInd = 5;
            // Saving the moved pieces and positions for a possible cancel of the move
            movedPieces.set(2,{"color":"b", "piece":piePat + "r.png", "indeksos":7})
            movedPieces.set(3,{"color":"e", "piece":piePat + "empty.png", "indeksos":5})
        }
            // Castling long
        else if ((toIndex == 2) && galeryModel.get(2).color === "e"
                 && galeryModel.get(3).color === "e" && galeryModel.get(1).color === "e"
                 && fromIndex == 4
                 && castlingBpossible && !feni.feniBlackChess
                 && !bKingMoved) {
            moveLegal = true; intLegal = 1;
            galeryModel.set((3),{"color":"b", "piece":piePat + "r.png"});
            galeryModel.set((0),{"color":"e", "piece":piePat + "empty.png"});
            currentMove = "castling";
            castlingBpossible = false;
            midSquareInd = 3;
            // Saving the moved pieces and positions for a possible cancel of the move
            movedPieces.set(2,{"color":"b", "piece":piePat + "r.png", "indeksos":0})
            movedPieces.set(3,{"color":"e", "piece":piePat + "empty.png", "indeksos":3})
        }
        else {
                moveStarted=false;
                fromIndex=-1;
                toIndex=-1;
        }
        break;
    case piePat + "K.png":
                if (Math.abs(rowfromInd-rowtoInd) < 2
                        && galeryModel.get(toIndex).color !== "w"
                        && Math.abs(coltoInd-colfromInd) < 2
                        ) {
                moveLegal = true;
            }
            // Castling kingside
            else if ((toIndex == 62) && galeryModel.get(62).color === "e"
                        && galeryModel.get(61).color === "e"
                        && fromIndex == 60
                        && castlingWpossible && !feni.feniWhiteChess
                        && !wKingMoved) {
                    moveLegal = true; intLegal = 1;
                    galeryModel.set((61),{"color":"w", "piece":piePat + "R.png"});
                    galeryModel.set((63),{"color":"e", "piece":piePat + "empty.png"});
                    currentMove = "castling";
                    castlingWpossible =false;
                    midSquareInd = 61;
                    // Saving the moved pieces and positions for a possible cancel of the move
                    movedPieces.set(2,{"color":"w", "piece":piePat + "R.png", "indeksos":63})
                    movedPieces.set(3,{"color":"e", "piece":piePat + "empty.png", "indeksos":61})
            }
            // Castling queenside
            else if ((toIndex == 58) && galeryModel.get(58).color === "e"
                        && galeryModel.get(59).color === "e" && galeryModel.get(57).color === "e"
                        && fromIndex == 60
                        && castlingWpossible && !feni.feniWhiteChess
                        && !wKingMoved) {
                    moveLegal = true; intLegal = 1;
                    galeryModel.set((59),{"color":"w", "piece":piePat + "R.png"});
                    galeryModel.set((56),{"color":"e", "piece":piePat + "empty.png"});
                    currentMove = "castling";
                    castlingWpossible = false;
                    midSquareInd = 59;
                    // Saving the moved pieces and positions for a possible cancel of the move
                    movedPieces.set(2,{"color":"w", "piece":piePat + "R.png", "indeksos":56})
                    movedPieces.set(3,{"color":"e", "piece":piePat + "empty.png", "indeksos":59})
            }
            else {
                moveStarted=false;
                fromIndex=-1;
                toIndex=-1;
            }
        break;
    case piePat + "Q.png":
        // Same column
        if ((((fromIndex-toIndex)%8 == 0))
                &&   galeryModel.get(toIndex).color !== "w"
                ){
               if (Math.abs(toIndex-fromIndex) == 8) {
                   moveLegal = true; intLegal = 1;
               }
               else if (toIndex > fromIndex +8) {
                   var toHelpIndex = toIndex-8;
                   var moveLegalHelp = true;
                   while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                       if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                           moveLegal = true; intLegal = 1;
                           toHelpIndex = toHelpIndex -8;
                       }
                       else {
                           moveLegal = false; intLegal = -1;
                           moveLegalHelp = false;
                           moveStarted=false;
                           fromIndex=-1;
                           toIndex=-1;
                       }
                   }
               }
               else if (toIndex < fromIndex-8) {
                   toHelpIndex = toIndex+8;
                   moveLegalHelp = true;
                   while (((toHelpIndex-fromIndex) < 0) && moveLegalHelp) {
                       if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                           moveLegal = true; intLegal = 1;
                           toHelpIndex = toHelpIndex +8;
                       }
                       else {
                           moveLegal = false; intLegal = -1;
                           moveLegalHelp = false;
                           moveStarted=false;
                           fromIndex=-1;
                           toIndex=-1;
                       }
                   }

               }
           }
        // Same row
        else if ((((toIndex-toIndex%8)/8) == ((fromIndex-fromIndex%8)/8)) && galeryModel.get(toIndex).color !== "w"
                 ){
            if (Math.abs(toIndex-fromIndex) == 1) {
                moveLegal = true; intLegal = 1;
            }
            else if (toIndex > fromIndex +1) {
                toHelpIndex = toIndex-1;
                moveLegalHelp = true;
                while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                    if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                        moveLegal = true; intLegal = 1;
                        toHelpIndex = toHelpIndex -1;
                    }
                    else {
                        moveLegal = false; intLegal = -1;
                        moveLegalHelp = false;
                        moveStarted=false;
                        fromIndex=-1;
                        toIndex=-1;
                    }
                }
            }
            else if (toIndex < fromIndex -1) {
                toHelpIndex = toIndex+1;
                moveLegalHelp = true;
                while (((toHelpIndex-fromIndex) < 0) && moveLegalHelp) {
                    if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                        moveLegal = true; intLegal = 1;
                        toHelpIndex = toHelpIndex +1;
                    }
                    else {
                        moveLegal = false; intLegal = -1;
                        moveLegalHelp = false;
                        moveStarted=false;
                        fromIndex=-1;
                        toIndex=-1;
                    }
                }
            }
        }
        // Same diagonal 9
        else if ((((fromIndex-toIndex)%9 == 0))
                &&   galeryModel.get(toIndex).color !== "w"
                 && fromParity == toParity
                 ){
               if (Math.abs(toIndex-fromIndex) == 9) {
                   moveLegal = true; intLegal = 1;
               }
               else if (toIndex > fromIndex +9) {
                   toHelpIndex = toIndex-9;
                   moveLegalHelp = true;
                   while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                       if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                           moveLegal = true; intLegal = 1;
                           toHelpIndex = toHelpIndex -9;
                       }
                       else {
                           moveLegal = false; intLegal = -1;
                           moveLegalHelp = false;
                           moveStarted=false;
                           fromIndex=-1;
                           toIndex=-1;
                       }
                   }
               }
               else if (toIndex < fromIndex-9) {
                   toHelpIndex = toIndex+9;
                   moveLegalHelp = true;
                   while (((toHelpIndex-fromIndex) < 0) && moveLegalHelp) {
                       if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                           moveLegal = true; intLegal = 1;
                           toHelpIndex = toHelpIndex +9;
                       }
                       else {
                           moveLegal = false; intLegal = -1;
                           moveLegalHelp = false;
                           moveStarted=false;
                           fromIndex=-1;
                           toIndex=-1;
                       }
                   }

               }
           }
        // Same diagonal 7
        else if ((((fromIndex-toIndex)%7 == 0))
             &&   galeryModel.get(toIndex).color !== "w"
                 && fromParity == toParity
                 ){
            if (Math.abs(toIndex-fromIndex) == 7) {
                moveLegal = true; intLegal = 1;
            }
            else if (toIndex > fromIndex +7) {
                toHelpIndex = toIndex-7;
                moveLegalHelp = true;
                while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                    if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                         || galeryModel.get(toHelpIndex).color === "bp") {
                        moveLegal = true; intLegal = 1;
                        toHelpIndex = toHelpIndex -7;
                    }
                    else {
                        moveLegal = false; intLegal = -1;
                        moveLegalHelp = false;
                        moveStarted=false;
                        fromIndex=-1;
                        toIndex=-1;
                    }
                }
            }
            else if (toIndex < fromIndex-7) {
                toHelpIndex = toIndex+7;
                moveLegalHelp = true;
                while (((toHelpIndex-fromIndex) < 0) && moveLegalHelp) {
                    if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                         || galeryModel.get(toHelpIndex).color === "bp") {
                        moveLegal = true; intLegal = 1;
                        toHelpIndex = toHelpIndex +7;
                    }
                    else {
                        moveLegal = false; intLegal = -1;
                        moveLegalHelp = false;
                        moveStarted=false;
                        fromIndex=-1;
                        toIndex=-1;
                    }
                }

            }
        }
        else {
                moveStarted=false;
                fromIndex=-1;
                toIndex=-1;
        }
        break;
    case piePat + "q.png":  // Same as Q.png but four "w"s
        // Same column
        if ((((fromIndex-toIndex)%8 == 0))
                &&   galeryModel.get(toIndex).color !== "b"
    ){
               if (Math.abs(toIndex-fromIndex) == 8) {
                   moveLegal = true; intLegal = 1;
               }
               else if (toIndex > fromIndex +8) {
                   toHelpIndex = toIndex-8;
                   moveLegalHelp = true;
                   while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                       if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                           moveLegal = true; intLegal = 1;
                           toHelpIndex = toHelpIndex -8;
                       }
                       else {
                           moveLegal = false; intLegal = -1;
                           moveLegalHelp = false;
                           moveStarted=false;
                           fromIndex=-1;
                           toIndex=-1;
                       }
                   }
               }
               else if (toIndex < fromIndex-8) {
                   toHelpIndex = toIndex+8;
                   moveLegalHelp = true;
                   while (((toHelpIndex-fromIndex) < 0) && moveLegalHelp) {
                       if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                           moveLegal = true; intLegal = 1;
                           toHelpIndex = toHelpIndex +8;
                       }
                       else {
                           moveLegal = false; intLegal = -1;
                           moveLegalHelp = false;
                           moveStarted=false;
                           fromIndex=-1;
                           toIndex=-1;
                       }
                   }

               }
           }
        // Same row
        else if ((((toIndex-toIndex%8)/8) == ((fromIndex-fromIndex%8)/8)) && galeryModel.get(toIndex).color !== "b"
                 ){
            if (Math.abs(toIndex-fromIndex) == 1) {
                moveLegal = true; intLegal = 1;
            }
            else if (toIndex > fromIndex +1) {
                toHelpIndex = toIndex-1;
                moveLegalHelp = true;
                while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                    if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                        moveLegal = true; intLegal = 1;
                        toHelpIndex = toHelpIndex -1;
                    }
                    else {
                        moveLegal = false; intLegal = -1;
                        moveLegalHelp = false;
                        moveStarted=false;
                        fromIndex=-1;
                        toIndex=-1;
                    }
                }
            }
            else if (toIndex < fromIndex -1) {
                toHelpIndex = toIndex+1;
                moveLegalHelp = true;
                while (((toHelpIndex-fromIndex) < 0) && moveLegalHelp) {
                    if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                        moveLegal = true; intLegal = 1;
                        toHelpIndex = toHelpIndex +1;
                    }
                    else {
                        moveLegal = false; intLegal = -1;
                        moveLegalHelp = false;
                        moveStarted=false;
                        fromIndex=-1;
                        toIndex=-1;
                    }
                }
            }
        }
        // Same diagonal 9
        else if ((((fromIndex-toIndex)%9 == 0))
                &&   galeryModel.get(toIndex).color !== "b"
                 && fromParity == toParity
                 ){
               if (Math.abs(toIndex-fromIndex) == 9) {
                   moveLegal = true; intLegal = 1;
               }
               else if (toIndex > fromIndex +9) {
                   toHelpIndex = toIndex-9;
                   moveLegalHelp = true;
                   while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                       if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                           moveLegal = true; intLegal = 1;
                           toHelpIndex = toHelpIndex -9;
                       }
                       else {
                           moveLegal = false; intLegal = -1;
                           moveLegalHelp = false;
                           moveStarted=false;
                           fromIndex=-1;
                           toIndex=-1;
                       }
                   }
               }
               else if (toIndex < fromIndex-9) {
                   toHelpIndex = toIndex+9;
                   moveLegalHelp = true;
                   while (((toHelpIndex-fromIndex) < 0) && moveLegalHelp) {
                       if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                           moveLegal = true; intLegal = 1;
                           toHelpIndex = toHelpIndex +9;
                       }
                       else {
                           moveLegal = false; intLegal = -1;
                           moveLegalHelp = false;
                           moveStarted=false;
                           fromIndex=-1;
                           toIndex=-1;
                       }
                   }

               }
           }
        // Same diagonal 7
        else if ((((fromIndex-toIndex)%7 == 0))
             &&   galeryModel.get(toIndex).color !== "b"
                 && fromParity == toParity
                 ){
            if (Math.abs(toIndex-fromIndex) == 7) {
                moveLegal = true; intLegal = 1;
            }
            else if (toIndex > fromIndex +7) {
                toHelpIndex = toIndex-7;
                moveLegalHelp = true;
                while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                    if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                         || galeryModel.get(toHelpIndex).color === "bp") {
                        moveLegal = true; intLegal = 1;
                        toHelpIndex = toHelpIndex -7;
                    }
                    else {
                        moveLegal = false; intLegal = -1;
                        moveLegalHelp = false;
                        moveStarted=false;
                        fromIndex=-1;
                        toIndex=-1;
                    }
                }
            }
            else if (toIndex < fromIndex-7) {
                toHelpIndex = toIndex+7;
                moveLegalHelp = true;
                while (((toHelpIndex-fromIndex) < 0) && moveLegalHelp) {
                    if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                         || galeryModel.get(toHelpIndex).color === "bp") {
                        moveLegal = true; intLegal = 1;
                        toHelpIndex = toHelpIndex +7;
                    }
                    else {
                        moveLegal = false; intLegal = -1;
                        moveLegalHelp = false;
                        moveStarted=false;
                        fromIndex=-1;
                        toIndex=-1;
                    }
                }

            }
        }
        else {
                moveStarted=false;
                fromIndex=-1;
                toIndex=-1;
        }
        break;
    case piePat + "B.png":
        if ((((fromIndex-toIndex)%9 == 0))
                && galeryModel.get(toIndex).color !== "w"
                && fromParity == toParity
                ){
               if (Math.abs(toIndex-fromIndex) == 9) {
                   moveLegal = true; intLegal = 1;
               }
               else if (toIndex > fromIndex +9) {
                   toHelpIndex = toIndex-9;
                   moveLegalHelp = true;
                   while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                       if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                           moveLegal = true; intLegal = 1;
                           toHelpIndex = toHelpIndex -9;
                       }
                       else {
                           moveLegal = false; intLegal = -1;
                           moveLegalHelp = false;
                           moveStarted=false;
                           fromIndex=-1;
                           toIndex=-1;
                       }
                   }
               }
               else if (toIndex < fromIndex-9) {
                   toHelpIndex = toIndex+9;
                   moveLegalHelp = true;
                   while (((toHelpIndex-fromIndex) < 0) && moveLegalHelp) {
                       if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                           moveLegal = true; intLegal = 1;
                           toHelpIndex = toHelpIndex +9;
                       }
                       else {
                           moveLegal = false; intLegal = -1;
                           moveLegalHelp = false;
                           moveStarted=false;
                           fromIndex=-1;
                           toIndex=-1;
                       }
                   }

               }
           }
        else if ((((fromIndex-toIndex)%7 == 0))
                 && galeryModel.get(toIndex).color !== "w"
                 && fromParity == toParity
                 ){
            if (Math.abs(toIndex-fromIndex) == 7) {
                moveLegal = true; intLegal = 1;
            }
            else if (toIndex > fromIndex +7) {
                toHelpIndex = toIndex-7;
                moveLegalHelp = true;
                while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                    if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                         || galeryModel.get(toHelpIndex).color === "bp") {
                        moveLegal = true; intLegal = 1;
                        toHelpIndex = toHelpIndex -7;
                    }
                    else {
                        moveLegal = false; intLegal = -1;
                        moveLegalHelp = false;
                        moveStarted=false;
                        fromIndex=-1;
                        toIndex=-1;
                    }
                }
            }
            else if (toIndex < fromIndex-7) {
                toHelpIndex = toIndex+7;
                moveLegalHelp = true;
                while (((toHelpIndex-fromIndex) < 0) && moveLegalHelp) {
                    if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                         || galeryModel.get(toHelpIndex).color === "bp") {
                        moveLegal = true; intLegal = 1;
                        toHelpIndex = toHelpIndex +7;
                    }
                    else {
                        moveLegal = false; intLegal = -1;
                        moveLegalHelp = false;
                        moveStarted=false;
                        fromIndex=-1;
                        toIndex=-1;
                    }
                }

            }
        }
        else {
                moveStarted=false;
                fromIndex=-1;
                toIndex=-1;
        }
        break;
    case piePat + "b.png": // Copy of white but two color checks changed from "w" to "b" ank k.png to K.png
        if ((((fromIndex-toIndex)%9 == 0))
                && galeryModel.get(toIndex).color !== "b"
                && fromParity == toParity
                ){
               if (Math.abs(toIndex-fromIndex) == 9) {
                   moveLegal = true; intLegal = 1;
               }
               else if (toIndex > fromIndex +9) {
                   toHelpIndex = toIndex-9;
                   moveLegalHelp = true;
                   while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                       if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                           moveLegal = true; intLegal = 1;
                           toHelpIndex = toHelpIndex -9;
                       }
                       else {
                           moveLegal = false; intLegal = -1;
                           moveLegalHelp = false;
                           moveStarted=false;
                           fromIndex=-1;
                           toIndex=-1;
                       }
                   }
               }
               else if (toIndex < fromIndex-9) {
                   toHelpIndex = toIndex+9;
                   moveLegalHelp = true;
                   while (((toHelpIndex-fromIndex) < 0) && moveLegalHelp) {
                       if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                           moveLegal = true; intLegal = 1;
                           toHelpIndex = toHelpIndex +9;
                       }
                       else {
                           moveLegal = false; intLegal = -1;
                           moveLegalHelp = false;
                           moveStarted=false;
                           fromIndex=-1;
                           toIndex=-1;
                       }
                   }

               }
           }
        else if ((((fromIndex-toIndex)%7 == 0))
                 && galeryModel.get(toIndex).color !== "b"
                 && fromParity == toParity
                 ){
            if (Math.abs(toIndex-fromIndex) == 7) {
                moveLegal = true; intLegal = 1;
            }
            else if (toIndex > fromIndex +7) {
                toHelpIndex = toIndex-7;
                moveLegalHelp = true;
                while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                    if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                         || galeryModel.get(toHelpIndex).color === "bp") {
                        moveLegal = true; intLegal = 1;
                        toHelpIndex = toHelpIndex -7;
                    }
                    else {
                        moveLegal = false; intLegal = -1;
                        moveLegalHelp = false;
                        moveStarted=false;
                        fromIndex=-1;
                        toIndex=-1;
                    }
                }
            }
            else if (toIndex < fromIndex-7) {
                toHelpIndex = toIndex+7;
                moveLegalHelp = true;
                while (((toHelpIndex-fromIndex) < 0) && moveLegalHelp) {
                    if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                         || galeryModel.get(toHelpIndex).color === "bp") {
                        moveLegal = true; intLegal = 1;
                        toHelpIndex = toHelpIndex +7;
                    }
                    else {
                        moveLegal = false; intLegal = -1;
                        moveLegalHelp = false;
                        moveStarted=false;
                        fromIndex=-1;
                        toIndex=-1;
                    }
                }

            }
        }
        else {
                moveStarted=false;
                fromIndex=-1;
                toIndex=-1;
        }
        break;
    case piePat + "N.png":
        if ((((fromIndex-toIndex) == 10) || ((fromIndex-toIndex) == 17)
             || ((fromIndex-toIndex) == 15) || ((fromIndex-toIndex) == 6)
             || ((fromIndex-toIndex) == -10) || ((fromIndex-toIndex) == -17)
             || ((fromIndex-toIndex) == -15) || ((fromIndex-toIndex) == -6))
                && galeryModel.get(toIndex).color !== "w"
                && fromParity != toParity
                ){
            moveLegal = true; intLegal = 1;
        }
        else {
                moveStarted=false;
                fromIndex=-1;
                toIndex=-1;
        }
        break;
    case piePat + "n.png":
        if ((((fromIndex-toIndex) == 10) || ((fromIndex-toIndex) == 17)
             || ((fromIndex-toIndex) == 15) || ((fromIndex-toIndex) == 6)
             || ((fromIndex-toIndex) == -10) || ((fromIndex-toIndex) == -17)
             || ((fromIndex-toIndex) == -15) || ((fromIndex-toIndex) == -6))
                && galeryModel.get(toIndex).color !== "b"
                && fromParity != toParity
                ){
            moveLegal = true; intLegal = 1;
        }
        else {
                moveStarted=false;
                fromIndex=-1;
                toIndex=-1;
        }
        break;
    case piePat + "R.png":
        if ((((fromIndex-toIndex)%8 == 0))
                &&   galeryModel.get(toIndex).color !== "w"
                ){
               if (Math.abs(toIndex-fromIndex) == 8) {
                   moveLegal = true; intLegal = 1;
               }
               else if (toIndex > fromIndex +8) {
                   toHelpIndex = toIndex-8;
                   moveLegalHelp = true;
                   while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                       if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                           moveLegal = true; intLegal = 1;
                           toHelpIndex = toHelpIndex -8;
                       }
                       else {
                           moveLegal = false; intLegal = -1;
                           moveLegalHelp = false;
                           moveStarted=false;
                           fromIndex=-1;
                           toIndex=-1;
                       }
                   }
               }
               else if (toIndex < fromIndex-8) {
                   toHelpIndex = toIndex+8;
                   moveLegalHelp = true;
                   while (((toHelpIndex-fromIndex) < 0) && moveLegalHelp) {
                       if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                           moveLegal = true; intLegal = 1;
                           toHelpIndex = toHelpIndex +8;
                       }
                       else {
                           moveLegal = false; intLegal = -1;
                           moveLegalHelp = false;
                           moveStarted=false;
                           fromIndex=-1;
                           toIndex=-1;
                       }
                   }

               }
           }
        // Same row
        else if ((((toIndex-toIndex%8)/8) == ((fromIndex-fromIndex%8)/8)) && galeryModel.get(toIndex).color !== "w"
                 ){
            if (Math.abs(toIndex-fromIndex) == 1) {
                moveLegal = true; intLegal = 1;
            }
            else if (toIndex > fromIndex +1) {
                toHelpIndex = toIndex-1;
                moveLegalHelp = true;
                while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                    if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                        moveLegal = true; intLegal = 1;
                        toHelpIndex = toHelpIndex -1;
                    }
                    else {
                        moveLegal = false; intLegal = -1;
                        moveLegalHelp = false;
                        moveStarted=false;
                        fromIndex=-1;
                        toIndex=-1;
                    }
                }
            }
            else if (toIndex < fromIndex -1) {
                toHelpIndex = toIndex+1;
                moveLegalHelp = true;
                while (((toHelpIndex-fromIndex) < 0) && moveLegalHelp) {
                    if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                        moveLegal = true; intLegal = 1;
                        toHelpIndex = toHelpIndex +1;
                    }
                    else {
                        moveLegal = false; intLegal = -1;
                        moveLegalHelp = false;
                        moveStarted=false;
                        fromIndex=-1;
                        toIndex=-1;
                    }
                }
            }
        }
        else {
                moveStarted=false;
                fromIndex=-1;
                toIndex=-1;
        }
        break;
    case piePat + "r.png": // Same as R.png but two "w"s changed to "b"s
        if ((((fromIndex-toIndex)%8 == 0))
                &&   galeryModel.get(toIndex).color !== "b"
                ){
               if (Math.abs(toIndex-fromIndex) == 8) {
                   moveLegal = true; intLegal = 1;
               }
               else if (toIndex > fromIndex +8) {
                   toHelpIndex = toIndex-8;
                   moveLegalHelp = true;
                   while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                       if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                           moveLegal = true; intLegal = 1;
                           toHelpIndex = toHelpIndex -8;
                       }
                       else {
                           moveLegal = false; intLegal = -1;
                           moveLegalHelp = false;
                           moveStarted=false;
                           fromIndex=-1;
                           toIndex=-1;
                       }
                   }
               }
               else if (toIndex < fromIndex-8) {
                   toHelpIndex = toIndex+8;
                   moveLegalHelp = true;
                   while (((toHelpIndex-fromIndex) < 0) && moveLegalHelp) {
                       if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                           moveLegal = true; intLegal = 1;
                           toHelpIndex = toHelpIndex +8;
                       }
                       else {
                           moveLegal = false; intLegal = -1;
                           moveLegalHelp = false;
                           moveStarted=false;
                           fromIndex=-1;
                           toIndex=-1;
                       }
                   }

               }
           }
        // Same row
        else if ((((toIndex-toIndex%8)/8) == ((fromIndex-fromIndex%8)/8)) && galeryModel.get(toIndex).color !== "b"
                 ){
            if (Math.abs(toIndex-fromIndex) == 1) {
                moveLegal = true; intLegal = 1;
            }
            else if (toIndex > fromIndex +1) {
                toHelpIndex = toIndex-1;
                moveLegalHelp = true;
                while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                    if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                        moveLegal = true; intLegal = 1;
                        toHelpIndex = toHelpIndex -1;
                    }
                    else {
                        moveLegal = false; intLegal = -1;
                        moveLegalHelp = false;
                        moveStarted=false;
                        fromIndex=-1;
                        toIndex=-1;
                    }
                }
            }
            else if (toIndex < fromIndex -1) {
                toHelpIndex = toIndex+1;
                moveLegalHelp = true;
                while (((toHelpIndex-fromIndex) < 0) && moveLegalHelp) {
                    if (galeryModel.get(toHelpIndex).color === "e" || galeryModel.get(toHelpIndex).color === "wp"
                            || galeryModel.get(toHelpIndex).color === "bp") {
                        moveLegal = true; intLegal = 1;
                        toHelpIndex = toHelpIndex +1;
                    }
                    else {
                        moveLegal = false; intLegal = -1;
                        moveLegalHelp = false;
                        moveStarted=false;
                        fromIndex=-1;
                        toIndex=-1;
                    }
                }
            }
        }
        else {
                moveStarted=false;
                fromIndex=-1;
                toIndex=-1;
        }
        break;
    default:
        moveLegal = false;
    }
}
