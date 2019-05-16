/////////////////////////////////////////////////////////////////////
// Function isMovable() checks whether the square has a movable piece
/////////////////////////////////////////////////////////////////////

function isMovable(_fromIndex) {
    var _canBemoved = false;
    if (colorTobemoved === "b" && !tilat.valko) {
        _canBemoved = true;
        galeryModel.set(_fromIndex,{"frameop":100});
    }
    else if (colorTobemoved === "w" && tilat.valko) {
        _canBemoved = true;
        galeryModel.set(_fromIndex,{"frameop":100});
    }
    else {
        _canBemoved = false;
    }
    //var _state2 = _state
    //console.log("sub",_state2[_fromIndex].color, _state2[_fromIndex].piece, _state2[_fromIndex].frameop, _state2[_fromIndex].recmove)

    return _canBemoved;
}

////////////////////////////////////////
// This function determines legal moves
////////////////////////////////////////

function isLegalmove(doVisual, _fromIndex, _toIndex, _itemMoved, _state) {

    var _moveLegal = false;

    var rowfromInd = 8-(_fromIndex-_fromIndex%8)/8;
    var colfromInd = _fromIndex%8+1;
    var fromParity = (rowfromInd + colfromInd)%2;
    var rowtoInd = 8-(_toIndex-_toIndex%8)/8;
    var coltoInd = _toIndex%8+1;
    var toParity = (rowtoInd + coltoInd)%2;
    //_state[_toIndex].piece = current_state[_fromIndex].piece

    switch (_itemMoved) {
    case piePat + "p.png":  // Black pawn
        // Normal move
        if (((_fromIndex-_toIndex) == -8) && _state[_toIndex].color === "e") {
            //if (((_fromIndex-_toIndex) == -8) && galeryModel.get(_toIndex).color === "e") {
            _moveLegal = true;
            if (_toIndex > 55 && doVisual) {
                waitPromo = true
                var promotionObject
                if (promotionObject) {console.log(promotionObject)} else {console.log("Not Yet")}
                promotionObject = Qt.createComponent("Promotion.qml").createObject(page, {pro_piece: piePat + "p.png", pro_color:"b", pro_index: _fromIndex, turn_White: false});
                itemMoved = piePat + "p.png";
                currentMove = "promotion";
                console.log(promotionObject)
                //movedPieces.set(2,{"color":"b", "piece":piePat + "p.png", "indeksos":_fromIndex})
                //movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
            }
        }
        // Move of two rows from the start position
        else if (((_fromIndex-_toIndex) == -16) && _state[_toIndex].color === "e"
                 && _state[_toIndex-8].color === "e"
                 && (_fromIndex < 16)) {
            _moveLegal = true;
            if (doVisual){
            benpassant = _toIndex-8;
            test_state[benpassant].color = "bp";
            galeryModel.set(benpassant,{"color":"bp"})
            movedPieces.set(0,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
            movedPieces.set(1,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
            movedPieces.set(2,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
            movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
            movedPieces.set(4,{"color":"bp", "piece":piePat + "empty.png", "indeksos":benpassant}) //Set enpassant values
            }
        }
        // Capturing a piece
        else if (((_fromIndex-_toIndex) == -7) && Math.abs((_toIndex+1-_toIndex%8)/8-(_fromIndex+1-_fromIndex%8)/8) == 1
                 || ((_fromIndex-_toIndex) == -9) && Math.abs((_toIndex+1-_toIndex%8)/8-(_fromIndex+1-_fromIndex%8)/8) == 1) {
            if ((_state[_toIndex].color === "w")
                    ){
                _moveLegal = true;
                if (_toIndex > 55 && doVisual) {
                    waitPromo = true
                    Qt.createComponent("Promotion.qml").createObject(page, {pro_piece: piePat + "p.png", pro_color:"b", pro_index: _fromIndex, turn_White: false});
                    itemMoved = piePat + "p.png"
                    currentMove = "promotion";
                    //movedPieces.set(2,{"color":"b", "piece":piePat + "p.png", "indeksos":_fromIndex})
                    //movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                }
            }
            // En passant
            else if (_state[_toIndex].color === "wp") {
                _moveLegal = true;
                if (doVisual){
                    test_state[_toIndex-8].color = "e";
                    test_state[_toIndex-8].piece = piePat + "empty.png";
                galeryModel.set((_toIndex-8),{"color":"e", "piece":piePat + "empty.png"});
                currentMove = "enpassant";
                movedPieces.set(2,{"color":"w", "piece":piePat + "P.png", "indeksos":_toIndex-8})
                movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                wenpassant = -1;
                }
            }
            else {
                moveStarted=false;
                _fromIndex=-1;
                _toIndex=-1;
            }
        }

        else {
            moveStarted=false;
            _fromIndex=-1;
            _toIndex=-1;
        }
        break;
    case piePat + "P.png":
        // Normal move
        if (((_fromIndex-_toIndex) == 8) && _state[_toIndex].color === "e") {
            //console.log(_state[_toIndex].piece)
            _moveLegal = true;
            if (_toIndex < 8 && doVisual) {
                waitPromo = true
                Qt.createComponent("Promotion.qml").createObject(page, {pro_piece: piePat + "P.png", pro_color:"w", pro_index: _fromIndex, turn_White: true});
                itemMoved = piePat + "P.png"
                currentMove = "promotion";
                //movedPieces.set(2,{"color":"w", "piece":piePat + "P.png", "indeksos":_fromIndex})
                //movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
            }
        }
        // Move of two rows from the start position
        else if (((_fromIndex-_toIndex) == 16) && _state[_toIndex].color === "e"
                 && _state[_toIndex+8].color === "e"
                 && (_fromIndex > 47)) {
            _moveLegal = true;
            if (doVisual) {
                wenpassant = _toIndex+8;
                test_state[wenpassant].color = "wp"
                galeryModel.set(wenpassant,{"color":"wp"})
                movedPieces.set(0,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                movedPieces.set(1,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                movedPieces.set(2,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                movedPieces.set(4,{"color":"wp", "piece":piePat + "empty.png", "indeksos":wenpassant}) //Set enpassant values
            }
        }
        // Capturing a piece
        else if (((_fromIndex-_toIndex) == 7) && Math.abs((_toIndex+1-_toIndex%8)/8-(_fromIndex+1-_fromIndex%8)/8) == 1
                 || ((_fromIndex-_toIndex) == 9) && Math.abs((_toIndex+1-_toIndex%8)/8-(_fromIndex+1-_fromIndex%8)/8) == 1) {
            if ((_state[_toIndex].color === "b")
                    ){
                _moveLegal = true;
                if (_toIndex < 8 && doVisual) {
                    waitPromo = true
                    Qt.createComponent("Promotion.qml").createObject(page, {pro_piece: piePat + "P.png", pro_color:"w", pro_index: _fromIndex, turn_White: true});
                    itemMoved = piePat + "P.png"
                    currentMove = "promotion";
                    //movedPieces.set(2,{"color":"w", "piece":piePat + "P.png", "indeksos":_fromIndex})
                    //movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                }
            }
            // En passant
            else if (_state[_toIndex].color === "bp") {
                _moveLegal = true;
                if (doVisual) {
                    test_state[_toIndex+8].color = "e";
                    test_state[_toIndex+8].piece = piePat + "empty.png";
                galeryModel.set((_toIndex+8),{"color":"e", "piece":piePat + "empty.png"});
                currentMove = "enpassant";
                movedPieces.set(2,{"color":"b", "piece":piePat + "p.png", "indeksos":_toIndex+8})
                movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                benpassant = -1;
                }
            }

            else {
                moveStarted=false;
                _fromIndex=-1;
                _toIndex=-1;
            }
        }

        else {
            moveStarted=false;
            _fromIndex=-1;
            _toIndex=-1;
        }
        break;
    case piePat + "k.png":
        if (Math.abs(rowfromInd-rowtoInd) < 2
                && _state[_toIndex].color !== "b"
                && Math.abs(coltoInd-colfromInd) < 2
                ) {
                _moveLegal = true; //intLegal not needed any more to be removed from code
        }
            // Castling short
        else if ((_toIndex === 6) && galeryModel.get(6).color === "e"
                 && galeryModel.get(5).color === "e" && _fromIndex === 4
                 && castlingBpossible && !feniBlackChess
                 && !bKingMoved) {
            _moveLegal = true;
            if (doVisual){
                test_state[5].color = "b"
                test_state[5].piece = piePat + "r.png"
                test_state[7].color = "e"
                test_state[7].piece = piePat + "empty.png"
            galeryModel.set((5),{"color":"b", "piece":piePat + "r.png"});
            galeryModel.set((7),{"color":"e", "piece":piePat + "empty.png"});
            currentMove = "castling";
            castlingBpossible = false;
            midSquareInd = 5;
            // Saving the moved pieces and positions for a possible cancel of the move
            movedPieces.set(2,{"color":"b", "piece":piePat + "r.png", "indeksos":7})
            movedPieces.set(3,{"color":"e", "piece":piePat + "empty.png", "indeksos":5})
            }
        }
            // Castling long
        else if ((_toIndex === 2) && galeryModel.get(2).color === "e"
                 && galeryModel.get(3).color === "e" && galeryModel.get(1).color === "e"
                 && _fromIndex === 4
                 && castlingBpossible && !feniBlackChess
                 && !bKingMoved) {
            _moveLegal = true;
            if (doVisual) {
                test_state[3].color = "b"
                test_state[3].piece = piePat + "r.png"
                test_state[0].color = "e"
                test_state[0].piece = piePat + "empty.png"
            galeryModel.set((3),{"color":"b", "piece":piePat + "r.png"});
            galeryModel.set((0),{"color":"e", "piece":piePat + "empty.png"});
            currentMove = "castling";
            castlingBpossible = false;
            midSquareInd = 3;
            // Saving the moved pieces and positions for a possible cancel of the move
            movedPieces.set(2,{"color":"b", "piece":piePat + "r.png", "indeksos":0})
            movedPieces.set(3,{"color":"e", "piece":piePat + "empty.png", "indeksos":3})
            }
        }
        else {
                moveStarted=false;
                _fromIndex=-1;
                _toIndex=-1;
        }
        break;
    case piePat + "K.png":
                if (Math.abs(rowfromInd-rowtoInd) < 2
                        && _state[_toIndex].color !== "w"
                        && Math.abs(coltoInd-colfromInd) < 2
                        ) {
                _moveLegal = true;
            }
            // Castling kingside
            else if ((_toIndex === 62) && galeryModel.get(62).color === "e"
                        && galeryModel.get(61).color === "e"
                        && _fromIndex === 60
                        && castlingWpossible && !feniWhiteChess
                        && !wKingMoved) {
                    _moveLegal = true;
                    if(doVisual) {
                        test_state[61].color = "w"
                        test_state[61].piece = piePat + "R.png"
                        test_state[63].color = "e"
                        test_state[63].piece = piePat + "empty.png"
                    galeryModel.set((61),{"color":"w", "piece":piePat + "R.png"});
                    galeryModel.set((63),{"color":"e", "piece":piePat + "empty.png"});
                    currentMove = "castling";
                    castlingWpossible =false;
                    midSquareInd = 61;
                    // Saving the moved pieces and positions for a possible cancel of the move
                    movedPieces.set(2,{"color":"w", "piece":piePat + "R.png", "indeksos":63})
                    movedPieces.set(3,{"color":"e", "piece":piePat + "empty.png", "indeksos":61})
                    }
            }
            // Castling queenside
            else if ((_toIndex === 58) && galeryModel.get(58).color === "e"
                        && galeryModel.get(59).color === "e" && galeryModel.get(57).color === "e"
                        && _fromIndex === 60
                        && castlingWpossible && !feniWhiteChess
                        && !wKingMoved) {
                    _moveLegal = true;
                    if (doVisual) {
                        test_state[59].color = "w"
                        test_state[59].piece = piePat + "R.png"
                        test_state[56].color = "e"
                        test_state[56].piece = piePat + "empty.png"
                    galeryModel.set((59),{"color":"w", "piece":piePat + "R.png"});
                    galeryModel.set((56),{"color":"e", "piece":piePat + "empty.png"});
                    currentMove = "castling";
                    castlingWpossible = false;
                    midSquareInd = 59;
                    // Saving the moved pieces and positions for a possible cancel of the move
                    movedPieces.set(2,{"color":"w", "piece":piePat + "R.png", "indeksos":56})
                    movedPieces.set(3,{"color":"e", "piece":piePat + "empty.png", "indeksos":59})
                    }
            }
            else {
                moveStarted=false;
                _fromIndex=-1;
                _toIndex=-1;
            }
        break;
    case piePat + "Q.png":
        // Same column
        if ((((_fromIndex-_toIndex)%8 == 0))
                &&   _state[_toIndex].color !== "w"
                ){
               if (Math.abs(_toIndex-_fromIndex) == 8) {
                   _moveLegal = true;
               }
               else if (_toIndex > _fromIndex +8) {
                   var toHelpIndex = _toIndex-8;
                   var moveLegalHelp = true;
                   while (((toHelpIndex-_fromIndex) > 0) && moveLegalHelp) {
                       if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                           _moveLegal = true;
                           toHelpIndex = toHelpIndex -8;
                       }
                       else {
                           _moveLegal = false;
                           moveLegalHelp = false;
                           moveStarted=false;
                           _fromIndex=-1;
                           _toIndex=-1;
                       }
                   }
               }
               else if (_toIndex < _fromIndex-8) {
                   toHelpIndex = _toIndex+8;
                   moveLegalHelp = true;
                   while (((toHelpIndex-_fromIndex) < 0) && moveLegalHelp) {
                       if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                           _moveLegal = true;
                           toHelpIndex = toHelpIndex +8;
                       }
                       else {
                           _moveLegal = false;
                           moveLegalHelp = false;
                           moveStarted=false;
                           _fromIndex=-1;
                           _toIndex=-1;
                       }
                   }

               }
           }
        // Same row
        else if ((((_toIndex-_toIndex%8)/8) == ((_fromIndex-_fromIndex%8)/8)) && _state[_toIndex].color !== "w"
                 ){
            if (Math.abs(_toIndex-_fromIndex) == 1) {
                _moveLegal = true;
            }
            else if (_toIndex > _fromIndex +1) {
                toHelpIndex = _toIndex-1;
                moveLegalHelp = true;
                while (((toHelpIndex-_fromIndex) > 0) && moveLegalHelp) {
                    if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                        _moveLegal = true;
                        toHelpIndex = toHelpIndex -1;
                    }
                    else {
                        _moveLegal = false;
                        moveLegalHelp = false;
                        moveStarted=false;
                        _fromIndex=-1;
                        _toIndex=-1;
                    }
                }
            }
            else if (_toIndex < _fromIndex -1) {
                toHelpIndex = _toIndex+1;
                moveLegalHelp = true;
                while (((toHelpIndex-_fromIndex) < 0) && moveLegalHelp) {
                    if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                        _moveLegal = true;
                        toHelpIndex = toHelpIndex +1;
                    }
                    else {
                        _moveLegal = false;
                        moveLegalHelp = false;
                        moveStarted=false;
                        _fromIndex=-1;
                        _toIndex=-1;
                    }
                }
            }
        }
        // Same diagonal 9
        else if ((((_fromIndex-_toIndex)%9 == 0))
                &&   _state[_toIndex].color !== "w"
                 && fromParity == toParity
                 ){
               if (Math.abs(_toIndex-_fromIndex) == 9) {
                   _moveLegal = true;
               }
               else if (_toIndex > _fromIndex +9) {
                   toHelpIndex = _toIndex-9;
                   moveLegalHelp = true;
                   while (((toHelpIndex-_fromIndex) > 0) && moveLegalHelp) {
                       if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                           _moveLegal = true;
                           toHelpIndex = toHelpIndex -9;
                       }
                       else {
                           _moveLegal = false;
                           moveLegalHelp = false;
                           moveStarted=false;
                           _fromIndex=-1;
                           _toIndex=-1;
                       }
                   }
               }
               else if (_toIndex < _fromIndex-9) {
                   toHelpIndex = _toIndex+9;
                   moveLegalHelp = true;
                   while (((toHelpIndex-_fromIndex) < 0) && moveLegalHelp) {
                       if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                           _moveLegal = true;
                           toHelpIndex = toHelpIndex +9;
                       }
                       else {
                           _moveLegal = false;
                           moveLegalHelp = false;
                           moveStarted=false;
                           _fromIndex=-1;
                           _toIndex=-1;
                       }
                   }

               }
           }
        // Same diagonal 7
        else if ((((_fromIndex-_toIndex)%7 == 0))
             &&   _state[_toIndex].color !== "w"
                 && fromParity == toParity
                 ){
            if (Math.abs(_toIndex-_fromIndex) == 7) {
                _moveLegal = true;
            }
            else if (_toIndex > _fromIndex +7) {
                toHelpIndex = _toIndex-7;
                moveLegalHelp = true;
                while (((toHelpIndex-_fromIndex) > 0) && moveLegalHelp) {
                    if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                         || _state[toHelpIndex].color === "bp") {
                        _moveLegal = true;
                        toHelpIndex = toHelpIndex -7;
                    }
                    else {
                        _moveLegal = false;
                        moveLegalHelp = false;
                        moveStarted=false;
                        _fromIndex=-1;
                        _toIndex=-1;
                    }
                }
            }
            else if (_toIndex < _fromIndex-7) {
                toHelpIndex = _toIndex+7;
                moveLegalHelp = true;
                while (((toHelpIndex-_fromIndex) < 0) && moveLegalHelp) {
                    if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                         || _state[toHelpIndex].color === "bp") {
                        _moveLegal = true;
                        toHelpIndex = toHelpIndex +7;
                    }
                    else {
                        _moveLegal = false;
                        moveLegalHelp = false;
                        moveStarted=false;
                        _fromIndex=-1;
                        _toIndex=-1;
                    }
                }

            }
        }
        else {
                moveStarted=false;
                _fromIndex=-1;
                _toIndex=-1;
        }
        break;
    case piePat + "q.png":  // Same as Q.png but four "w"s
        // Same column
        if ((((_fromIndex-_toIndex)%8 == 0))
                &&   _state[_toIndex].color !== "b"
    ){
               if (Math.abs(_toIndex-_fromIndex) == 8) {
                   _moveLegal = true;
               }
               else if (_toIndex > _fromIndex +8) {
                   toHelpIndex = _toIndex-8;
                   moveLegalHelp = true;
                   while (((toHelpIndex-_fromIndex) > 0) && moveLegalHelp) {
                       if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                           _moveLegal = true;
                           toHelpIndex = toHelpIndex -8;
                       }
                       else {
                           _moveLegal = false;
                           moveLegalHelp = false;
                           moveStarted=false;
                           _fromIndex=-1;
                           _toIndex=-1;
                       }
                   }
               }
               else if (_toIndex < _fromIndex-8) {
                   toHelpIndex = _toIndex+8;
                   moveLegalHelp = true;
                   while (((toHelpIndex-_fromIndex) < 0) && moveLegalHelp) {
                       if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                           _moveLegal = true;
                           toHelpIndex = toHelpIndex +8;
                       }
                       else {
                           _moveLegal = false;
                           moveLegalHelp = false;
                           moveStarted=false;
                           _fromIndex=-1;
                           _toIndex=-1;
                       }
                   }

               }
           }
        // Same row
        else if ((((_toIndex-_toIndex%8)/8) == ((_fromIndex-_fromIndex%8)/8)) && _state[_toIndex].color !== "b"
                 ){
            if (Math.abs(_toIndex-_fromIndex) == 1) {
                _moveLegal = true;
            }
            else if (_toIndex > _fromIndex +1) {
                toHelpIndex = _toIndex-1;
                moveLegalHelp = true;
                while (((toHelpIndex-_fromIndex) > 0) && moveLegalHelp) {
                    if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                        _moveLegal = true;
                        toHelpIndex = toHelpIndex -1;
                    }
                    else {
                        _moveLegal = false;
                        moveLegalHelp = false;
                        moveStarted=false;
                        _fromIndex=-1;
                        _toIndex=-1;
                    }
                }
            }
            else if (_toIndex < _fromIndex -1) {
                toHelpIndex = _toIndex+1;
                moveLegalHelp = true;
                while (((toHelpIndex-_fromIndex) < 0) && moveLegalHelp) {
                    if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                        _moveLegal = true;
                        toHelpIndex = toHelpIndex +1;
                    }
                    else {
                        _moveLegal = false;
                        moveLegalHelp = false;
                        moveStarted=false;
                        _fromIndex=-1;
                        _toIndex=-1;
                    }
                }
            }
        }
        // Same diagonal 9
        else if ((((_fromIndex-_toIndex)%9 == 0))
                &&   _state[_toIndex].color !== "b"
                 && fromParity == toParity
                 ){
               if (Math.abs(_toIndex-_fromIndex) == 9) {
                   _moveLegal = true;
               }
               else if (_toIndex > _fromIndex +9) {
                   toHelpIndex = _toIndex-9;
                   moveLegalHelp = true;
                   while (((toHelpIndex-_fromIndex) > 0) && moveLegalHelp) {
                       if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                           _moveLegal = true;
                           toHelpIndex = toHelpIndex -9;
                       }
                       else {
                           _moveLegal = false;
                           moveLegalHelp = false;
                           moveStarted=false;
                           _fromIndex=-1;
                           _toIndex=-1;
                       }
                   }
               }
               else if (_toIndex < _fromIndex-9) {
                   toHelpIndex = _toIndex+9;
                   moveLegalHelp = true;
                   while (((toHelpIndex-_fromIndex) < 0) && moveLegalHelp) {
                       if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                           _moveLegal = true;
                           toHelpIndex = toHelpIndex +9;
                       }
                       else {
                           _moveLegal = false;
                           moveLegalHelp = false;
                           moveStarted=false;
                           _fromIndex=-1;
                           _toIndex=-1;
                       }
                   }

               }
           }
        // Same diagonal 7
        else if ((((_fromIndex-_toIndex)%7 == 0))
             &&   _state[_toIndex].color !== "b"
                 && fromParity == toParity
                 ){
            if (Math.abs(_toIndex-_fromIndex) == 7) {
                _moveLegal = true;
            }
            else if (_toIndex > _fromIndex +7) {
                toHelpIndex = _toIndex-7;
                moveLegalHelp = true;
                while (((toHelpIndex-_fromIndex) > 0) && moveLegalHelp) {
                    if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                         || _state[toHelpIndex].color === "bp") {
                        _moveLegal = true;
                        toHelpIndex = toHelpIndex -7;
                    }
                    else {
                        _moveLegal = false;
                        moveLegalHelp = false;
                        moveStarted=false;
                        _fromIndex=-1;
                        _toIndex=-1;
                    }
                }
            }
            else if (_toIndex < _fromIndex-7) {
                toHelpIndex = _toIndex+7;
                moveLegalHelp = true;
                while (((toHelpIndex-_fromIndex) < 0) && moveLegalHelp) {
                    if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                         || _state[toHelpIndex].color === "bp") {
                        _moveLegal = true;
                        toHelpIndex = toHelpIndex +7;
                    }
                    else {
                        _moveLegal = false;
                        moveLegalHelp = false;
                        moveStarted=false;
                        _fromIndex=-1;
                        _toIndex=-1;
                    }
                }

            }
        }
        else {
                moveStarted=false;
                _fromIndex=-1;
                _toIndex=-1;
        }
        break;
    case piePat + "B.png":
        if ((((_fromIndex-_toIndex)%9 == 0))
                && _state[_toIndex].color !== "w"
                && fromParity == toParity
                ){
               if (Math.abs(_toIndex-_fromIndex) == 9) {
                   _moveLegal = true;
               }
               else if (_toIndex > _fromIndex +9) {
                   toHelpIndex = _toIndex-9;
                   moveLegalHelp = true;
                   while (((toHelpIndex-_fromIndex) > 0) && moveLegalHelp) {
                       if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                           _moveLegal = true;
                           toHelpIndex = toHelpIndex -9;
                       }
                       else {
                           _moveLegal = false;
                           moveLegalHelp = false;
                           moveStarted=false;
                           _fromIndex=-1;
                           _toIndex=-1;
                       }
                   }
               }
               else if (_toIndex < _fromIndex-9) {
                   toHelpIndex = _toIndex+9;
                   moveLegalHelp = true;
                   while (((toHelpIndex-_fromIndex) < 0) && moveLegalHelp) {
                       if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                           _moveLegal = true;
                           toHelpIndex = toHelpIndex +9;
                       }
                       else {
                           _moveLegal = false;
                           moveLegalHelp = false;
                           moveStarted=false;
                           _fromIndex=-1;
                           _toIndex=-1;
                       }
                   }

               }
           }
        else if ((((_fromIndex-_toIndex)%7 == 0))
                 && _state[_toIndex].color !== "w"
                 && fromParity == toParity
                 ){
            if (Math.abs(_toIndex-_fromIndex) == 7) {
                _moveLegal = true;
            }
            else if (_toIndex > _fromIndex +7) {
                toHelpIndex = _toIndex-7;
                moveLegalHelp = true;
                while (((toHelpIndex-_fromIndex) > 0) && moveLegalHelp) {
                    if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                         || _state[toHelpIndex].color === "bp") {
                        _moveLegal = true;
                        toHelpIndex = toHelpIndex -7;
                    }
                    else {
                        _moveLegal = false;
                        moveLegalHelp = false;
                        moveStarted=false;
                        _fromIndex=-1;
                        _toIndex=-1;
                    }
                }
            }
            else if (_toIndex < _fromIndex-7) {
                toHelpIndex = _toIndex+7;
                moveLegalHelp = true;
                while (((toHelpIndex-_fromIndex) < 0) && moveLegalHelp) {
                    if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                         || _state[toHelpIndex].color === "bp") {
                        _moveLegal = true;
                        toHelpIndex = toHelpIndex +7;
                    }
                    else {
                        _moveLegal = false;
                        moveLegalHelp = false;
                        moveStarted=false;
                        _fromIndex=-1;
                        _toIndex=-1;
                    }
                }

            }
        }
        else {
                moveStarted=false;
                _fromIndex=-1;
                _toIndex=-1;
        }
        break;
    case piePat + "b.png": // Copy of white but two color checks changed from "w" to "b" ank k.png to K.png
        if ((((_fromIndex-_toIndex)%9 == 0))
                && _state[_toIndex].color !== "b"
                && fromParity == toParity
                ){
               if (Math.abs(_toIndex-_fromIndex) == 9) {
                   _moveLegal = true;
               }
               else if (_toIndex > _fromIndex +9) {
                   toHelpIndex = _toIndex-9;
                   moveLegalHelp = true;
                   while (((toHelpIndex-_fromIndex) > 0) && moveLegalHelp) {
                       if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                           _moveLegal = true;
                           toHelpIndex = toHelpIndex -9;
                       }
                       else {
                           _moveLegal = false;
                           moveLegalHelp = false;
                           moveStarted=false;
                           _fromIndex=-1;
                           _toIndex=-1;
                       }
                   }
               }
               else if (_toIndex < _fromIndex-9) {
                   toHelpIndex = _toIndex+9;
                   moveLegalHelp = true;
                   while (((toHelpIndex-_fromIndex) < 0) && moveLegalHelp) {
                       if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                           _moveLegal = true;
                           toHelpIndex = toHelpIndex +9;
                       }
                       else {
                           _moveLegal = false;
                           moveLegalHelp = false;
                           moveStarted=false;
                           _fromIndex=-1;
                           _toIndex=-1;
                       }
                   }

               }
           }
        else if ((((_fromIndex-_toIndex)%7 == 0))
                 && _state[_toIndex].color !== "b"
                 && fromParity == toParity
                 ){
            if (Math.abs(_toIndex-_fromIndex) == 7) {
                _moveLegal = true;
            }
            else if (_toIndex > _fromIndex +7) {
                toHelpIndex = _toIndex-7;
                moveLegalHelp = true;
                while (((toHelpIndex-_fromIndex) > 0) && moveLegalHelp) {
                    if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                         || _state[toHelpIndex].color === "bp") {
                        _moveLegal = true;
                        toHelpIndex = toHelpIndex -7;
                    }
                    else {
                        _moveLegal = false;
                        moveLegalHelp = false;
                        moveStarted=false;
                        _fromIndex=-1;
                        _toIndex=-1;
                    }
                }
            }
            else if (_toIndex < _fromIndex-7) {
                toHelpIndex = _toIndex+7;
                moveLegalHelp = true;
                while (((toHelpIndex-_fromIndex) < 0) && moveLegalHelp) {
                    if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                         || _state[toHelpIndex].color === "bp") {
                        _moveLegal = true;
                        toHelpIndex = toHelpIndex +7;
                    }
                    else {
                        _moveLegal = false;
                        moveLegalHelp = false;
                        moveStarted=false;
                        _fromIndex=-1;
                        _toIndex=-1;
                    }
                }

            }
        }
        else {
                moveStarted=false;
                _fromIndex=-1;
                _toIndex=-1;
        }
        break;
    case piePat + "N.png":
        if ((((_fromIndex-_toIndex) == 10) || ((_fromIndex-_toIndex) == 17)
             || ((_fromIndex-_toIndex) == 15) || ((_fromIndex-_toIndex) == 6)
             || ((_fromIndex-_toIndex) == -10) || ((_fromIndex-_toIndex) == -17)
             || ((_fromIndex-_toIndex) == -15) || ((_fromIndex-_toIndex) == -6))
                && _state[_toIndex].color !== "w"
                && fromParity != toParity
                ){
            _moveLegal = true;
        }
        else {
                moveStarted=false;
                _fromIndex=-1;
                _toIndex=-1;
        }
        break;
    case piePat + "n.png":
        if ((((_fromIndex-_toIndex) == 10) || ((_fromIndex-_toIndex) == 17)
             || ((_fromIndex-_toIndex) == 15) || ((_fromIndex-_toIndex) == 6)
             || ((_fromIndex-_toIndex) == -10) || ((_fromIndex-_toIndex) == -17)
             || ((_fromIndex-_toIndex) == -15) || ((_fromIndex-_toIndex) == -6))
                && _state[_toIndex].color !== "b"
                && fromParity != toParity
                ){
            _moveLegal = true;
        }
        else {
                moveStarted=false;
                _fromIndex=-1;
                _toIndex=-1;
        }
        break;
    case piePat + "R.png":
        if ((((_fromIndex-_toIndex)%8 == 0))
                &&   _state[_toIndex].color !== "w"
                ){
               if (Math.abs(_toIndex-_fromIndex) == 8) {
                   _moveLegal = true;
               }
               else if (_toIndex > _fromIndex +8) {
                   toHelpIndex = _toIndex-8;
                   moveLegalHelp = true;
                   while (((toHelpIndex-_fromIndex) > 0) && moveLegalHelp) {
                       if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                           _moveLegal = true;
                           toHelpIndex = toHelpIndex -8;
                       }
                       else {
                           _moveLegal = false;
                           moveLegalHelp = false;
                           moveStarted=false;
                           _fromIndex=-1;
                           _toIndex=-1;
                       }
                   }
               }
               else if (_toIndex < _fromIndex-8) {
                   toHelpIndex = _toIndex+8;
                   moveLegalHelp = true;
                   while (((toHelpIndex-_fromIndex) < 0) && moveLegalHelp) {
                       if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                           _moveLegal = true;
                           toHelpIndex = toHelpIndex +8;
                       }
                       else {
                           _moveLegal = false;
                           moveLegalHelp = false;
                           moveStarted=false;
                           _fromIndex=-1;
                           _toIndex=-1;
                       }
                   }

               }
           }
        // Same row
        else if ((((_toIndex-_toIndex%8)/8) == ((_fromIndex-_fromIndex%8)/8)) && _state[_toIndex].color !== "w"
                 ){
            if (Math.abs(_toIndex-_fromIndex) == 1) {
                _moveLegal = true;
            }
            else if (_toIndex > _fromIndex +1) {
                toHelpIndex = _toIndex-1;
                moveLegalHelp = true;
                while (((toHelpIndex-_fromIndex) > 0) && moveLegalHelp) {
                    if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                        _moveLegal = true;
                        toHelpIndex = toHelpIndex -1;
                    }
                    else {
                        _moveLegal = false;
                        moveLegalHelp = false;
                        moveStarted=false;
                        _fromIndex=-1;
                        _toIndex=-1;
                    }
                }
            }
            else if (_toIndex < _fromIndex -1) {
                toHelpIndex = _toIndex+1;
                moveLegalHelp = true;
                while (((toHelpIndex-_fromIndex) < 0) && moveLegalHelp) {
                    if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                        _moveLegal = true;
                        toHelpIndex = toHelpIndex +1;
                    }
                    else {
                        _moveLegal = false;
                        moveLegalHelp = false;
                        moveStarted=false;
                        _fromIndex=-1;
                        _toIndex=-1;
                    }
                }
            }
        }
        else {
                moveStarted=false;
                _fromIndex=-1;
                _toIndex=-1;
        }
        break;
    case piePat + "r.png": // Same as R.png but two "w"s changed to "b"s
        if ((((_fromIndex-_toIndex)%8 == 0))
                &&   _state[_toIndex].color !== "b"
                ){
               if (Math.abs(_toIndex-_fromIndex) == 8) {
                   _moveLegal = true;
               }
               else if (_toIndex > _fromIndex +8) {
                   toHelpIndex = _toIndex-8;
                   moveLegalHelp = true;
                   while (((toHelpIndex-_fromIndex) > 0) && moveLegalHelp) {
                       if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                           _moveLegal = true;
                           toHelpIndex = toHelpIndex -8;
                       }
                       else {
                           _moveLegal = false;
                           moveLegalHelp = false;
                           moveStarted=false;
                           _fromIndex=-1;
                           _toIndex=-1;
                       }
                   }
               }
               else if (_toIndex < _fromIndex-8) {
                   toHelpIndex = _toIndex+8;
                   moveLegalHelp = true;
                   while (((toHelpIndex-_fromIndex) < 0) && moveLegalHelp) {
                       if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                           _moveLegal = true;
                           toHelpIndex = toHelpIndex +8;
                       }
                       else {
                           _moveLegal = false;
                           moveLegalHelp = false;
                           moveStarted=false;
                           _fromIndex=-1;
                           _toIndex=-1;
                       }
                   }

               }
           }
        // Same row
        else if ((((_toIndex-_toIndex%8)/8) == ((_fromIndex-_fromIndex%8)/8)) && _state[_toIndex].color !== "b"
                 ){
            if (Math.abs(_toIndex-_fromIndex) == 1) {
                _moveLegal = true;
            }
            else if (_toIndex > _fromIndex +1) {
                toHelpIndex = _toIndex-1;
                moveLegalHelp = true;
                while (((toHelpIndex-_fromIndex) > 0) && moveLegalHelp) {
                    if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                        _moveLegal = true;
                        toHelpIndex = toHelpIndex -1;
                    }
                    else {
                        _moveLegal = false;
                        moveLegalHelp = false;
                        moveStarted=false;
                        _fromIndex=-1;
                        _toIndex=-1;
                    }
                }
            }
            else if (_toIndex < _fromIndex -1) {
                toHelpIndex = _toIndex+1;
                moveLegalHelp = true;
                while (((toHelpIndex-_fromIndex) < 0) && moveLegalHelp) {
                    if (_state[toHelpIndex].color === "e" || _state[toHelpIndex].color === "wp"
                            || _state[toHelpIndex].color === "bp") {
                        _moveLegal = true;
                        toHelpIndex = toHelpIndex +1;
                    }
                    else {
                        _moveLegal = false;
                        moveLegalHelp = false;
                        moveStarted=false;
                        _fromIndex=-1;
                        _toIndex=-1;
                    }
                }
            }
        }
        else {
                moveStarted=false;
                _fromIndex=-1;
                _toIndex=-1;
        }
        break;
    default:
        _moveLegal = false;
    }
    return _moveLegal;

}
