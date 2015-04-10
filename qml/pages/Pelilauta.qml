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
import "./images"
import "funktiot.js" as Myfunks

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem { //Start/Pause
                text: aloitapause
                enabled: !tilat.peliloppui
                onClicked: {kripti.lisaa();
                    tilat.aloitaPeli();
                    tilat.juoksee = !tilat.juoksee;
                    startti.timeAsetus();
                    kello.sekuntit = 0;
                    valkokello.timeValko();
                    valkokello.sekuntitv = 0;
                    muttakello.timeMutta();
                    muttakello.sekuntitm=0;
                    tilat.vaihdaTila();
                    maharollisuuret = qsTr("Reset")
                }
            }
        }

        PushUpMenu {
//            quickSelect: true
            MenuItem {
                text: maharollisuuret
                onClicked: asetussivulle.siirrytKo()
                enabled: !tilat.juoksee || tilat.peliloppui
            }
        }

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge

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
                        muttakello.sekuntitm=0
                        valkokello.sum_incrementv = valkokello.sum_incrementv + increment
                        valkokello.updateValko()
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
                        muttakello.sekuntitm=0
                        muttakello.sum_incrementm = muttakello.sum_incrementm + increment
                        muttakello.updateMutta()
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
                function timeAsetus() {
                    var date0 = new Date;
                    hours0 = date0.getHours()
                    minutes0 = date0.getMinutes()
                    sekuntit0= date0.getSeconds()
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
                property bool moveLegalHelp; //for checking empty midsquares for bishop, rook and queen
                // Pawn is promoted to queen now
//                function pawnPromotion() {
// one possibility to have the pawnpromotion dialog
//                }

                // block isMovable:
                function isMovable() {
                    if (colorTobemoved == "b" && tilat.musta) {
                        canBemoved = true;
                    }
                    else if (colorTobemoved == "w" && tilat.valko) {
                        canBemoved = true;
                    }
                    else {
                        canBemoved = false;
                    }
                }
                function isLegalmove() {
                    switch (itemMoved) {
                    case "images/p.png":
                        // Normal move
                        if (((fromIndex-toIndex) == -8) && galeryModel.get(toIndex).color == "e") {
                            moveLegal = true;
                            if (toIndex > 55) {
                                itemMoved = "images/q.png"
                            }
                        }
                        // Move of two rows from the start position
                        else if (((fromIndex-toIndex) == -16) && galeryModel.get(toIndex).color == "e"
                                 && galeryModel.get(toIndex-8).color == "e"
                                 && (fromIndex < 16)) {
                            moveLegal = true;
                            benpassant = toIndex-8;
                            galeryModel.set(benpassant,{"color":"bp"})
                        }
                        else if (((fromIndex-toIndex) == -7) || ((fromIndex-toIndex) == -9)) {
                            if (galeryModel.get(toIndex).color == "w") {
                                moveLegal = true;
                                if (toIndex > 55) {
                                    itemMoved = "images/q.png"
                                }
                            }
                            else if (galeryModel.get(toIndex).color == "wp") {
                                moveLegal = true;
                                galeryModel.set((toIndex-8),{"color":"e", "piece":"images/empty.png"});
                                wenpassant = -1;
                            }
                            else {
                                moveStarted=false;
                                fromIndex=-1;
                                toIndex=-1;
                            }
                            //porsaanreikä rivinvaihdossa??
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
                            moveLegal = true;
                            if (toIndex < 8) {
                                itemMoved = "images/Q.png"
                            }
                        }
                        // Move of two rows from the start position
                        else if (((fromIndex-toIndex) == 16) && galeryModel.get(toIndex).color == "e"
                                 && galeryModel.get(toIndex+8).color == "e"
                                 && (fromIndex > 47)) {
                            moveLegal = true;
                            wenpassant = toIndex+8;
                            galeryModel.set(wenpassant,{"color":"wp"})
                        }
                        else if (((fromIndex-toIndex) == 7) || ((fromIndex-toIndex) == 9)) {
                            if (galeryModel.get(toIndex).color == "b") {
                                moveLegal = true;
                                if (toIndex < 8) {
                                    itemMoved = "images/Q.png"
                                }
                            }
                            else if (galeryModel.get(toIndex).color == "bp") {
                                moveLegal = true;
                                galeryModel.set((toIndex+8),{"color":"e", "piece":"images/empty.png"});
                                benpassant = -1;
                            }

                            else {
                                moveStarted=false;
                                fromIndex=-1;
                                toIndex=-1;
                            }
                            //porsaanreikä rivinvaihdossa??
                        }

                        else {
                            moveStarted=false;
                            fromIndex=-1;
                            toIndex=-1;
                        }
                        break;
                    case "images/k.png":
                        if ((((fromIndex-toIndex) == 9) || ((fromIndex-toIndex) == 8)
                              || ((fromIndex-toIndex) == 7) || ((fromIndex-toIndex) == 1)
                              || ((fromIndex-toIndex) == -1) || ((fromIndex-toIndex) == -7)
                              || ((fromIndex-toIndex) == -8) || ((fromIndex-toIndex) == -9))
                             && galeryModel.get(toIndex).color !== "b") {
                            moveLegal = true;
                        }
                        // Castling short
                        else if ((toIndex == 6) && galeryModel.get(6).color === "e"
                                  && galeryModel.get(5).color === "e") {
                            moveLegal = true;
                            galeryModel.set((5),{"color":"b", "piece":"images/r.png"});
                            galeryModel.set((7),{"color":"e", "piece":"images/empty.png"});
                            // Castling legality checks are missing
                        }
                        // Castling long
                        else if ((toIndex == 2) && galeryModel.get(2).color === "e"
                                 && galeryModel.get(3).color === "e" && galeryModel.get(1).color === "e") {
                            moveLegal = true;
                            galeryModel.set((3),{"color":"b", "piece":"images/r.png"});
                            galeryModel.set((0),{"color":"e", "piece":"images/empty.png"});
                            // Castling legality checks are missing
                        }

                        else {
                                moveStarted=false;
                                fromIndex=-1;
                                toIndex=-1;
                        }
                        break;
                    case "images/K.png":
                        if ((((fromIndex-toIndex) == 9) || ((fromIndex-toIndex) == 8)
                              || ((fromIndex-toIndex) == 7) || ((fromIndex-toIndex) == 1)
                              || ((fromIndex-toIndex) == -1) || ((fromIndex-toIndex) == -7)
                              || ((fromIndex-toIndex) == -8) || ((fromIndex-toIndex) == -9))
                             && galeryModel.get(toIndex).color !== "w") {
                            moveLegal = true;
                        }
                        // Castling kingside
                        else if ((toIndex == 62) && galeryModel.get(62).color === "e"
                                  && galeryModel.get(61).color === "e") {
                            moveLegal = true;
                            galeryModel.set((61),{"color":"w", "piece":"images/R.png"});
                            galeryModel.set((63),{"color":"e", "piece":"images/empty.png"});
                            // Castling legality checks are missing
                        }
                        // Castling queenside
                        else if ((toIndex == 58) && galeryModel.get(58).color === "e"
                                 && galeryModel.get(59).color === "e" && galeryModel.get(57).color === "e") {
                            moveLegal = true;
                            galeryModel.set((59),{"color":"w", "piece":"images/R.png"});
                            galeryModel.set((56),{"color":"e", "piece":"images/empty.png"});
                            // Castling legality checks are missing
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
                                &&   galeryModel.get(toIndex).color !== "w") {
                               if (Math.abs(toIndex-fromIndex) == 8) {
                                   moveLegal = true;
                               }
                               else if (toIndex > fromIndex +8) {
                                   toHelpIndex = toIndex-8;
                                   moveLegalHelp = true;
                                   while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
                                           moveLegal = true;
                                           toHelpIndex = toHelpIndex -8;
                                       }
                                       else {
                                           moveLegal = false;
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
                                           moveLegal = true;
                                           toHelpIndex = toHelpIndex +8;
                                       }
                                       else {
                                           moveLegal = false;
                                           moveLegalHelp = false;
                                           moveStarted=false;
                                           fromIndex=-1;
                                           toIndex=-1;
                                       }
                                   }

                               }
                           }
                        // Same row
                        else if ((((toIndex-toIndex%8)/8) == ((fromIndex-fromIndex%8)/8)) && galeryModel.get(toIndex).color !== "w") {
                            if (Math.abs(toIndex-fromIndex) == 1) {
                                moveLegal = true;
                            }
                            else if (toIndex > fromIndex +1) {
                                toHelpIndex = toIndex-1;
                                moveLegalHelp = true;
                                while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
                                        moveLegal = true;
                                        toHelpIndex = toHelpIndex -1;
                                    }
                                    else {
                                        moveLegal = false;
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
                                        moveLegal = true;
                                        toHelpIndex = toHelpIndex +1;
                                    }
                                    else {
                                        moveLegal = false;
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
                                &&   galeryModel.get(toIndex).color !== "w") {
                               if (Math.abs(toIndex-fromIndex) == 9) {
                                   moveLegal = true;
                               }
                               else if (toIndex > fromIndex +9) {
                                   toHelpIndex = toIndex-9;
                                   moveLegalHelp = true;
                                   while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
                                           moveLegal = true;
                                           toHelpIndex = toHelpIndex -9;
                                       }
                                       else {
                                           moveLegal = false;
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
                                           moveLegal = true;
                                           toHelpIndex = toHelpIndex +9;
                                       }
                                       else {
                                           moveLegal = false;
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
                             &&   galeryModel.get(toIndex).color !== "w") {
                            if (Math.abs(toIndex-fromIndex) == 7) {
                                moveLegal = true;
                            }
                            else if (toIndex > fromIndex +7) {
                                toHelpIndex = toIndex-7;
                                moveLegalHelp = true;
                                while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                         || galeryModel.get(toHelpIndex).color == "bp") {
                                        moveLegal = true;
                                        toHelpIndex = toHelpIndex -7;
                                    }
                                    else {
                                        moveLegal = false;
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
                                        moveLegal = true;
                                        toHelpIndex = toHelpIndex +7;
                                    }
                                    else {
                                        moveLegal = false;
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
                                &&   galeryModel.get(toIndex).color !== "b") {
                               if (Math.abs(toIndex-fromIndex) == 8) {
                                   moveLegal = true;
                               }
                               else if (toIndex > fromIndex +8) {
                                   toHelpIndex = toIndex-8;
                                   moveLegalHelp = true;
                                   while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
                                           moveLegal = true;
                                           toHelpIndex = toHelpIndex -8;
                                       }
                                       else {
                                           moveLegal = false;
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
                                           moveLegal = true;
                                           toHelpIndex = toHelpIndex +8;
                                       }
                                       else {
                                           moveLegal = false;
                                           moveLegalHelp = false;
                                           moveStarted=false;
                                           fromIndex=-1;
                                           toIndex=-1;
                                       }
                                   }

                               }
                           }
                        // Same row
                        else if ((((toIndex-toIndex%8)/8) == ((fromIndex-fromIndex%8)/8)) && galeryModel.get(toIndex).color !== "b") {
                            if (Math.abs(toIndex-fromIndex) == 1) {
                                moveLegal = true;
                            }
                            else if (toIndex > fromIndex +1) {
                                toHelpIndex = toIndex-1;
                                moveLegalHelp = true;
                                while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
                                        moveLegal = true;
                                        toHelpIndex = toHelpIndex -1;
                                    }
                                    else {
                                        moveLegal = false;
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
                                        moveLegal = true;
                                        toHelpIndex = toHelpIndex +1;
                                    }
                                    else {
                                        moveLegal = false;
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
                                &&   galeryModel.get(toIndex).color !== "b") {
                               if (Math.abs(toIndex-fromIndex) == 9) {
                                   moveLegal = true;
                               }
                               else if (toIndex > fromIndex +9) {
                                   toHelpIndex = toIndex-9;
                                   moveLegalHelp = true;
                                   while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
                                           moveLegal = true;
                                           toHelpIndex = toHelpIndex -9;
                                       }
                                       else {
                                           moveLegal = false;
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
                                           moveLegal = true;
                                           toHelpIndex = toHelpIndex +9;
                                       }
                                       else {
                                           moveLegal = false;
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
                             &&   galeryModel.get(toIndex).color !== "b") {
                            if (Math.abs(toIndex-fromIndex) == 7) {
                                moveLegal = true;
                            }
                            else if (toIndex > fromIndex +7) {
                                toHelpIndex = toIndex-7;
                                moveLegalHelp = true;
                                while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                         || galeryModel.get(toHelpIndex).color == "bp") {
                                        moveLegal = true;
                                        toHelpIndex = toHelpIndex -7;
                                    }
                                    else {
                                        moveLegal = false;
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
                                        moveLegal = true;
                                        toHelpIndex = toHelpIndex +7;
                                    }
                                    else {
                                        moveLegal = false;
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
                                &&   galeryModel.get(toIndex).color !== "w") {
                               if (Math.abs(toIndex-fromIndex) == 9) {
                                   moveLegal = true;
                               }
                               else if (toIndex > fromIndex +9) {
                                   toHelpIndex = toIndex-9;
                                   moveLegalHelp = true;
                                   while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
                                           moveLegal = true;
                                           toHelpIndex = toHelpIndex -9;
                                       }
                                       else {
                                           moveLegal = false;
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
                                           moveLegal = true;
                                           toHelpIndex = toHelpIndex +9;
                                       }
                                       else {
                                           moveLegal = false;
                                           moveLegalHelp = false;
                                           moveStarted=false;
                                           fromIndex=-1;
                                           toIndex=-1;
                                       }
                                   }

                               }
                           }
                        else if ((((fromIndex-toIndex)%7 == 0))
                             &&   galeryModel.get(toIndex).color !== "w") {
                            if (Math.abs(toIndex-fromIndex) == 7) {
                                moveLegal = true;
                            }
                            else if (toIndex > fromIndex +7) {
                                toHelpIndex = toIndex-7;
                                moveLegalHelp = true;
                                while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                         || galeryModel.get(toHelpIndex).color == "bp") {
                                        moveLegal = true;
                                        toHelpIndex = toHelpIndex -7;
                                    }
                                    else {
                                        moveLegal = false;
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
                                        moveLegal = true;
                                        toHelpIndex = toHelpIndex +7;
                                    }
                                    else {
                                        moveLegal = false;
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
                    case "images/b.png": // Copy of white but two color checks changed from "w" to "b"
                        if ((((fromIndex-toIndex)%9 == 0))
                                &&   galeryModel.get(toIndex).color !== "b") {
                               if (Math.abs(toIndex-fromIndex) == 9) {
                                   moveLegal = true;
                               }
                               else if (toIndex > fromIndex +9) {
                                   toHelpIndex = toIndex-9;
                                   moveLegalHelp = true;
                                   while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
                                           moveLegal = true;
                                           toHelpIndex = toHelpIndex -9;
                                       }
                                       else {
                                           moveLegal = false;
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
                                           moveLegal = true;
                                           toHelpIndex = toHelpIndex +9;
                                       }
                                       else {
                                           moveLegal = false;
                                           moveLegalHelp = false;
                                           moveStarted=false;
                                           fromIndex=-1;
                                           toIndex=-1;
                                       }
                                   }

                               }
                           }
                        else if ((((fromIndex-toIndex)%7 == 0))
                             &&   galeryModel.get(toIndex).color !== "b") {
                            if (Math.abs(toIndex-fromIndex) == 7) {
                                moveLegal = true;
                            }
                            else if (toIndex > fromIndex +7) {
                                toHelpIndex = toIndex-7;
                                moveLegalHelp = true;
                                while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                         || galeryModel.get(toHelpIndex).color == "bp") {
                                        moveLegal = true;
                                        toHelpIndex = toHelpIndex -7;
                                    }
                                    else {
                                        moveLegal = false;
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
                                        moveLegal = true;
                                        toHelpIndex = toHelpIndex +7;
                                    }
                                    else {
                                        moveLegal = false;
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
                                && galeryModel.get(toIndex).color !== "w") {
                            moveLegal = true;
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
                                && galeryModel.get(toIndex).color !== "b") {
                            moveLegal = true;
                        }
                        else {
                                moveStarted=false;
                                fromIndex=-1;
                                toIndex=-1;
                        }
                        break;
                    case "images/R.png":
                        if ((((fromIndex-toIndex)%8 == 0))
                                &&   galeryModel.get(toIndex).color !== "w") {
                               if (Math.abs(toIndex-fromIndex) == 8) {
                                   moveLegal = true;
                               }
                               else if (toIndex > fromIndex +8) {
                                   toHelpIndex = toIndex-8;
                                   moveLegalHelp = true;
                                   while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
                                           moveLegal = true;
                                           toHelpIndex = toHelpIndex -8;
                                       }
                                       else {
                                           moveLegal = false;
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
                                           moveLegal = true;
                                           toHelpIndex = toHelpIndex +8;
                                       }
                                       else {
                                           moveLegal = false;
                                           moveLegalHelp = false;
                                           moveStarted=false;
                                           fromIndex=-1;
                                           toIndex=-1;
                                       }
                                   }

                               }
                           }
                        // Same row
                        else if ((((toIndex-toIndex%8)/8) == ((fromIndex-fromIndex%8)/8)) && galeryModel.get(toIndex).color !== "w") {
                            if (Math.abs(toIndex-fromIndex) == 1) {
                                moveLegal = true;
                            }
                            else if (toIndex > fromIndex +1) {
                                toHelpIndex = toIndex-1;
                                moveLegalHelp = true;
                                while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
                                        moveLegal = true;
                                        toHelpIndex = toHelpIndex -1;
                                    }
                                    else {
                                        moveLegal = false;
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
                                        moveLegal = true;
                                        toHelpIndex = toHelpIndex +1;
                                    }
                                    else {
                                        moveLegal = false;
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
                                &&   galeryModel.get(toIndex).color !== "b") {
                               if (Math.abs(toIndex-fromIndex) == 8) {
                                   moveLegal = true;
                               }
                               else if (toIndex > fromIndex +8) {
                                   toHelpIndex = toIndex-8;
                                   moveLegalHelp = true;
                                   while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                                       if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
                                           moveLegal = true;
                                           toHelpIndex = toHelpIndex -8;
                                       }
                                       else {
                                           moveLegal = false;
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
                                           moveLegal = true;
                                           toHelpIndex = toHelpIndex +8;
                                       }
                                       else {
                                           moveLegal = false;
                                           moveLegalHelp = false;
                                           moveStarted=false;
                                           fromIndex=-1;
                                           toIndex=-1;
                                       }
                                   }

                               }
                           }
                        // Same row
                        else if ((((toIndex-toIndex%8)/8) == ((fromIndex-fromIndex%8)/8)) && galeryModel.get(toIndex).color !== "b") {
                            if (Math.abs(toIndex-fromIndex) == 1) {
                                moveLegal = true;
                            }
                            else if (toIndex > fromIndex +1) {
                                toHelpIndex = toIndex-1;
                                moveLegalHelp = true;
                                while (((toHelpIndex-fromIndex) > 0) && moveLegalHelp) {
                                    if (galeryModel.get(toHelpIndex).color == "e" || galeryModel.get(toHelpIndex).color == "wp"
                                            || galeryModel.get(toHelpIndex).color == "bp") {
                                        moveLegal = true;
                                        toHelpIndex = toHelpIndex -1;
                                    }
                                    else {
                                        moveLegal = false;
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
                                        moveLegal = true;
                                        toHelpIndex = toHelpIndex +1;
                                    }
                                    else {
                                        moveLegal = false;
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
                        moveLegal = true;
                    }
                }
// end block isMovable:
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
                        isLegalmove();
                        if (moveLegal){
                            galeryModel.set(toIndex,{"color":colorMoved, "piece":itemMoved})
                            galeryModel.set(fromIndex,{"color":"e", "piece":"images/empty.png"})
                            moveStarted=!moveStarted;
                            moveLegal=false;
                            if (tilat.valko) {
                                if (benpassant > 0 && galeryModel.get(benpassant).color == "bp") {
                                    galeryModel.set(benpassant,{"color":"e", "piece":"images/empty.png"});
                                    benpassant = -1
                                }
                                vuoro.vaihdaMustalle()
                            }
                            else {
                                if (wenpassant > 0 && galeryModel.get(wenpassant).color == "wp") {
                                    galeryModel.set(wenpassant,{"color":"e", "piece":"images/empty.png"});
                                    wenpassant = -1
                                }
                                vuoro.vaihdaValkealle()
                            }

                        }
                    }
                }
            }

            ListModel {
                    id: galeryModel
                    ListElement {
                        color: "e"
                        piece: "images/empty.png"
                    }
                }

            BackgroundItem {
                id: upperBar
                width: page.width
                height: 185
                enabled: false //tilat.juoksee && tilat.valko
                onClicked: vuoro.vaihdaMustalle()
                PageHeader {
                    title: qsTr("Chess board")
                }
                ProgressBar {
                    id: progressBar2
                    width: parent.width
                    height: 150
                    maximumValue: valkomax
                    valueText: valkokello.label_minuutitv + ":" + (valkokello.label_sekuntitv < 10 ? "0" : "") + valkokello.label_sekuntitv
                    label: qsTr("min:s")
                    value: valkokello.rogres_sekuntitv
                    rotation: 180
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 35
                    Timer {
                        interval: 100
                        running: tilat.juoksee && tilat.valko && Qt.ApplicationActive
                        repeat: true
                        onTriggered: valkokello.updateValko()
                    }
                }
            }

            Rectangle {
                height: 540
                width:parent.width
                Image {
                    id: backround
                    source: "images/grid.png"
                }
                GridView {
                    id: grid
                    cellWidth: width / 8
                    cellHeight: width / 8
                    anchors.fill: parent
                    layoutDirection: Qt.RightToLeft
                    verticalLayoutDirection: GridView.BottomToTop
                    model: galeryModel
                    delegate: Image {
                        asynchronous: true
                        source:  piece
                        sourceSize.width: grid.cellWidth
                        sourceSize.height: grid.cellHeight
//                        ShaderEffect {}
/*                        Rectangle {
                            color: "blue"
                            anchors.fill: parent
                            enabled: true
                            opacity: 0.5
                        } */
                        MouseArea {
                                anchors.fill: parent
                                onClicked: {moveMent.indeksi = index;
                                    moveMent.itemTobemoved = piece;
                                    moveMent.colorTobemoved = color;
                                    moveMent.movePiece();
//                                    console.log("Index", index, piece, color);
//                                    Myfunks.gridToFEN()

                                }
                            }
                    }
                } // end GridView
            } //end Rectangle


            BackgroundItem {
                id: lowerBar
                width: page.width
                height: 185
                enabled: false //tilat.juoksee && tilat.musta
                onClicked: vuoro.vaihdaValkealle()
                ProgressBar {
                    id: progressBarm
                    width: parent.width
                    maximumValue: mustamax
                    valueText: muttakello.label_minuutitm + ":" + (muttakello.label_sekuntitm < 10 ? "0" : "") + muttakello.label_sekuntitm
                    label: qsTr("min:s")
                    value: muttakello.rogres_sekuntitm
                    Timer {interval: 100
                        running: tilat.juoksee && tilat.musta && Qt.ApplicationActive
                        repeat: true
                        onTriggered: muttakello.updateMutta()}
                }
            }
// loppusulkeet
        }
    }
}
