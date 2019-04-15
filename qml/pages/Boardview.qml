/*Copyright (c) 2015, Riku Lahtinen
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "./images"
import "funktiot.js" as Myfunks
import "openings.js" as Myops
import "tables.js" as Mytab
import "movelegal.js" as Mymove
import harbour.shakkikello.stockfish 1.0
import harbour.shakkikello.client 1.0
import harbour.shakkikello.server 1.0

Page {
    id: page

    property int pureMillsec0 //Absolute milliseconds when turn changes
    property int pureMillsecs //Milliseconds after last turn
    property int pauseMillsecs //Milliseconds when game paused
    property int whiteTimeAccum0 // White Time Accumulated when turn changes
    property int whiteTimeTotal_temp // White Time Accumulated when turn changes, temporary save
    property int whiteTimeAccum // White Time Accumulated during current turn
    property int whiteTimeTotal // White total time
    property int blackTimeAccum0 // Black Time Accumulated when turn changes
    property int blackTimeTotal_temp // Black Time Accumulated when turn changes, temporary save
    property int blackTimeAccum // Black Time Accumulated during current turn
    property int blackTimeTotal // Black total time
    property string label_time_w // White time form 4:24
    property string label_time_b // Black time form 4:23

    //property int movesTotal: 0; //Records moves done, maybe to be moved from opsi
    property int movesNoScanned: 0; //Tells the move under scannin e.g. when backing. In play same than movesTotal

    property int fromIndex : -1
    property int toIndex : -1
///////TBD
    property int indeksi;
    //property int toHelpIndex; //for checking empty midsquares for bishop, rook and queen
    property int wenpassant: -1; //White gives enpassant possibility, board index number
    property int benpassant: -1; //Black gives enpassant possibility, board index number
    property string itemTobemoved;
    property string colorTobemoved;
    property string itemMoved;
    property string colorMoved;
    property bool canBemoved: false; //True if the piece can be moved somewhere
    property bool moveLegal: false; //True if the move to the destination is possible
    property int intLegal: -1; //this is an unneeded variable
    //property bool moveLegalHelp; //for checking empty midsquares for bishop, rook and queen
    property int rowfromInd; // This ind to help diagonal moves checks
    property int colfromInd; // This ind to help diagonal moves checks
    property int rowtoInd; // This ind to help diagonal moves checks
    property int coltoInd; // This ind to help diagonal moves checks
    property int fromParity; // This ind to help diagonal moves checks
    property int toParity; // This ind to help diagonal moves checks
    property bool chessTest: false; // Flag if chess is tested, prevents pawn promotion
    property bool castlingWpossible: true; // Check if White castling is possible
    property bool castlingBpossible: true; // Check if Black castling is possible
    property string currentMove: ""; // Values castling, wenpassant or promotion
    property bool wKingMoved: false; // To record this for castling checks
    property bool bKingMoved: false; // To record this for castling checks
    property int midSquareInd  // Used for castling test
    property bool midSquareCheckki: false; // Used for castling check

///////    TBD

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: {
                    pageStack.clear()
                    pageStack.push(Qt.resolvedUrl("Settings.qml"))
                }
            }

            MenuItem {
                text: qsTr("Save and manage games")
                onClicked: pageStack.push(Qt.resolvedUrl("GameList.qml"))
            }

            MenuItem {
                text: qsTr("Show moves")
                onClicked: pageStack.push(Qt.resolvedUrl("GameInfo2.qml"))
            }

            MenuItem { //Start/Pause
                text: aloitapause
                enabled: !tilat.peliloppui
                onClicked: {
                    if (!tilat.pelialkoi) {
                        Myfunks.startGame()
                    }
                    else if (tilat.juoksee) {
                        Myfunks.pauseGame()
                    }
                    else {
                        Myfunks.continueGame()
                    }
                }
            }
        }

        contentHeight: column.height

        Stockfishe { // for Stockfish communication
            id:hopo
        }

        /// TCP P2P connection correspondence
        TcpClient {
            id: conTcpCli
            onCmoveChanged:{
                if (conTcpSrv.waitmove != cmove) {
                    if (!isMyStart && tilat.pelialkoi && cmove != "white" && cmove != "start"){
                        hopo.test = cmove;
                        Myfunks.othDeviceMoveWhite()
                    }
                    else if (isMyStart && tilat.pelialkoi && cmove != "black" && cmove != "start")
                    {
                        hopo.test = cmove;
                        Myfunks.othDeviceMoveBlack();
                    }
                }
            }
        }

        TcpServer {
            id: conTcpSrv

            onWaitmoveChanged: {
                if (conTcpSrv.waitmove == conTcpCli.cmove && playMode == "othDevice"){
                    conTcpCli.requestNewFortune();
                }
            }
        }

        //// End TCP P2P portion

        Column {
            id: column

            width: page.width
            spacing: 0

            Item {
                id: feni
                property string startFeni;
                property string stopFeni;
                property bool feniBlackReady:false;
                property bool feniBlackReady2:false;
                property bool feniWhiteReady:false;
                property bool feniWhiteReady2:false;
                property int feniHelper;
                property string stringHelper;
                property bool feniBlack:false; //tells if it is blacks turn
                property bool feniWhite:false; // tells if it is Whites turn
                property bool stockfishFirstmove: false
                property bool feniWhiteChess: false;
                property bool feniBlackChess: false;
                property bool chessIsOn: false;
                property bool forChessCheck: false;
                property int feniWkingInd: 60;
                property int feniBkingInd: 4;
                property bool feniCancelMove: false;
                property int temptoIndex;
                property int tempfromIndex;
                property int ax; // for looping
                property string upperMessage: ""
                property string lowerMessage: ""
                property var messages: [{msg:qsTr("Check!")},
                    {msg:qsTr("Checkmate!")},
                    {msg:qsTr("Stalemate!")},
                    {msg:qsTr("White won!")},
                    {msg:qsTr("Black won!")}
                ]
                property bool chessTestDone: false;
                property bool midSquareTestDone: false;
            }

            Item {
                id:opsi
                property string openingCompare: "";
                property string openingSelected: "";
                property string recentMove: "";
                property string tymp: "" //temporary
                property int movesTotal: 0; //Records moves done
                property bool openingPossible: false; // Tells if opening possible
                property int yx //index for for, maybe not needed in future, replace by var i
                property int rantomi; //random number for opening selection
                property var selOpenings: []; //array for sel openings
                // Openings collected from various web pages. Main source is https://en.wikipedia.org/wiki/List_of_chess_openings
                property var openings: [
                    // A
                    {name:"Irregular,Sokolsky Opening, Schuhler Gambit", eco:"A00",
                        moves:"b2b4c7c6c1b2a7a5b4b5c6b5e2e4"},
                    {name:"Larsen's Opening, Polish variation", eco:"A01",
                        moves:"b2b3b7b5"},
                    {name:"Bird's Opening, Swiss Gambit", eco:"A02",
                        moves:"f2f4f7f5e2e4f5e4b1c3g1f6g2g4"},
                    {name:"Bird's Opening, Timothy Taylor's book", eco:"A03",
                        moves:"f2f4d7d5g1f3g7g6e2e3f8g7f1e2g8f6e1g1e8g8d2d3c7c5"},
                    {name:"RÃ©ti Opening", eco:"A04",
                        moves:"g1f3"},
                    {name:"RÃ©ti Opening, Santassiere's Folly", eco:"A05",
                        moves:"g1f3g8f6b2b4"},
                    {name:"RÃ©ti Opening", eco:"A06",
                        moves:"g1f3d7d5"},
                    {name:"RÃ©ti Opening, King's Indian Attack (Barcza System), Yugoslav variation", eco:"A07",
                        moves:"g1f3d7d5g2g3c7c6"},
                    {name:"RÃ©ti Opening, King's Indian Attack", eco:"A08",
                        moves:"g1f3d7d5g2g3c7c5f1g2"},
                    {name:"RÃ©ti Opening", eco:"A09",
                        moves:"g1f3d7d5c2c4"},
                    // In some phase web link to wiki could be nice
                    {name:"English Anglo-Dutch", eco:"A10",
                        moves:"c2c4f7f5"},
                    {name:"English, Caroâ€“Kann defensive system", eco:"A11",
                        moves:"c2c4c7c6"},
                    {name:"English London Defence", eco:"A12",
                        moves:"c2c4c7c6g1f3d7d5b2b3g8f6g2g3c8f5"},
                    {name:"English Opening: 1...e6", eco:"A13",
                        moves:"c2c4e7e6"},
                    {name:"English, Neo-Catalan declined", eco:"A14",
                        moves:"c2c4e7e6g1f3d7d5g2g3g8f6f1g2f8e7"},
                    {name:"English, Anglo-Indian Defence: 1...Nf6", eco:"A15",
                        moves:"c2c4g8f6"},
                    {name:"Anglo-GrÃ¼nfeld", eco:"A16",
                        moves:"c2c4g8f6b1c3d7d5"},
                    {name:"English Opening, Hedgehog Defence", eco:"A17",
                        moves:"c2c4g8f6b1c3e7e6"},
                    {name:"English, Mikenasâ€“Carls Variation", eco:"A18",
                        moves:"c2c4g8f6b1c3e7e6e2e4"},
                    {name:"English, Mikenasâ€“Carls, Sicilian Variation:", eco:"A19",
                        moves:"c2c4g8f6b1c3e7e6e2e4c7c5"},
                    {name:"English Opening", eco:"A20",
                        moves:"c2c4e7e5"},   
                    {name:"English Opening", eco:"A21",
                        moves:"c2c4e7e5b1c3"},
                    {name:"English Opening", eco:"A22",
                        moves:"c2c4e7e5b1c3g8f6"},
                    {name:"English Opening, Bremen System, Keres Variation", eco:"A23",
                        moves:"c2c4e7e5b1c3g8f6g2g3c7c6"},
                    {name:"English Opening, Bremen System", eco:"A24",
                        moves:"c2c4e7e5b1c3g8f6g2g3g7g6"},
                    {name:"English Opening, Sicilian Reversed", eco:"A25",
                        moves:"c2c4e7e5b1c3b8c6"},
                    {name:"English Opening, Closed System, Botvinnik System", eco:"A26",
                        moves:"c2c4e7e5b1c3b8c6g2g3g7g6f1g2f8g7d2d3d7d6e2e4"},
                    {name:"English Opening, Three Knights System", eco:"A27",
                        moves:"c2c4e7e5b1c3b8c6g1f3"},
                    {name:"English Opening, Four Knights System", eco:"A28",
                        moves:"c2c4e7e5b1c3b8c6g1f3g8f6"},
                    {name:"English Opening, Four Knights, Kingside Fianchetto", eco:"A29",
                        moves:"c2c4e7e5b1c3b8c6g1f3g8f6g2g3"},
                    {name:"English Opening", eco:"A30",
                        moves:"c2c4c7c5"},
                    {name:"English Opening, Symmetrical, Benoni formation", eco:"A31",
                        moves:"c2c4c7c5g1f3g8f6d2d4"},
                    {name:"English Opening, Symmetrical", eco:"A32",
                        moves:"c2c4c7c5g1f3g8f6d2d4c5d4f3d4e7e6"},
                    {name:"English Opening, Symmetrical, Geller variation", eco:"A33",
                        moves:"c2c4c7c5g1f3g8f6d2d4c5d4f3d4e7e6b1c3b8c6g2g3d8b6"},
                    {name:"English Opening, Symmetrical", eco:"A34",
                        moves:"c2c4c7c5b1c3"},
                    {name:"English Opening, Symmetrical, Four Knights", eco:"A35",
                        moves:"c2c4c7c5b1c3b8c6e2e3g8f6g1f3"},
                    {name:"English Opening, Symmetrical", eco:"A36",
                        moves:"c2c4c7c5b1c3b8c6g2g3"},
                    {name:"English Opening, Symmetrical", eco:"A37",
                        moves:"c2c4c7c5b1c3b8c6g2g3g7g6f1g2f8g7g1f3"},
                    {name:"English Opening, Symmetrical", eco:"A38",
                        moves:"c2c4c7c5b1c3b8c6g2g3g7g6f1g2f8g7g1f3g8f6"},
                    {name:"English Opening, Symmetrical", eco:"A39",
                        moves:"c2c4c7c5b1c3b8c6g2g3g7g6f1g2f8g7g1f3g8f6e1g1e8g8"},
                    {name:"Queen's Pawn Game, Polish Defence", eco:"A40",
                        moves:"d2d4b7b5"},
                    {name:"Queen's Pawn Game", eco:"A45",
                        moves:"d2d4g8f6"},
                    {name:"Queen's Pawn Game, Torre Attack", eco:"A46",
                        moves:"d2d4g8f6g1f3"},
                    {name:"Queen's Indian Defence", eco:"A47",
                        moves:"d2d4g8f6g1f3b7b6"},
                    {name:"King's Indian, East Indian Defence", eco:"A48",
                        moves:"d2d4g8f6g1f3b7b6"},
                    {name:"King's Indian, East Indian Defence Przepiórka", eco:"A49",
                        moves:"d2d4g8f6g1f3b7b6g2g3"},
                    {name:"Queen's Pawn Game, Black Knights' Tango", eco:"A50",
                        moves:"d2d4g8f6c2c4b8c6"},
                    {name:"Budapest Gambit declined", eco:"A51",
                        moves:"d2d4g8f6c2c4e7e5"},
                    {name:"Budapest Gambit", eco:"A52",
                        moves:"d2d4g8f6c2c4e7e5"}, //same as A51??
                    {name:"Old Indian Defence (Chigorin Indian Defence)", eco:"A53",
                        moves:"d2d4g8f6c2c4d7d6"},
                    {name:"Old Indian, Ukrainian Variation", eco:"A54", //Same as A53?
                        moves:"d2d4g8f6c2c4d7d6"},
                    {name:"Old Indian, Main line", eco:"A55",
                        moves:"d2d4g8f6c2c4d7d6b1c3e7e5g1f3b8d7e2e4"},
                    {name:"Benoni Defense", eco:"A56",
                        moves:"d2d4g8f6c2c4c7c5d4d5"},
                    {name:"Benko Gambit", eco:"A57",
                        moves:"d2d4g8f6c2c4c7c5d4d5b7b5"},
                    {name:"Benko Gambit Accepted", eco:"A58",
                        moves:"d2d4g8f6c2c4c7c5d4d5b7b5c4b5a7a6b5a6"},
                    {name:"Benko Gambit, 7.e4", eco:"A59",
                        moves:"d2d4g8f6c2c4c7c5d4d5b7b5c4b5a7a6b5a6c8a6b1c3d7d6e2e4"},
                    {name:"Modern Benoni", eco:"A60",
                        moves:"d2d4g8f6c2c4c7c5d4d5e7e6"},
                    {name:"Modern Benoni", eco:"A61", // Not able to see difference to A60
                        moves:"d2d4g8f6c2c4c7c5d4d5e7e6"},
                    {name:"Benoni, Fianchetto Variation without early ...Nbd7", eco:"A62", // Not able to see all the moves
                        moves:"d2d4g8f6c2c4c7c5d4d5e7e6b1c3e6d5c4d5d7d6g1f3g7g6g2g3f8g7f1g2e8g8e1g1"},
                    {name:"Benoni, Fianchetto Variation, 9...Nbd7", eco:"A63", // Currently same than A62
                        moves:"d2d4g8f6c2c4c7c5d4d5e7e6b1c3e6d5c4d5d7d6g1f3g7g6g2g3f8g7f1g2e8g8e1g1"},
                    {name:"Benoni, Fianchetto Variation, 11...Re8", eco:"A64", // Currently same than A62
                        moves:"d2d4g8f6c2c4c7c5d4d5e7e6b1c3e6d5c4d5d7d6g1f3g7g6g2g3f8g7f1g2e8g8e1g1"},
                    {name:"Benoni, 6.e4", eco:"A65", //Currently same than A60
                        moves:"d2d4g8f6c2c4c7c5d4d5e7e6"},
                    {name:"Benoni, Pawn Storm Variation", eco:"A66", //Currently same than A60
                        moves:"d2d4g8f6c2c4c7c5d4d5e7e6"},
                    {name:"Benoni, Taimanov Variation", eco:"A67",
                        moves:"d2d4g8f6c2c4c7c5d4d5e7e6b1c3e6d5c4d5d7d6e2e4g7g6f2f4f8g7f1b5"},
                    {name:"Benoni, Four Pawns Attack", eco:"A68", //Cannot make ready
                        moves:"d2d4g8f6c2c4c7c5d4d5e7e6b1c3e6d5c4d5d7d6e2e4g7g6f2f4f8g7"},
                    {name:"Benoni, Four Pawns Attack, Main line", eco:"A69", //Cannot make ready
                        moves:"d2d4g8f6c2c4c7c5d4d5e7e6b1c3e6d5c4d5d7d6e2e4g7g6f2f4f8g7"},
                    {name:"Benoni, Classical with e4 and Nf3", eco:"A70",
                        moves:"d2d4g8f6c2c4c7c5d4d5e7e6b1c3e6d5c4d5d7d6e2e4g7g6g1f3"},
                    {name:"Dutch Defence", eco:"A80",
                        moves:"d2d4f7f5"},
                    {name:"Dutch Defence", eco:"A90",
                        moves:"d2d4f7f5c2c4g1f6g2g3e7e6f1g2"},
                    // B
                    {name:"King's Pawn Opening, Hippopotamus Defence", eco:"B00",
                        moves:"e2e4g7g6d2d4f8g7b1c3a7a6"}, //Start of the game Spassky vs. Ujtelky, Sochi 1964
                    {name:"Caro–Kann Defence", eco:"B10",
                        moves:"e2e4c7c6"},
                    {name:"Sicilian Defence", eco:"B20",
                        moves:"e2e4c7c5"},
                    {name:"Sicilian, Rossolimo Variation", eco:"B30",
                        moves:"e2e4c7c5g1f3b8c6f1b5"},
                    {name:"Sicilian Defence, 2.Nf3 e6", eco:"B40",
                        moves:"e2e4c7c5g1f3e7e6"},
                    {name:"Sicilian Defence", eco:"B50",
                        moves:"e2e4c7c5g1f3d7d6"},
                    {name:"Sicilian, Richter-Rauzer", eco:"B60",
                        moves:"e2e4c7c5g1f3d7d6d2d4c5d4f3d4g8f6b1c3b8c6c1g5"},
                    {name:"Sicilian, Dragon", eco:"B70",
                        moves:"e2e4c7c5g1f3d7d6d2d4c5d4f3d4g8f6b1c3g7g6"},
                    {name:"Sicilian, Dragon, Levenfish", eco:"B71",
                        moves:"e2e4c7c5g1f3d7d6d2d4c5d4f3d4g8f6b1c3g7g6f2f4"},
                    {name:"Sicilian, Dragon", eco:"B72",
                        moves:"e2e4c7c5g1f3d7d6d2d4c5d4f3d4g8f6b1c3g7g6c1e3"},
                    {name:"Sicilian, Dragon", eco:"B73",
                        moves:"e2e4c7c5g1f3d7d6d2d4c5d4f3d4g8f6b1c3g7g6c1e3f8g7f1e2b8c6e1g1"},
                    {name:"Sicilian, Scheveningen Variation", eco:"B80",
                        moves:"e2e4c7c5g1f3d7d6d2d4c5d4f3d4g8f6b1c3e7e6"},
                    {name:"Sicilian, Sozin, 7.Be3", eco:"B90",
                        moves:"e2e4c7c5g1f3d7d6d2d4c5d4f3d4g8f6b1c3e7e6c1e3"},
                    // C
                    {name:"French Defence", eco:"C00",
                        moves:"e2e4e7e6"},
                    {name:"French Defence,Advance Variation", eco:"C02",
                        moves:"e2e4e7e6d2d4d7d5e4e5"},
                    {name:"French, Paulsen Variation", eco:"C10",
                        moves:"e2e4e7e6d2d4d7d5b1c3"},
                    {name:"King's Pawn Game, Napoleon Opening", eco:"C20",
                        moves:"e2e4e7e5d1f3"},
                    {name:"King's Gambit", eco:"C30",
                        moves:"e2e4e7e5f2f4"},
                    {name:"King's Knight Opening, Latvian Gambit", eco:"C40",
                        moves:"e2e4e7e5g1f3f7f5"},
                    {name:"Hungarian Defense", eco:"C50",
                        moves:"e2e4e7e5g1f3b8c6f1c4f8e7"},
                    {name:"Giuoco Piano", eco:"C53",
                        moves:"e2e4e7e5g1f3b8c6f1c4f8c5"},
                    {name:"Ruy Lopez", eco:"C60",
                        moves:"e2e4e7e5g1f3b8c6f1b5"},
                    {name:"Norwegian Defence", eco:"C70",
                        moves:"e2e4e7e5g1f3b8c6f1b5a7a6b5a4b7b5a4b3c6a5"},
                    {name:"Ruy Lopez, Open (Tarrasch) Defence", eco:"C80", //Not ready
                        moves:"e2e4e7e5g1f3b8c6f1b5"},
                    {name:"Ruy Lopez, Closed, 7...d6", eco:"C90", //Not ready
                        moves:"e2e4e7e5g1f3b8c6f1b5"},
                    // D
                    {name:"Queen's Pawn Game", eco:"D00",
                        moves:"d2d4d7d5"},
                    {name:"Queen's Gambit", eco:"D06",
                        moves:"d2d4d7d5c2c4"},
                    {name:"Slav Defense", eco:"D10",
                        moves:"d2d4d7d5c2c4c7c6"},
                    {name:"Queen's Gambit Accepted", eco:"D20",
                        moves:"d2d4d7d5c2c4d5c4"},
                    {name:"Queen's Gambit Declined", eco:"D30",
                        moves:"d2d4d7d5c2c4e7e6"},
                    {name:"Queen's Gambit Declined, Tarrasch", eco:"D32",
                        moves:"d2d4d7d5c2c4e7e6b1c3c7c5"},
                    {name:"Queen's Gambit Declined, Semi-Tarrasch Defense", eco:"D40",
                        moves:"d2d4d7d5c2c4e7e6b1c3g8f6g1f3c7c5"},
                    {name:"Queen's Gambit Declined", eco:"D50", // Kesken
                        moves:"d2d4d7d5c2c4e7e6"},
                    {name:"Queen's Gambit Declined", eco:"D60", // Kesken
                        moves:"d2d4d7d5c2c4e7e6"},
                    {name:"Neo-Grünfeld Defence", eco:"D70",
                        moves:"d2d4g8f6c2c4g7g6b1c3d7d5"},
                    {name:"Grünfeld Defence", eco:"D80",
                        moves:"d2d4g8f6c2c4g7g6g2g3d7d5"},
                    {name:"Grünfeld, Three Knights Variation", eco:"D90",  //Kesken
                        moves:"d2d4g8f6c2c4g7g6g2g3d7d5"},
                    // E
                    {name:"Queen's Pawn Game", eco:"E00",
                        moves:"d2d4g8f6c2c4e7e6"},
                    {name:"Queen's Pawn Game", eco:"E10",
                        moves:"d2d4g8f6c2c4e7e6g1f3"},
                    {name:"Nimzo-Indian Defence", eco:"E20",
                        moves:"d2d4g8f6c2c4e7e6b1c3f8b4"},
                    {name:"Nimzo-Indian, Leningrad Variation", eco:"E30",
                        moves:"d2d4g8f6c2c4e7e6b1c3f8b4c1g5"},
                    {name:"Nimzo-Indian Defence", eco:"E40",
                        moves:"d2d4g8f6c2c4e7e6b1c3f8b4e2e3"},
                    {name:"Nimzo-Indian Defence", eco:"E50",
                        moves:"d2d4g8f6c2c4e7e6b1c3f8b4e2e3e8g8g1f3"},
                    {name:"King's Indian Defence", eco:"E60",
                        moves:"d2d4g8f6c2c4g7g6"},
                    {name:"King's Indian Defence", eco:"E70",  //Kesken
                        moves:"d2d4g8f6c2c4g7g6"},
                    {name:"King's Indian Defence, Sämisch Variation", eco:"E80",  //Kesken
                        moves:"d2d4g8f6c2c4g7g6c1c3f8g7e2e4d7d6f2f3"},
                    {name:"King's Indian Defence", eco:"E90",  //Kesken
                        moves:"d2d4g8f6c2c4g7g6"},
                    {name:"King's Indian, Classical Variation", eco:"E92",
                        moves:"d2d4g8f6c2c4g7g6b1c3f8g7e2e4d7d6g1f3e8g8f1e2e7e5"},
                    // Test
                    {name:"Riku test 1", eco:"R01",
                        moves:"a2a4h7h6"},
                    {name:"Riku test 2", eco:"R02", //For white enpassant testing
                        moves:"e2e4g8f6b1c3e7e6e4e5d7d5"},
                    {name:"Riku test 3", eco:"R03", //For black enpassant testing
                        moves:"g1f3e7e5e2e3e5e4d2d4"},
                    {name:"Riku test 4", eco:"R04", //To help white to win, testing
                        moves:"d2d4c7c6c1f4d8c7f4c7g8f6c7b8"},
                    {name:"Riku test 5", eco:"R05", //to help black to win, testing
                        moves:"e2e3b7b5d1f3c8b7b1c3b7f3d2d4"}
                ]
            }

            Item {
                id : vuoro
                function vaihdaMustalle() {
                    if (tilat.musta == true) {} else {
                        startti.timeAsetus();
                        tilat.musta = !tilat.musta; tilat.valko = !tilat.valko;
                        whiteTimeTotal_temp = whiteTimeTotal;
                        valkokello.timeValko();
                        valkokello.updateValko();
                        feni.feniWhite = false;
                        feni.feniBlack = true;
                        feni.feniBlackReady = true;
                    }
                }
                function vaihdaValkealle() {
                    if (tilat.valko == true) {} else {
                        startti.timeAsetus();
                        tilat.musta = !tilat.musta; tilat.valko = !tilat.valko;
                        blackTimeTotal_temp = blackTimeTotal;
                        muttakello.timeMutta();
                        muttakello.updateMutta();
                        feni.feniWhite = true
                        feni.feniBlack = false;
                        feni.feniWhiteReady = true;
                    }
                }
            }

            Item {
                id : tilat
                property bool musta
                property bool valko
                property bool juoksee
                property bool pelialkoi : false
                property bool peliloppui : false
                function asetaTilat() {
                    musta = false
                    valko = true
                    juoksee = false
                    pelialkoi = false
                }
                function vaihdaTila() {
                    if (pelialkoi == true && juoksee == true)  { aloitapause = qsTr("Pause")} else {aloitapause = qsTr("Continue")
                    }
                }
                function aloitaPeli() {
                    if (!pelialkoi) {
                        asetaTilat();
                        pelialkoi = true}
                    else {pelialkoi = true}
                }
                function peliLoppui() {
                    peliloppui= true;
                    tilat.aloitaPeli();
                    tilat.juoksee = !tilat.juoksee;
                    startti.timeAsetus();
                    valkokello.timeValko();
                    muttakello.timeMutta();
                    tilat.vaihdaTila();
                    maharollisuuret = qsTr("Reset")

                }
            }

            Item {
                id : muttakello
                property int label_sekuntitm
                property int label_minuutitm : mustamax/60
                function timeMutta() {
                    blackTimeAccum0 = blackTimeAccum0 + blackTimeAccum-increment*1000;
                    conTcpSrv.stime = blackTimeAccum0 + increment*1000;
                    pauseMillsecs = 0
                }
                function updateMutta() {
                    kello.timeChanged();
                    if (blackTimeTotal/1000 > mustamax) {
                        tilat.peliloppui = true;
                        tilat.peliLoppui()
                    }
                    else {
                        blackTimeAccum = pureMillsecs + pauseMillsecs;
                        blackTimeTotal = blackTimeAccum0 + blackTimeAccum;
                        label_sekuntitm = (mustamax*1000 - (blackTimeTotal-blackTimeTotal%1000))/1000%60;
                        label_minuutitm = (mustamax*1000 - (blackTimeTotal-blackTimeTotal%1000)-label_sekuntitm*1000)/60000;
                        label_time_b = label_minuutitm + ":" + (label_sekuntitm < 10 ? "0" : "") + label_sekuntitm
                    }
                }
            }

            Item {
                id : valkokello
                property int label_sekuntitv
                property int label_minuutitv : valkomax/60
                function timeValko() {
                    whiteTimeAccum0 = whiteTimeAccum0 + whiteTimeAccum-increment*1000;
                    conTcpSrv.stime = whiteTimeAccum0 + increment*1000;
                    pauseMillsecs = 0
                }
                function updateValko() {
                    kello.timeChanged();
                    if (whiteTimeTotal/1000 > valkomax) {
                        tilat.peliloppui = true;
                        tilat.peliLoppui()
                    }
                    else {
                        whiteTimeAccum = pureMillsecs  + pauseMillsecs;
                        whiteTimeTotal = whiteTimeAccum0 + whiteTimeAccum;
                        label_sekuntitv = (valkomax*1000 - (whiteTimeTotal-whiteTimeTotal%1000))/1000%60;
                        label_minuutitv = (valkomax*1000 - (whiteTimeTotal-whiteTimeTotal%1000)-label_sekuntitv*1000)/60000;
                        label_time_w = label_minuutitv + ":" + (label_sekuntitv < 10 ? "0" : "") + label_sekuntitv
                    }
                }
            }

            Item {
                id : startti
                property int days0
                property int hours0
                property int minutes0
                property int sekuntit0
                property int millsec0
                property string dateTag: "1.9.2015"
                function timeAsetus() {
                    var date0 = new Date;
                    days0 = date0.getDay();
                    hours0 = date0.getHours()
                    minutes0 = date0.getMinutes()
                    sekuntit0= date0.getSeconds()
                    dateTag = date0.getFullYear() + "." + ((date0.getMonth()+1)<10 ? "0":"") +(date0.getMonth()+1)
                            + "." + ((date0.getDate())<10 ? "0":"") + date0.getDate();
                    millsec0 = date0.getMilliseconds();
                    pureMillsec0 = millsec0 + sekuntit0*1000 + minutes0*60*1000 + hours0*60*60*1000 + days0*24*60*60*1000;
                }
            }

            /*Item {
                id : asetussivulle
                function siirrytKo() {
                    // Nollaus
                    if (tilat.pelialkoi == true) {
                        maharollisuuret = qsTr("Settings");
                        tilat.asetaTilat();
                        valkomax = 300;
                        mustamax = 300;
                        valkokello.sekuntitv0 = 0;
                        valkokello.sekuntitv = 0;
                        muttakello.sekuntitm0 = 0;
                        muttakello.sekuntitm = 0;
                        kello.sekuntit = 0;
                        startti.timeAsetus();
                        valkokello.updateValko();
                        muttakello.updateMutta();
                        tilat.peliloppui = false
                        // Siirtyminen asetussivulle
                    } else {
                        valkokello.sekuntitv0 = 0;
                        valkokello.sekuntitv = 0;
                        muttakello.sekuntitm0 = 0;
                        muttakello.sekuntitm = 0;
                        kello.sekuntit = 0;
                        tilat.peliloppui = false;
                        pageStack.push(Qt.resolvedUrl("Settings.qml"))
                    }
                }
            }*/

            Item {
               id : kello
               property int days
               property int hours
               property int minutes
               property int sekuntit
               property int seconds
               property int millsecs
               function timeChanged() {
                   var date = new Date;
                   days = date.getDay();
                   hours = date.getHours();
                   minutes = date.getMinutes();
                   seconds= date.getSeconds();
                   millsecs = date.getMilliseconds();
                   pureMillsecs = millsecs + seconds*1000 + minutes*60*1000 + hours*60*60*1000 + days*24*60*60*1000 -pureMillsec0;
               }
           }

            Item {
                id: kripti //Script adds the pieces to the galeryModel
                property int koo: 0
                property int aksa: 1
                property int yyy: 1
                function lisaa() {
                    while (koo<64) {
                        switch(koo) {
                        case 0:
                        case 7:
                            galeryModel.set(koo,{"color":"b", "piece":piePat + "r.png", "frameop": 0, "recmove": -2});
                            koo=koo+1;
                            break;
                        case 1:
                        case 6:
                            galeryModel.set(koo,{"color":"b", "piece":piePat + "n.png", "frameop": 0, "recmove": -2});
                            koo=koo+1;
                            break;
                        case 2:
                        case 5:
                            galeryModel.set(koo,{"color":"b", "piece":piePat + "b.png", "frameop": 0, "recmove": -2});
                            koo=koo+1;
                            break;
                        case 3:
                            galeryModel.set(koo,{"color":"b", "piece":piePat + "q.png", "frameop": 0, "recmove": -2});
                            koo=koo+1;
                            break;
                        case 4:
                            galeryModel.set(koo,{"color":"b", "piece":piePat + "k.png", "frameop": 0, "recmove": -2});
                            koo=koo+1;
                            break;
                        case 8:
                        case 9:
                        case 10:
                        case 11:
                        case 12:
                        case 13:
                        case 14:
                        case 15:
                            galeryModel.set(koo,{"color":"b", "piece":piePat + "p.png", "frameop": 0, "recmove": -2});
                            koo=koo+1;
                            break;
                        case 48:
                        case 49:
                        case 50:
                        case 51:
                        case 52:
                        case 53:
                        case 54:
                        case 55:
                            galeryModel.set(koo,{"color":"w", "piece":piePat + "P.png", "frameop": 0, "recmove": -2});
                            koo=koo+1;
                            break;
                        case 56:
                        case 63:
                            galeryModel.set(koo,{"color":"w", "piece":piePat + "R.png", "frameop": 0, "recmove": -2});
                            koo=koo+1;
                            break;
                        case 57:
                        case 62:
                            galeryModel.set(koo,{"color":"w", "piece":piePat + "N.png", "frameop": 0, "recmove": -2});
                            koo=koo+1;
                            break;
                        case 58:
                        case 61:
                            galeryModel.set(koo,{"color":"w", "piece":piePat + "B.png", "frameop": 0, "recmove": -2});
                            koo=koo+1;
                            break;
                        case 59:
                            galeryModel.set(koo,{"color":"w", "piece":piePat + "Q.png", "frameop": 0, "recmove": -2});
                            koo=koo+1;
                            break;
                        case 60:
                            galeryModel.set(koo,{"color":"w", "piece":piePat + "K.png", "frameop": 0, "recmove": -2});
                            koo=koo+1;
                            break;
                        default:
                            galeryModel.set(koo,{"color":"e", "piece":piePat + "empty.png", "frameop": 0, "recmove": -2});
                            koo=koo+1;
                    }
                    }
                }
            }

            Item {
                id:moveMent
                //property int indeksi;
                //property int toHelpIndex; //for checking empty midsquares for bishop, rook and queen
                //property int wenpassant: -1; //White gives enpassant possibility, board index number
                //property int benpassant: -1; //Black gives enpassant possibility, board index number
                //property string itemTobemoved;
                //property string colorTobemoved;
                //property string itemMoved;
                //property string colorMoved;
                //property bool canBemoved: false; //True if the piece can be moved somewhere
                //property bool moveLegal: false; //True if the move to the destination is possible
                //property int intLegal: -1; //this is an unneeded variable
                //property bool moveLegalHelp; //for checking empty midsquares for bishop, rook and queen
                //property int rowfromInd; // This ind to help diagonal moves checks
                //property int colfromInd; // This ind to help diagonal moves checks
                //property int rowtoInd; // This ind to help diagonal moves checks
                //property int coltoInd; // This ind to help diagonal moves checks
                //property int fromParity; // This ind to help diagonal moves checks
                //property int toParity; // This ind to help diagonal moves checks
                //property bool chessTest: false; // Flag if chess is tested, prevents pawn promotion
                //property bool castlingWpossible: true; // Check if White castling is possible
                //property bool castlingBpossible: true; // Check if Black castling is possible
                //property string currentMove: ""; // Values castling, wenpassant or promotion
                //property bool wKingMoved: false; // To record this for castling checks
                //property bool bKingMoved: false; // To record this for castling checks
                //property int midSquareInd  // Used for castling test
                //property bool midSquareCheckki: false; // Used for castling check
                // Pawn is promoted to queen now
                function pawnPromotion() {
                    Qt.createComponent("Promotion.qml").createObject(page, {});
                    // one possibility to have the pawnpromotion dialog
                }
                ///////////////////////////////////////////////////////////////////////////
                // This function checks if fromIndex and toIndex are on same color
                ///////////////////////////////////////////////////////////////////////////
                function sameColor() {
                    rowfromInd = 8-(fromIndex-fromIndex%8)/8;
                    colfromInd = fromIndex%8+1;
                    fromParity = (rowfromInd + colfromInd)%2;
                    rowtoInd = 8-(toIndex-toIndex%8)/8;
                    coltoInd = toIndex%8+1;
                    toParity = (rowtoInd + coltoInd)%2;
                }

/*                /////////////////////////////////////////////////////////////////////
                // Function isMovable() checks whether the square has a movable piece
                /////////////////////////////////////////////////////////////////////

                function isMovable(_doVisual) {
                    console.log(_doVisual)
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
                }  */
                ////////////////////////////////////////
                // This function determines legal moves
                ////////////////////////////////////////

                /*function isLegalmove_old() {
                    switch (itemMoved) {
                    case piePat + "p.png":  // Black pawn
                        // Normal move
                        if (((fromIndex-toIndex) == -8) && galeryModel.get(toIndex).color === "e") {
                            moveLegal = true; intLegal = 1;
                            if (toIndex > 55 && !chessTest) {
                                waitPromo = true
                                turnWhite = false
                                pawnPromotion();
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
                                    pawnPromotion()
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
                                pawnPromotion()
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
                                    pawnPromotion()
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
*/
                // end block isMovable:

                ////////////////////////////////////////////
                /// Function movePiece()
                ////////////////////////////////////////////////////

                function movePiece() {
                    if (!moveStarted) { //Need for global property??
                        fromIndex=indeksi;
                        toIndex=indeksi;
                        var doVisual = 1 //Determines that is not test to enable visual effects
                        Mymove.isMovable(doVisual);
                        if (canBemoved){
                            itemMoved=itemTobemoved;
                            moveStarted=!moveStarted;
                            colorMoved=colorTobemoved;
                            canBemoved=false;
                        }
                    }
                    else {
                        toIndex=indeksi;
                        galeryModel.set(fromIndex,{"frameop":0}); // Better performance needed
                        // here fomParity and toParity checks
                        sameColor(); // Checks if fromIndex and toIndex are same color
                        Mymove.isLegalmove();
                        if (moveLegal){
                            // Saving position before move to possiple cancellation of a move
                            movedPieces.set(0,{"color":colorMoved, "piece":itemMoved, "indeksos":fromIndex}) //Piece moved
                            movedPieces.set(1,{"color":galeryModel.get(toIndex).color, "piece":galeryModel.get(toIndex).piece, "indeksos":toIndex}) //Piece captured
                            if (currentMove === "") {
                                movedPieces.set(2,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                                movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                            }
                            if (wenpassant <0 && benpassant<0) {
                                movedPieces.set(4,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                            }

                            galeryModel.set(toIndex,{"color":colorMoved, "piece":itemMoved})
                            galeryModel.set(fromIndex,{"color":"e", "piece":piePat + "empty.png"})
                            moveStarted=!moveStarted;
                            moveLegal=false;
                            if (tilat.valko) {
                                if (playMode == "stockfish") {feni.feniWhite = false;} //Check also in othDevice mode??
                                if (benpassant > 0 && galeryModel.get(benpassant).color === "bp") {
                                    galeryModel.set(benpassant,{"color":"e", "piece":piePat + "empty.png"});
                                    benpassant = -1
                                }
                                if (itemMoved == piePat + "K.png") {
                                    feni.feniWkingInd = toIndex;
                                }
                            }
                            else {
                                // why not here the check as above feni.feniBlack = false;
                                if (wenpassant > 0 && galeryModel.get(wenpassant).color === "wp") {
                                    galeryModel.set(wenpassant,{"color":"e", "piece":piePat + "empty.png"});
                                    wenpassant = -1
                                }
                                if (itemMoved == piePat + "k.png") {
                                    feni.feniBkingInd = toIndex;
                                }
                            }
                            if (currentMove == "promotion"){
                                promotionWaiter.start()
                            }
                            else {
                            feni.forChessCheck = true; //starts the chess check timer
                            chessChecker.start()
                            }
                        }
                    }
                }
            }

/// End block movePiece()

            ListModel {
                    id: galeryModel
                    ListElement {
                        color: "e"
                        piece: "empty.png"
                        frameop: 0
                        recmove: -1
                    }
            }

            ListModel {
                    id: movedPieces
                    ListElement {
                        color: "e"
                        piece: "empty.png"
                        indeksos: -1
                    }
            }

            // A model to save all the moves to be able to break and back the game
            ListModel {
                id:allMoves
                ListElement {
                    moveNo:0 // First no in game is 1
                    movedColor:"b" // Zero move set for black to enable backing until to the first move
                    movedPiece:"k.png"
                    movedFrom:-1
                    capturedColor:"b"
                    capturedPiece: "k.png"
                    capturedTo:-1 //Index of a piece captured
                    pairColor:"w" // Used in enpassant and castling where more than one is moved/affected
                    pairPiece: "k.png"
                    pairFrom:-1 // Index where pair is moved from
                    pairCapturesColor:"b"
                    pairCaptures: "k.png"
                    pairTo:-1 // Index where pair is moved to
                    enpColor:"e" // Color of the cell giving enpassant possibility
                    enpPiece: "empty.png"
                    enpInd:-1 //Grid index
                    wKingInd: 60 // White king index
                    bKingInd: 4 // Black king index
                    wkingmoved: false // Record if white king is moved
                    bkingmoved: false // Record if black king is moved
                    wcastlingPos: true // White castling possible
                    bcastlingPos: true // Black castling possible
                    whiteTimeMove: 0 // White player time at the end of the move
                    blackTimeMove: 0 // Black player time at the end of the move
                    whiteCapturedCount: 0 // Initial try to solve captured List
                    blackCapturedCount: 0 // Initial try to solve captured List
                }

            }

            BackgroundItem {
                id: upperBar
                width: page.width
                height: Screen.height == 1280 ? 222 : (Screen.height == 2048 ? 254 : (Screen.height == 1920 ? 338 : 164))
                enabled: false //tilat.juoksee && tilat.valko
                onClicked: vuoro.vaihdaMustalle()
                PageHeader {
                    id: phead
                    title: qsTr("Chess board")
                }
                ProgressBar {
                    id: progressBar2
                    width: parent.width
                    maximumValue: isMyStart ? mustamax : valkomax
                    //valueText: isMyStart ? (muttakello.label_minuutitm + ":" + (muttakello.label_sekuntitm < 10 ? "0" : "") + muttakello.label_sekuntitm)  : (valkokello.label_minuutitv + ":" + (valkokello.label_sekuntitv < 10 ? "0" : "") + valkokello.label_sekuntitv)
                    valueText: isMyStart ? label_time_b  : label_time_w
                    label: qsTr("min:s")
                    //value: isMyStart ? mustamax + increment - blackTimeTotal/1000 : valkomax + increment - whiteTimeTotal/1000
                    value: isMyStart ? mustamax - blackTimeTotal/1000 : valkomax - whiteTimeTotal/1000
                    rotation: 180
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: Screen.height == 1920 ? 40 : 30
                    Timer {
                        interval: 100
                        running: tilat.juoksee && Qt.application.active && (isMyStart ? tilat.musta : tilat.valko)
                        repeat: true
                        onTriggered: isMyStart ? muttakello.updateMutta() : valkokello.updateValko()
                    }
                }
            }

            BackgroundItem {
                id: uppMessageArea
                width: page.width
                height: page.width/15

                Text {
                    id: upperNotes
                    text: feni.upperMessage
                    visible:feni.upperMessage != ""
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    verticalAlignment: Text.AlignTop
                    horizontalAlignment: Text.AlignHCenter
                    rotation:180
                    width: parent.width
                    height: Screen.height == 2048 ? 66 : page.width/15
                }

                GridView {
                    id:upperMessageGrid
                    cellWidth: Screen.height == 2048 ? 66 : page.width/15
                    cellHeight: Screen.height == 2048 ? 66 : page.width/15
                    anchors.fill: parent
                    visible:feni.upperMessage == ""
                    model:isMyStart ? whiteCaptured : blackCaptured
                    delegate: Rectangle {
                        height:upperMessageGrid.cellHeight
                        width: upperMessageGrid.cellWidth
                        visible: isMyStart ? index < allMoves.get(movesNoScanned).whiteCapturedCount: index < allMoves.get(movesNoScanned).blackCapturedCount
                        color: "#dddea1"
                        Image {
                            source: captured
                            rotation: isMyStart ? 0 : 180
                            sourceSize.width: upperMessageGrid.cellWidth
                            sourceSize.height: upperMessageGrid.cellHeight
                        }
                    }
                }
            }

            BackgroundItem {height:10}

            ListModel {
                id:blackCaptured
                ListElement {
                captured: "images/piece0/q.png"
                }
            }

            Rectangle {
                id:gridBackround
                height: Screen.height == 2048 ? 1248 : parent.width
                //height: Screen.sizeCategory >= Screen.Large ?
                width:Screen.height == 2048 ? 1248 : parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                //width: Screen.width
                Image {
                    // Light color dddea1, dark color 997400
                    id: backround
                    source: piePat + "grid.png"
                    width: parent.width
                    height: parent.width
                }
                GridView {
                    id: grid
                    cellWidth: parent.width / 8
                    cellHeight: parent.width / 8
                    anchors.fill: parent
                    layoutDirection: isMyStart ? Qt.LeftToRight : Qt.RightToLeft
                    verticalLayoutDirection: isMyStart ? GridView.TopToBottom : GridView.BottomToTop
                    model: galeryModel
                    delegate: Image {
                        asynchronous: true
                        source:  piece
                        rotation: isMyStart ? 180 : 0
                        sourceSize.width: grid.cellWidth
                        sourceSize.height: grid.cellHeight

                        Image {
                            asynchronous: true
                            source: piePat + "framemoved.png"
                            visible: recmove > 0
                            opacity: (opsi.movesTotal - recmove) < 1 ? 100 : 0
                            sourceSize.width: grid.cellWidth
                            sourceSize.height: grid.cellHeight
                        }
                        Image {
                            asynchronous: true
                            source: piePat + "frame.png"
                            opacity: frameop
                            sourceSize.width: grid.cellWidth
                            sourceSize.height: grid.cellHeight
                        }
                        MouseArea {
                            anchors.fill: parent
                            height: grid.cellHeight
                            width: grid.cellWidth
                            enabled: (feni.feniWhite && isMyStart || feni.feniBlack && !isMyStart || playMode == "human") && tilat.juoksee
                            onClicked: {indeksi = index;
                                itemTobemoved = piece;
                                colorTobemoved = color;
                                moveMent.movePiece();
                            }
                        } //end MouseArea
                    } // end Image
                } // end GridView
            } //end Rectangle


            Timer{
                id: promotionWaiter
                running: false
                repeat:true
                interval:100
                onTriggered: {
                    if (!waitPromo) {
                        promotionWaiter.running = false
                        feni.forChessCheck = true
                        galeryModel.set(toIndex,{"color":colorMoved, "piece":promotedLong})
                        galeryModel.set(fromIndex,{"color":"e", "piece":piePat + "empty.png"})
                        chessChecker.start()
                    }
                    else { }
                }
            }

            Timer {
                id:chessChecker
                interval: 100;
                running: feni.forChessCheck && Qt.application.active && !waitPromo;
                repeat: false
                onTriggered: {
                    if (currentMove == "castling") {
                        Myfunks.midSquareCheck();
                    }
                    else {
                        feni.midSquareTestDone = true;
                    }

                    Myfunks.isChess();
                    feni.forChessCheck = false;
                    itemMover.start()
                }
            }
            Timer {
                id:itemMover
                interval: 100; running: feni.midSquareTestDone && feni.chessTestDone && Qt.application.active && !waitPromo;
                repeat: false
                onTriggered: {
                    if (midSquareCheckki || feni.chessIsOn) {
                        Myfunks.cancelMove();
                    }
                    else {
                        Myfunks.doMove();
                        galeryModel.set(fromIndex,{"recmove":opsi.movesTotal});
                        galeryModel.set(toIndex,{"recmove":opsi.movesTotal});
                    }
                    feni.midSquareTestDone = false;
                    feni.chessTestDone = false;

                    //                    feni.chessIsOn = false;
                }
            }

            /// Timer stockfish plays black
            /// Either sends the move for stockfish analysis or only pushes it to the end of the vector if in opening

            Timer {
                interval: 500;
                running: playMode == "stockfish" && feni.feniBlackReady && Qt.application.active && isMyStart;
                repeat: false
                onTriggered: {
                    if (opsi.openingPossible) {
                        hopo.innio();
                        hopo.test = opsi.openingSelected.slice(4*opsi.movesTotal,4*opsi.movesTotal+4);
                        hopo.innio();
                    }
                    else {
                        hopo.inni();
                    }
                    feni.feniBlackReady = false;
                    feni.feniBlackReady2 = true;
                    blackTimer.start()
                }
            }

            /// Timer stockfish plays White
            Timer {
                interval: 500;
                running: playMode == "stockfish" && feni.feniWhiteReady && Qt.application.active && tilat.pelialkoi && !isMyStart;
                repeat: false
                onTriggered: {
                    if (opsi.openingPossible) {
                        hopo.innio();
                        hopo.test = opsi.openingSelected.slice(4*opsi.movesTotal,4*opsi.movesTotal+4);
                        hopo.innio();
                    }
                    else if (feni.stockfishFirstmove == true) {
                        if (openingMode == 0 ){
                            // Random winning openings from Finnish game statistics december 2014, www.shakki.net
                            var rand = Math.random()
                            if (rand < 0.43){hopo.test = "e2e4"}
                            else if (rand > 0.43 && rand < 0.83) {hopo.test = "d2d4"}
                            else if (rand > 0.83 && rand < 0.92) {hopo.test = "c2c4"}
                            else if (rand > 0.92) {hopo.test = "g1f3"}
                            else {hopo.test = "b1c3"}
                            hopo.innio()
                        }
                        else if (openingMode == 1) {
                            // Random first move from the list of  ECO openings
                            opsi.rantomi = Math.random()*opsi.openings.length;
                            opsi.tymp = opsi.openings[opsi.rantomi].moves
                            hopo.test = opsi.tymp.slice(0,4)
                            hopo.innio()
                        }
                        else if (openingMode == 2) {
                            for(var i = 0; i < opsi.openings.length; i++){
                                if (opsi.openings[i].eco === openingECO) {
                                    opsi.tymp = opsi.openings[i].moves
                                    hopo.test = opsi.tymp.slice(0,4)
                                }
                            }
                            hopo.innio()
                        }
                        else if (openingMode == 3) {
                            hopo.test = openingGameMoves.slice(0,4)
                            hopo.innio()
                        }
                    }

                    else {
                        hopo.inni();
                    }
                    feni.feniWhiteReady = false;
                    feni.feniWhiteReady2 = true;
                    whiteTimer.start()
                }
            }

            /// Timer Stockfish plays black

            Timer {
                id:blackTimer
                interval: (stockfishMovetime*1000 + 120);
                running: playMode == "stockfish"&& feni.feniBlackReady2 && isMyStart && Qt.application.active;
                repeat: false
                onTriggered: {
                    if (!opsi.openingPossible) {
                        hopo.outti();
                    }
                    Myfunks.fenToGRID()
                    // Saving moves for captured pieces //Possible BUG in fast play in next line, could be related to narrow timeslot where you can select piece on opponents turn. Have to follow
                    movedPieces.set(0,{"color":galeryModel.get(fromIndex).color, "piece":galeryModel.get(fromIndex).piece, "indeksos":fromIndex}) //Piece moved
                    movedPieces.set(1,{"color":galeryModel.get(toIndex).color, "piece":galeryModel.get(toIndex).piece, "indeksos":toIndex}) //Piece captured
                    movedPieces.set(2,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                    movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                    movedPieces.set(4,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values

                    galeryModel.set(toIndex,{"color":galeryModel.get(fromIndex).color, "piece":galeryModel.get(fromIndex).piece})
                    galeryModel.set(fromIndex,{"color":"e", "piece":piePat + "empty.png"})
                    // If castling, moving the rook also
                    if (Math.abs(toIndex-fromIndex)==2 && galeryModel.get(toIndex).piece === piePat + "k.png") {
                        if (toIndex == 6){
                            galeryModel.set(5,{"color":"b", "piece":piePat + "r.png"})
                            galeryModel.set(7,{"color":"e", "piece":piePat + "empty.png"})
                            movedPieces.set(2,{"color":"b", "piece":piePat + "r.png", "indeksos":7})
                            movedPieces.set(3,{"color":"e", "piece":piePat + "empty.png", "indeksos":5})
                        }
                        else {
                            galeryModel.set(3,{"color":"b", "piece":piePat + "r.png"})
                            galeryModel.set(0,{"color":"e", "piece":piePat + "empty.png"})
                            movedPieces.set(2,{"color":"b", "piece":piePat + "r.png", "indeksos":0})
                            movedPieces.set(3,{"color":"e", "piece":piePat + "empty.png", "indeksos":3})
                        }
                    }
                    // If blacks move gives enpassant possibility to whiteTimer
                    if (((fromIndex-toIndex) == -16) && galeryModel.get(toIndex).piece === piePat + "p.png") {
                        benpassant = toIndex-8;
                        galeryModel.set(benpassant,{"color":"bp"})
                        movedPieces.set(4,{"color":"bp", "piece":piePat + "empty.png", "indeksos":benpassant}) //Set enpassant values
                    }
                    // If white gives enpassant possibility and it is utilized let's print a board accordingly
                    if (toIndex != -1 && toIndex == wenpassant && galeryModel.get(toIndex).piece === piePat + "p.png") {
                        galeryModel.set((toIndex-8),{"color":"e", "piece":piePat + "empty.png"});
                        currentMove = "enpassant";
                        movedPieces.set(2,{"color":"w", "piece":piePat + "P.png", "indeksos":toIndex-8})
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
                        movedPieces.set(2,{"color":"b", "piece":piePat + "p.png", "indeksos":fromIndex})
                    }
                    feni.lowerMessage = "";
                    feni.upperMessage = "";
                    Mytab.addMove();
                    vuoro.vaihdaValkealle();
                    Myfunks.isChessPure();
                    movesDone = movesDone + opsi.recentMove; // Adding the move for openings comparison
                    opsi.movesTotal++;
                    galeryModel.set(fromIndex,{"recmove":opsi.movesTotal});
                    galeryModel.set(toIndex,{"recmove":opsi.movesTotal});
                    feni.feniBlackReady2 = false;
                    // Recording move to the allMoves list
                    allMoves.append({"moveNo":opsi.movesTotal})
                    Myfunks.recordMove();
                    movesNoScanned = opsi.movesTotal;
                    whiteMatetimer.start();
                }
            }

            ///
            /// Symmetric timer for Stockfish white start
            ///


            Timer {
                id: whiteTimer
                interval: (stockfishMovetime*1000 + 120);
                running: playMode == "stockfish"&& feni.feniWhiteReady2 && !isMyStart && Qt.application.active && tilat.pelialkoi;
                repeat: false
                onTriggered: {
                    if (feni.stockfishFirstmove == true) {
                        feni.stockfishFirstmove = false
                    }

                    else if (!opsi.openingPossible) {
                        hopo.outti();
                    }
                    else {}

                    Myfunks.fenToGRID()
                    // Saving moves for captured pieces
                    movedPieces.set(0,{"color":galeryModel.get(fromIndex).color, "piece":galeryModel.get(fromIndex).piece, "indeksos":fromIndex}) //Piece moved
                    movedPieces.set(1,{"color":galeryModel.get(toIndex).color, "piece":galeryModel.get(toIndex).piece, "indeksos":toIndex}) //Piece captured
                    movedPieces.set(2,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                    movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                    movedPieces.set(4,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values

                    galeryModel.set(toIndex,{"color":galeryModel.get(fromIndex).color, "piece":galeryModel.get(fromIndex).piece})
                    galeryModel.set(fromIndex,{"color":"e", "piece":piePat + "empty.png"})
                    // If castling, moving the rook also
                    if (Math.abs(toIndex-fromIndex)==2 && galeryModel.get(toIndex).piece === piePat + "K.png") {
                        if (toIndex == 62){
                            galeryModel.set(61,{"color":"w", "piece":piePat + "R.png"})
                            galeryModel.set(63,{"color":"e", "piece":piePat + "empty.png"})
                            movedPieces.set(2,{"color":"w", "piece":piePat + "R.png", "indeksos":63})
                            movedPieces.set(3,{"color":"e", "piece":piePat + "empty.png", "indeksos":61})
                        }
                        else {
                            galeryModel.set(59,{"color":"w", "piece":piePat + "R.png"})
                            galeryModel.set(56,{"color":"e", "piece":piePat + "empty.png"})
                            movedPieces.set(2,{"color":"w", "piece":piePat + "R.png", "indeksos":56})
                            movedPieces.set(3,{"color":"e", "piece":piePat + "empty.png", "indeksos":59})
                        }
                    }
                    // If whites move gives enpassant possibility to blackTimer
                    if (((fromIndex-toIndex) == 16) && galeryModel.get(toIndex).piece === piePat + "P.png") {
                        wenpassant = toIndex+8
                        galeryModel.set(wenpassant,{"color":"wp"})
                        movedPieces.set(4,{"color":"wp", "piece":piePat + "empty.png", "indeksos":wenpassant}) //Set enpassant values
                    }
                    // If black gives enpassant possibility and it is utilized let's print a board accordingly
                    if (toIndex != -1 && toIndex == benpassant && galeryModel.get(toIndex).piece === piePat + "P.png") {
                        galeryModel.set((toIndex+8),{"color":"e", "piece":piePat + "empty.png"});
                        currentMove = "enpassant";
                        movedPieces.set(2,{"color":"b", "piece":piePat + "p.png", "indeksos":toIndex+8})
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
                        movedPieces.set(2,{"color":"w", "piece":piePat + "P.png", "indeksos":fromIndex})
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
                    //console.log(opsi.movesTotal)
                    allMoves.append({"moveNo":opsi.movesTotal})
                    //console.log(allMoves.get(opsi.movesTotal).moveNo)
                    Myfunks.recordMove();
                    movesNoScanned = opsi.movesTotal;
                }
            }

            Timer {
                id: whiteMatetimer
                running: false
                repeat: false
                interval: 3000
                onTriggered: {
                    //console.log("WhiteMatetimer started")
                    tilat.valko ? Myfunks.iswhiteInMate():
                    whiteMatetimer.stop()
                }
            }

            BackgroundItem {height:10}

            BackgroundItem {
                id: lowMessageArea
                width: page.width
                height: Screen.height == 2048 ? 66 : page.width/15

                Text {
                    id: lowerNotes
                    text: feni.lowerMessage
                    visible:feni.lowerMessage != ""
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    verticalAlignment: Text.AlignBottom
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                    height: page.width/15
                }

                GridView {
                    id:lowerMessageGrid
                    cellWidth: Screen.height == 2048 ? 66 : page.width/15
                    cellHeight: Screen.height == 2048 ? 66 : page.width/15
                    anchors.fill: parent
                    visible: feni.lowerMessage == ""
                    verticalLayoutDirection: GridView.BottomToTop
                    model:isMyStart ? blackCaptured: whiteCaptured
                    delegate: Rectangle {
                        height:lowerMessageGrid.cellHeight
                        width: lowerMessageGrid.cellWidth
                        visible: isMyStart ? index < allMoves.get(movesNoScanned).blackCapturedCount : index < allMoves.get(movesNoScanned).whiteCapturedCount
                        color: "#997400"
                        Image {
                            source: captured
                            rotation: isMyStart ? 0 : 180
                            sourceSize.width: lowerMessageGrid.cellWidth
                            sourceSize.height: lowerMessageGrid.cellHeight
                        }
                    }
                }
            }

            ListModel {
                id:whiteCaptured
                ListElement {
                captured: "images/piece0/Q.png"
                }
            }

            BackgroundItem {
                id: lowerBar
                width: page.width
                // height (Screen.height-Screen.width)/2-10-Screen.width/15-140
                // Tablet height (2048-1248)/2-10-66-140
                height: Screen.height == 1280 ? 222 : (Screen.height == 2048 ? 184 : (Screen.height == 1920 ? 198 : 164))
                enabled: false //tilat.juoksee && tilat.musta
                onClicked: vuoro.vaihdaValkealle()
                ProgressBar {
                    id: progressBarm
                    width: parent.width
                    maximumValue: isMyStart ? valkomax : mustamax
                    //valueText: isMyStart ? (valkokello.label_minuutitv + ":" + (valkokello.label_sekuntitv < 10 ? "0" : "") + valkokello.label_sekuntitv) : (muttakello.label_minuutitm + ":" + (muttakello.label_sekuntitm < 10 ? "0" : "") + muttakello.label_sekuntitm)
                    valueText: isMyStart ? label_time_w : label_time_b
                    label: qsTr("min:s")
                    //value: isMyStart ? valkomax + increment - whiteTimeTotal/1000 : mustamax + increment - blackTimeTotal/1000
                    value: isMyStart ? valkomax - whiteTimeTotal/1000 : mustamax - blackTimeTotal/1000
                    Timer {interval: 100
                        //running: tilat.juoksee && tilat.musta && Qt.ApplicationActive
                        running: tilat.juoksee && Qt.application.active && (isMyStart ? tilat.valko : tilat.musta)
                        repeat: true
                        onTriggered: isMyStart ? valkokello.updateValko() : muttakello.updateMutta()}
                }
            }

            ListModel {
                id: iconSources
                ListElement{
                    iidee: "prev"
                    icons:"icon-m-previous?"
                    visibility_: true
                    modes: "stockfish"
                }
                /*ListElement{
                    icons:"icon-m-pause?"
                    visibility_: true
                }*/
                ListElement{
                    iidee: "play"
                    icons:"icon-m-play?"
                    visibility_: true
                    modes: "all"
                }
                ListElement{
                    iidee:"forw"
                    icons:"icon-m-next?"
                    visibility_: true
                    modes: "human"
                }
            }

            // Controls for the play backing and continuing
            BackgroundItem {
                height:140
                width: page.width
                GridView {
                    anchors.fill: parent
                    cellWidth: page.width / 3
                    visible: tilat.pelialkoi && !tilat.juoksee // not visible when playing
                    model:iconSources
                    delegate: Rectangle {
                        IconButton {
                            id: but_eon
                            width:page.width/3
                            visible: (visibility_ && modes === "all") || (iidee ==="prev" && (modes === playMode || playMode === "human") && movesNoScanned >0) || (iidee ==="forw" && playMode !== "othDevice" && movesNoScanned < opsi.movesTotal)
                            icon.source: "image://theme/"+icons + (pressed
                                                                   ? Theme.highlightColor
                                                                   : Theme.primaryColor)
                            onClicked: {
                                if (index==0){
                                    movesNoScanned>0 ? Myfunks.moveBack():""
                                }
                                else if (index==1){
                                    Myfunks.continueGame()
                                }
                                else {
                                    Myfunks.moveForward()
                                }
                            }
                        }
                    }

                }
            }

            Component.onCompleted: {
                aloitapause = qsTr("Start")
                kripti.lisaa()
                Mytab.clearRecent()
                movesDone = ""
                whiteCaptured.clear()
                blackCaptured.clear()
                if (playMode == "othDevice") {
                    conTcpSrv.cport = myPort;
                    conTcpCli.startClient();
                    conTcpSrv.startServer();
                    Qt.createComponent("Connbox.qml").createObject(page, {});
                }
                label_time_w = valkokello.label_minuutitv + ":" + (valkokello.label_sekuntitv < 10 ? "0" : "") + valkokello.label_sekuntitv;
                label_time_b = muttakello.label_minuutitm + ":" + (muttakello.label_sekuntitm < 10 ? "0" : "") + muttakello.label_sekuntitm
            }
// loppusulkeet
        }
    }

}
