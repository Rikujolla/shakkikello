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
import harbour.shakkikello.stockfish 1.0

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
/*            MenuItem {
                text: maharollisuuret
                onClicked: asetussivulle.siirrytKo()
                enabled: !tilat.juoksee || tilat.peliloppui
            }*/
            MenuItem {
                text: qsTr("Show moves")
                onClicked: pageStack.push(Qt.resolvedUrl("GameInfo.qml"))
            }

            MenuItem { //Start/Pause
                text: aloitapause
                enabled: !tilat.peliloppui
                onClicked: {
                    hopo.stoDepth = stockfishDepth;
                    hopo.stoMovetime = stockfishMovetime;
                    hopo.stoSkill = stockfishSkill;
                    if (!tilat.pelialkoi) {
                        if (playMode == "stockfish") {hopo.initio();}
                        kripti.lisaa();
                    }
                    tilat.aloitaPeli();
                    tilat.juoksee = !tilat.juoksee;
                    startti.timeAsetus();
                    kello.sekuntit = 0;
                    valkokello.timeValko();
                    valkokello.sekuntitv = 0;
                    muttakello.timeMutta();
                    muttakello.sekuntitm=0;
                    tilat.vaihdaTila();
                    maharollisuuret = qsTr("Reset");
                    Mytab.clearRecent()
                }
            }
        }

        contentHeight: column.height

        Stockfishe { // for Stockfish communication
            id:hopo
        }

/*        Stockfishev { // remove?
            id:hopov
        }*/

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge

            Item {
                id: feni
                property string startFeni;
                property string stopFeni;
                property bool feniReady:false;
                property int feniHelper;
                property string stringHelper;
                property bool feniBlack:false;
                property bool feniWhite:true;
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
                property string movesDone: ""; //saves done moves to single string eg. e2e4d7d5
                property string openingCompare: "";
                property string openingSelected: "";
                property string recentMove: "";
                property int movesTotal: 0; //Records moves done
                property bool openingPossible: false; // Tells if opening possible
                property int yx //index for for
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
                    {name:"Modern Benoni", eco:"A60",
                        moves:"d2d4g8f6c2c4c7c5d4d5e7e6"},
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
                    {name:"Riku test", eco:"R01",
                        moves:"a2a4h7h6"}
                ]
            }

            Item {
                id : vuoro
                function vaihdaMustalle() {
                    if (tilat.musta == true) {} else {
                        startti.timeAsetus();
                        tilat.musta = !tilat.musta; tilat.valko = !tilat.valko;
                        kello.sekuntit = 0;
                        valkokello.timeValko();
                        valkokello.sekuntitv = 0;
                        muttakello.timeMutta();
                        muttakello.sekuntitm=0;
                        valkokello.sum_incrementv = valkokello.sum_incrementv + increment;
                        valkokello.updateValko();
                        feni.feniWhite = false;
                        feni.feniReady = true;
                    }
                }
                function vaihdaValkealle() {
                    if (tilat.valko == true) {} else {
                        startti.timeAsetus();
                        tilat.musta = !tilat.musta; tilat.valko = !tilat.valko;
                        kello.sekuntit = 0;
                        valkokello.timeValko();
                        valkokello.sekuntitv = 0;
                        muttakello.timeMutta();
                        muttakello.sekuntitm=0;
                        muttakello.sum_incrementm = muttakello.sum_incrementm + increment;
                        muttakello.updateMutta();
                        feni.feniWhite = true
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
                    kello.sekuntit = 0;
                    valkokello.sekuntitv = 0;
                    valkokello.timeValko();
                    muttakello.sekuntitm=0;
                    muttakello.timeMutta();
                    tilat.vaihdaTila();
                    maharollisuuret = qsTr("Reset")

                }
            }

            Item {
                id : muttakello
                property int sekuntitm0: 0
                property int sekuntitm : 0
                property int rogres_sekuntitm : mustamax
                property int label_sekuntitm
                property int label_minuutitm : mustamax/60
                property int sum_incrementm : 0
                function timeMutta() {sekuntitm0 = sekuntitm0 + sekuntitm}
                function updateMutta() {
                    kello.timeChanged();
                    if (rogres_sekuntitm <= 0) {
                        tilat.peliloppui = true;
                        tilat.peliLoppui()
                    }
                    else {
                        sekuntitm = kello.sekuntit;
                        label_sekuntitm = (mustamax + sum_incrementm - (sekuntitm0 + sekuntitm))%60;
                        label_minuutitm = ((mustamax + sum_incrementm - (sekuntitm0 + sekuntitm))-label_sekuntitm)/60;
                        rogres_sekuntitm = mustamax + sum_incrementm - (sekuntitm0 + sekuntitm)
                    }
                }
            }

            Item {
                id : valkokello
                property int sekuntitv: 0
                property int sekuntitv0: 0
                property int rogres_sekuntitv : valkomax
                property int label_sekuntitv
                property int label_minuutitv : valkomax/60
                property int sum_incrementv : 0
                function timeValko() {sekuntitv0 = sekuntitv0 + sekuntitv}
                function updateValko() {
                    kello.timeChanged();
                    if (rogres_sekuntitv <= 0) {
                        tilat.peliloppui = true;
                        tilat.peliLoppui()
                    }
                    else {
                        sekuntitv = kello.sekuntit;
                        label_sekuntitv = (valkomax + sum_incrementv - (sekuntitv0 + sekuntitv))%60;
                        label_minuutitv = ((valkomax + sum_incrementv - (sekuntitv0 + sekuntitv))-label_sekuntitv)/60;
                        rogres_sekuntitv = valkomax + sum_incrementv - (sekuntitv0 + sekuntitv)
                    }
                }
            }

            Item {
                id : startti
                property int hours0
                property int minutes0
                property int sekuntit0
                property string dateTag: "1.9.2015"
                function timeAsetus() {
                    var date0 = new Date;
                    hours0 = date0.getHours()
                    minutes0 = date0.getMinutes()
                    sekuntit0= date0.getSeconds()
                    dateTag = date0.getFullYear() + "." + ((date0.getMonth()+1)<10 ? "0":"") +(date0.getMonth()+1)
                            + "." + ((date0.getDate())<10 ? "0":"") + date0.getDate();

                }
            }

            Item {
                id : asetussivulle
                function siirrytKo() {
                    // Nollaus
                    if (tilat.pelialkoi == true) {
                        maharollisuuret = qsTr("Settings");
                        tilat.asetaTilat();
                        valkomax = 300;
                        mustamax = 300;
                        valkokello.rogres_sekuntitv = valkomax;
                        muttakello.rogres_sekuntitm = mustamax;
                        valkokello.sekuntitv0 = 0;
                        valkokello.sekuntitv = 0;
                        valkokello.sum_incrementv = 0;
                        muttakello.sekuntitm0 = 0;
                        muttakello.sekuntitm = 0;
                        muttakello.sum_incrementm = 0;
                        kello.sekuntit = 0;
                        startti.timeAsetus();
                        valkokello.updateValko();
                        muttakello.updateMutta();
                        tilat.peliloppui = false
                        // Siirtyminen asetussivulle
                    } else {
                        valkokello.rogres_sekuntitv = valkomax;
                        muttakello.rogres_sekuntitm = mustamax;
                        valkokello.sekuntitv0 = 0;
                        valkokello.sekuntitv = 0;
                        valkokello.sum_incrementv = 0;
                        muttakello.sekuntitm0 = 0;
                        muttakello.sekuntitm = 0;
                        muttakello.sum_incrementm = 0;
                        kello.sekuntit = 0;
                        tilat.peliloppui = false;
                        pageStack.push(Qt.resolvedUrl("Asetukset.qml"))
                    }
                }
            }

            Item {
               id : kello
               property int hours
               property int minutes
               property int sekuntit
               function timeChanged() {
                   var date = new Date;
                   hours = date.getHours()-startti.hours0
                   minutes = date.getMinutes()-startti.minutes0+60*hours
                   sekuntit= date.getSeconds()-startti.sekuntit0+60*minutes
               }
           }

            Item {
                id: kripti
                property int koo: 0
                property int aksa: 1
                property int yyy: 1
                function lisaa() {
                    while (koo<64) {
                        switch(koo) {
                        case 0:
                        case 7:
                            galeryModel.set(koo,{"color":"b", "piece":"images/r.png"});
                            koo=koo+1;
                            break;
                        case 1:
                        case 6:
                            galeryModel.set(koo,{"color":"b", "piece":"images/n.png"});
                            koo=koo+1;
                            break;
                        case 2:
                        case 5:
                            galeryModel.set(koo,{"color":"b", "piece":"images/b.png"});
                            koo=koo+1;
                            break;
                        case 3:
                            galeryModel.set(koo,{"color":"b", "piece":"images/q.png"});
                            koo=koo+1;
                            break;
                        case 4:
                            galeryModel.set(koo,{"color":"b", "piece":"images/k.png"});
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
                            galeryModel.set(koo,{"color":"b", "piece":"images/p.png"});
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
                            galeryModel.set(koo,{"color":"w", "piece":"images/P.png"});
                            koo=koo+1;
                            break;
                        case 56:
                        case 63:
                            galeryModel.set(koo,{"color":"w", "piece":"images/R.png"});
                            koo=koo+1;
                            break;
                        case 57:
                        case 62:
                            galeryModel.set(koo,{"color":"w", "piece":"images/N.png"});
                            koo=koo+1;
                            break;
                        case 58:
                        case 61:
                            galeryModel.set(koo,{"color":"w", "piece":"images/B.png"});
                            koo=koo+1;
                            break;
                        case 59:
                            galeryModel.set(koo,{"color":"w", "piece":"images/Q.png"});
                            koo=koo+1;
                            break;
                        case 60:
                            galeryModel.set(koo,{"color":"w", "piece":"images/K.png"});
                            koo=koo+1;
                            break;
                        default:
                            galeryModel.set(koo,{"color":"e", "piece":"images/empty.png"});
                            koo=koo+1;
                    }
                    }
                }
            }

            Item {
                id:moveMent
                property int indeksi;
                property int toHelpIndex; //for checking empty midsquares for bishop, rook and queen
                property int wenpassant: -1;
                property int benpassant: -1
                property string itemTobemoved;
                property string colorTobemoved;
                property string itemMoved;
                property string colorMoved;
                property bool canBemoved: false; //True if the piece can be moved somewhere
                property bool moveLegal: false; //True if the move to the destination is possible
                property int intLegal: -1; //this is an unneeded variable
                property bool moveLegalHelp; //for checking empty midsquares for bishop, rook and queen
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
                // Pawn is promoted to queen now
                function pawnPromotion() {
                    //Qt.createComponent("Promotion.qml").createObject(page, {});
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

                /////////////////////////////////////////////////////////////////////
                // Function isMovable() checks whether the square has a movable piece
                /////////////////////////////////////////////////////////////////////

                function isMovable() {
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
                ////////////////////////////////////////
                // This function determines legal moves
                ////////////////////////////////////////

                function isLegalmove() {
                    switch (itemMoved) {
                    case "images/p.png":  // Black pawn
                        // Normal move
                        if (((fromIndex-toIndex) == -8) && galeryModel.get(toIndex).color == "e") {
                            moveLegal = true; intLegal = 1;
                            if (toIndex > 55 && !chessTest) {
                                pawnPromotion();
                                itemMoved = "images/q.png";
                                currentMove = "promotion";
                                movedPieces.set(2,{"color":"b", "piece":"images/p.png", "indeksos":fromIndex})
                            }
                        }
                        // Move of two rows from the start position
                        else if (((fromIndex-toIndex) == -16) && galeryModel.get(toIndex).color == "e"
                                 && galeryModel.get(toIndex-8).color == "e"
                                 && (fromIndex < 16)) {
                            moveLegal = true; intLegal = 1;
                            benpassant = toIndex-8;
                            galeryModel.set(benpassant,{"color":"bp"})
                        }
                        // Capturing a piece
                        else if (((fromIndex-toIndex) == -7) && Math.abs((toIndex+1-toIndex%8)/8-(fromIndex+1-fromIndex%8)/8) == 1
                                 || ((fromIndex-toIndex) == -9) && Math.abs((toIndex+1-toIndex%8)/8-(fromIndex+1-fromIndex%8)/8) == 1) {
                            if ((galeryModel.get(toIndex).color == "w")
                                    ){
                                moveLegal = true; intLegal = 1;
                                if (toIndex > 55 && !chessTest) {
                                    pawnPromotion()
                                    itemMoved = "images/q.png"
                                    currentMove = "promotion";
                                    movedPieces.set(2,{"color":"b", "piece":"images/p.png", "indeksos":fromIndex})
                                }
                            }
                            // En passant
                            else if (galeryModel.get(toIndex).color == "wp") {
                                moveLegal = true;
                                galeryModel.set((toIndex-8),{"color":"e", "piece":"images/empty.png"});
                                currentMove = "enpassant";
                                movedPieces.set(2,{"color":"w", "piece":"images/P.png", "indeksos":toIndex-8})
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
                    case "images/P.png":
                        // Normal move
                        if (((fromIndex-toIndex) == 8) && galeryModel.get(toIndex).color == "e") {
                            moveLegal = true; intLegal = 1;
                            if (toIndex < 8 && !chessTest) {
                                pawnPromotion()
                                itemMoved = "images/Q.png"
                                currentMove = "promotion";
                                movedPieces.set(2,{"color":"w", "piece":"images/P.png", "indeksos":fromIndex})
                            }
                        }
                        // Move of two rows from the start position
                        else if (((fromIndex-toIndex) == 16) && galeryModel.get(toIndex).color == "e"
                                 && galeryModel.get(toIndex+8).color == "e"
                                 && (fromIndex > 47)) {
                            moveLegal = true; intLegal = 1;
                            wenpassant = toIndex+8;
                            galeryModel.set(wenpassant,{"color":"wp"})
                        }
                        // Capturing a piece
                        else if (((fromIndex-toIndex) == 7) && Math.abs((toIndex+1-toIndex%8)/8-(fromIndex+1-fromIndex%8)/8) == 1
                                 || ((fromIndex-toIndex) == 9) && Math.abs((toIndex+1-toIndex%8)/8-(fromIndex+1-fromIndex%8)/8) == 1) {
                            if ((galeryModel.get(toIndex).color == "b")
                                    ){
                                moveLegal = true; intLegal = 1;
                                if (toIndex < 8 && !chessTest) {
                                    pawnPromotion()
                                    itemMoved = "images/Q.png"
                                    currentMove = "promotion";
                                    movedPieces.set(2,{"color":"w", "piece":"images/P.png", "indeksos":fromIndex})
                                }
                            }
                            // En passant
                            else if (galeryModel.get(toIndex).color == "bp") {
                                moveLegal = true;
                                galeryModel.set((toIndex+8),{"color":"e", "piece":"images/empty.png"});
                                currentMove = "enpassant";
                                movedPieces.set(2,{"color":"b", "piece":"images/p.png", "indeksos":toIndex+8})
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
                    case "images/k.png":
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
                            galeryModel.set((5),{"color":"b", "piece":"images/r.png"});
                            galeryModel.set((7),{"color":"e", "piece":"images/empty.png"});
                            currentMove = "castling";
                            castlingBpossible = false;
                            midSquareInd = 5;
                            // Saving the moved pieces and positions for a possible cancel of the move
                            movedPieces.set(2,{"color":"b", "piece":"images/r.png", "indeksos":7})
                            movedPieces.set(3,{"color":"e", "piece":"images/empty.png", "indeksos":5})
                        }
                            // Castling long
                        else if ((toIndex == 2) && galeryModel.get(2).color === "e"
                                 && galeryModel.get(3).color === "e" && galeryModel.get(1).color === "e"
                                 && fromIndex == 4
                                 && castlingBpossible && !feni.feniBlackChess
                                 && !bKingMoved) {
                            moveLegal = true; intLegal = 1;
                            galeryModel.set((3),{"color":"b", "piece":"images/r.png"});
                            galeryModel.set((0),{"color":"e", "piece":"images/empty.png"});
                            currentMove = "castling";
                            castlingBpossible = false;
                            midSquareInd = 3;
                            // Saving the moved pieces and positions for a possible cancel of the move
                            movedPieces.set(2,{"color":"b", "piece":"images/r.png", "indeksos":0})
                            movedPieces.set(3,{"color":"e", "piece":"images/empty.png", "indeksos":3})
                        }
                        else {
                                moveStarted=false;
                                fromIndex=-1;
                                toIndex=-1;
                        }
                        break;
                    case "images/K.png":
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
                                    galeryModel.set((61),{"color":"w", "piece":"images/R.png"});
                                    galeryModel.set((63),{"color":"e", "piece":"images/empty.png"});
                                    currentMove = "castling";
                                    castlingWpossible =false;
                                    midSquareInd = 61;
                                    // Saving the moved pieces and positions for a possible cancel of the move
                                    movedPieces.set(2,{"color":"b", "piece":"images/R.png", "indeksos":63})
                                    movedPieces.set(3,{"color":"e", "piece":"images/empty.png", "indeksos":61})
                            }
                            // Castling queenside
                            else if ((toIndex == 58) && galeryModel.get(58).color === "e"
                                        && galeryModel.get(59).color === "e" && galeryModel.get(57).color === "e"
                                        && fromIndex == 60
                                        && castlingWpossible && !feni.feniWhiteChess
                                        && !wKingMoved) {
                                    moveLegal = true; intLegal = 1;
                                    galeryModel.set((59),{"color":"w", "piece":"images/R.png"});
                                    galeryModel.set((56),{"color":"e", "piece":"images/empty.png"});
                                    currentMove = "castling";
                                    castlingWpossible = false;
                                    midSquareInd = 59;
                                    // Saving the moved pieces and positions for a possible cancel of the move
                                    movedPieces.set(2,{"color":"b", "piece":"images/R.png", "indeksos":56})
                                    movedPieces.set(3,{"color":"e", "piece":"images/empty.png", "indeksos":59})
                            }
                            else {
                                moveStarted=false;
                                fromIndex=-1;
                                toIndex=-1;
                            }
                        break;
                    case "images/Q.png":
                        // Same column
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
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                         || galeryModel.get(toHelpIndex).color == "bp") {
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
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                         || galeryModel.get(toHelpIndex).color == "bp") {
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
                    case "images/q.png":  // Same as Q.png but four "w"s
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
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                         || galeryModel.get(toHelpIndex).color == "bp") {
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
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                         || galeryModel.get(toHelpIndex).color == "bp") {
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
                    case "images/B.png":
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
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                         || galeryModel.get(toHelpIndex).color == "bp") {
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
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                         || galeryModel.get(toHelpIndex).color == "bp") {
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
                    case "images/b.png": // Copy of white but two color checks changed from "w" to "b" ank k.png to K.png
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
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                         || galeryModel.get(toHelpIndex).color == "bp") {
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
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                         || galeryModel.get(toHelpIndex).color == "bp") {
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
                    case "images/N.png":
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
                    case "images/n.png":
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
                    case "images/R.png":
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
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                    case "images/r.png": // Same as R.png but two "w"s changed to "b"s
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
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
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
// end block isMovable:

                ////////////////////////////////////////////
                /// Function movePiece()
                ////////////////////////////////////////////////////

                function movePiece() {
                    if (!moveStarted) { //Need for global property??
                        fromIndex=indeksi;
                        toIndex=indeksi;
                        isMovable();
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
                        isLegalmove();
                        if (moveLegal){
                            // Saving position before move to possiple cancellation od a move
                            movedPieces.set(0,{"color":colorMoved, "piece":itemMoved, "indeksos":fromIndex}) //Piece moved
                            movedPieces.set(1,{"color":galeryModel.get(toIndex).color, "piece":galeryModel.get(toIndex).piece, "indeksos":toIndex}) //Piece captured
//                            movedPieces.set(2,{"color":colorMoved, "piece":itemMoved, "indeksos":fromIndex}) //Piece enpassant or castling
                            //
                            galeryModel.set(toIndex,{"color":colorMoved, "piece":itemMoved})
                            galeryModel.set(fromIndex,{"color":"e", "piece":"images/empty.png"})
                            moveStarted=!moveStarted;
                            moveLegal=false;
                            if (tilat.valko) {
                                if (playMode == "stockfish") {feni.feniWhite = false;}
                                if (benpassant > 0 && galeryModel.get(benpassant).color == "bp") {
                                    galeryModel.set(benpassant,{"color":"e", "piece":"images/empty.png"});
                                    benpassant = -1
                                }
                                if (itemMoved == "images/K.png") {
                                    feni.feniWkingInd = toIndex;
                                }
                            }
                            else {
                                if (wenpassant > 0 && galeryModel.get(wenpassant).color == "wp") {
                                    galeryModel.set(wenpassant,{"color":"e", "piece":"images/empty.png"});
                                    wenpassant = -1
                                }
                                if (itemMoved == "images/k.png") {
                                    feni.feniBkingInd = toIndex;
                                }
                            }
                            feni.forChessCheck = true; //starts the chess check timer
                        }
                    }
                }
            }

/// End block movePiece()

            ListModel {
                    id: galeryModel
                    ListElement {
                        color: "e"
                        piece: "images/empty.png"
                        frameop: 0
                    }
            }

            ListModel {
                    id: movedPieces
                    ListElement {
                        color: "e"
                        piece: "images/empty.png"
                        indeksos: -1
                    }
            }


            BackgroundItem {
                id: upperBar
                width: page.width
                height: 155
                enabled: false //tilat.juoksee && tilat.valko
                onClicked: vuoro.vaihdaMustalle()
                PageHeader {
                    title: qsTr("Chess board")
                }
                ProgressBar {
                    id: progressBar2
                    width: parent.width
                    height: 130
                    maximumValue: isMyStart ? mustamax : valkomax
                    //valueText: valkokello.label_minuutitv + ":" + (valkokello.label_sekuntitv < 10 ? "0" : "") + valkokello.label_sekuntitv
                    valueText: isMyStart ? (muttakello.label_minuutitm + ":" + (muttakello.label_sekuntitm < 10 ? "0" : "") + muttakello.label_sekuntitm)  : (valkokello.label_minuutitv + ":" + (valkokello.label_sekuntitv < 10 ? "0" : "") + valkokello.label_sekuntitv)
                    label: qsTr("min:s")
                    value: isMyStart ? muttakello.rogres_sekuntitm : valkokello.rogres_sekuntitv
                    rotation: 180
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 35
                    Timer {
                        interval: 100
                        //running: tilat.juoksee && tilat.valko && Qt.ApplicationActive
                        running: tilat.juoksee && Qt.ApplicationActive && (isMyStart ? tilat.musta : tilat.valko)
                        repeat: true
                        onTriggered: isMyStart ? muttakello.updateMutta() : valkokello.updateValko()
                    }
                }
            }
            Text {
                id: upperNotes
                text: feni.upperMessage
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                rotation:180
                height: 8
                width: parent.width
//                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                height: parent.width
                //height: Screen.sizeCategory >= Screen.Large ?
                width:parent.width
                //width: Screen.width
                Image {
                    // Light color dddea1, dark color 997400
                    id: backround
                    source: "images/grid.png"
                    width: parent.width
                    height: parent.width
                }
                GridView {
                    id: grid
                    cellWidth: parent.width / 8
                    cellHeight: parent.width / 8
                    anchors.fill: parent
                    //layoutDirection: Qt.RightToLeft
                    layoutDirection: isMyStart ? Qt.LeftToRight : Qt.RightToLeft
                    //verticalLayoutDirection: GridView.BottomToTop
                    verticalLayoutDirection: isMyStart ? GridView.TopToBottom : GridView.BottomToTop
                    model: galeryModel
                    delegate: Image {
                        asynchronous: true
                        source:  piece
                        rotation: isMyStart ? 180 : 0
                        sourceSize.width: grid.cellWidth
                        sourceSize.height: grid.cellHeight
//                        ShaderEffect {}
/*                        Rectangle {
                            color: "blue"
                            anchors.fill: parent
                            enabled: true
                            opacity: 0.5
                        } */
                        Image {
                            asynchronous: true
                            source: "images/frame.png"
                            opacity: frameop
                            sourceSize.width: grid.cellWidth
                            sourceSize.height: grid.cellHeight
                        MouseArea {
                                anchors.fill: parent
                                height: grid.cellHeight
                                width: grid.cellWidth
                                enabled: feni.feniWhite || playMode == "human"
                                onClicked: {moveMent.indeksi = index;
                                    moveMent.itemTobemoved = piece;
                                    moveMent.colorTobemoved = color;
                                    moveMent.movePiece();
                                    //galeryModel.set(index,{"frameop":100});
                                    //hopo.stoDepth = 3;
                                }
                            }
                        }
                    } // end Image
                } // end GridView
            } //end Rectangle

            Timer {
                interval: 200; running: feni.forChessCheck && Qt.ApplicationActive; repeat: true
                onTriggered: {
                    if (moveMent.currentMove == "castling") {
                        Myfunks.midSquareCheck();
                    }
                    else {
                        feni.midSquareTestDone = true;
                    }

                    Myfunks.isChess();
                    feni.forChessCheck = false;
                }
            }
            Timer {
                interval: 300; running: feni.midSquareTestDone && feni.chessTestDone && Qt.ApplicationActive;
                repeat: true
                onTriggered: {
                    if (moveMent.midSquareCheckki || feni.chessIsOn) {
                    Myfunks.cancelMove();
                    }
                    else {
                        Myfunks.doMove();
                    }
                    feni.midSquareTestDone = false;
                    feni.chessTestDone = false;

                    //                    feni.chessIsOn = false;
                }
            }


            Timer {
                interval: 500; running: playMode == "stockfish" && feni.feniReady && Qt.ApplicationActive; repeat: false
                onTriggered: {
                    if (opsi.openingPossible) {
                        hopo.innio();
                        hopo.test = opsi.openingSelected.slice(4*opsi.movesTotal,4*opsi.movesTotal+4);
                        hopo.innio();
                    }
                    else {
                        hopo.inni();
                    }
                    feni.feniReady = false;
                    feni.feniBlack = true;
                    //console.log(Screen.width)
                }
            }

            Timer {
                interval: (stockfishMovetime*1000 + 120); running: playMode == "stockfish"&& feni.feniBlack && Qt.ApplicationActive; repeat: false
                onTriggered: {
                    if (!opsi.openingPossible) {
                        hopo.outti();
                    }
                    Myfunks.fenToGRID()
                    galeryModel.set(toIndex,{"color":galeryModel.get(fromIndex).color, "piece":galeryModel.get(fromIndex).piece})
                    galeryModel.set(fromIndex,{"color":"e", "piece":"images/empty.png"})
                    // If castling, moving the rook also
                    if (Math.abs(toIndex-fromIndex)==2 && galeryModel.get(toIndex).piece == "images/k.png") {
                        if (toIndex == 6){
                            galeryModel.set(5,{"color":"b", "piece":"images/r.png"})
                            galeryModel.set(7,{"color":"e", "piece":"images/empty.png"})
                        }
                        else {
                            galeryModel.set(3,{"color":"b", "piece":"images/r.png"})
                            galeryModel.set(0,{"color":"e", "piece":"images/empty.png"})
                        }
                    }
                    // If white gives enpassant possibility and it is utilized let's print a board accordingly
                    if (toIndex != -1 && toIndex == moveMent.wenpassant && galeryModel.get(toIndex).piece == "images/p.png") {
                        galeryModel.set((toIndex-8),{"color":"e", "piece":"images/empty.png"});
                        moveMent.wenpassant = -1;
                    }

                    // If pawn reaches the last line let's gues the promotion to be a queen. Have to correct in future some how

                    if (toIndex > 55 && galeryModel.get(toIndex).piece == "images/p.png") {
                        galeryModel.set(toIndex, {"piece": "images/q.png"});
                    }
                    feni.lowerMessage = "";
                    Mytab.addMove();
                    vuoro.vaihdaValkealle();
                    Myfunks.isChessPure();
                    opsi.movesDone = opsi.movesDone + opsi.recentMove; // Adding the move for openings comparison
                    opsi.movesTotal++;
                    feni.feniBlack = false;
                }
            }

            Text {
                id: lowerNotes
                text: feni.lowerMessage
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                height: 5
                width: parent.width
//                anchors.horizontalCenter: parent.horizontalCenter
            }

            BackgroundItem {
                id: lowerBar
                width: page.width
                height: 177
                enabled: false //tilat.juoksee && tilat.musta
                onClicked: vuoro.vaihdaValkealle()
                ProgressBar {
                    id: progressBarm
                    width: parent.width
                    maximumValue: isMyStart ? valkomax : mustamax
                    //valueText: muttakello.label_minuutitm + ":" + (muttakello.label_sekuntitm < 10 ? "0" : "") + muttakello.label_sekuntitm
                    valueText: isMyStart ? (valkokello.label_minuutitv + ":" + (valkokello.label_sekuntitv < 10 ? "0" : "") + valkokello.label_sekuntitv) : (muttakello.label_minuutitm + ":" + (muttakello.label_sekuntitm < 10 ? "0" : "") + muttakello.label_sekuntitm)
                    label: qsTr("min:s")
                    value: isMyStart ? valkokello.rogres_sekuntitv : muttakello.rogres_sekuntitm
                    Timer {interval: 100
                        //running: tilat.juoksee && tilat.musta && Qt.ApplicationActive
                        running: tilat.juoksee && Qt.ApplicationActive && (isMyStart ? tilat.valko : tilat.musta)
                        repeat: true
                        onTriggered: isMyStart ? valkokello.updateValko() : muttakello.updateMutta()}
                }
            }
// loppusulkeet
        }
    }
}
