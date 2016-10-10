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
//import QtQuick.LocalStorage 2.0
//import "setting.js" as Mysets


Page {
    id: page
    //onStatusChanged: progressBar2.value = valkokello.rogres_sekuntitv
    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            quickSelect: true
            MenuItem {
                text: qsTr("Black´s turn")
                onClicked: vuoro.vaihdaMustalle()
            }
        }

        PushUpMenu {
            quickSelect: true
            MenuItem {
                text: qsTr("White´s turn")
                onClicked: vuoro.vaihdaValkealle()
            }
        }

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge

            Item {
                id : vuoro
                /////////////////////////////////////////////
                // Function changes from White to Black
                ////////////////////////////////////////////
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
                /////////////////////////////////////////////
                // Function changes from Black to White
                ////////////////////////////////////////////
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
                property int sekuntitm0: 0 //Total time Black has accumulated before the move
                property int sekuntitm : 0
                property int rogres_sekuntitm : mustamax
                property int label_sekuntitm
                property int label_minuutitm : mustamax/60
                property int sum_incrementm : 0
                function timeMutta() {sekuntitm0 = sekuntitm0 + sekuntitm}
                function updateMutta() {
                    kello.timeChanged();
                    if (tilat.pelialkoi && countDirDown == true && rogres_sekuntitm <= 0) {
                        tilat.peliloppui = true;
                        tilat.peliLoppui();
                        //console.log("if1" , mustamax)
                    }
                    else if (tilat.pelialkoi && countDirDown == false && rogres_sekuntitm >= mustamax) {
                        tilat.peliloppui = true;
                        tilat.peliLoppui()
                        //console.log("if2" , "rogres",rogres_sekuntitm ,mustamax)
                    }
                    else if (countDirDown == false) {
                        sekuntitm = kello.sekuntit;
                        label_sekuntitm = (-sum_incrementm + (sekuntitm0 + sekuntitm))%60;
                        label_minuutitm = ((-sum_incrementm + (sekuntitm0 + sekuntitm))-label_sekuntitm)/60;
                        rogres_sekuntitm = -sum_incrementm + (sekuntitm0 + sekuntitm)
                        //console.log("if3" , mustamax)
                    }
                    else {
                        sekuntitm = kello.sekuntit;
                        label_sekuntitm = (mustamax + sum_incrementm - (sekuntitm0 + sekuntitm))%60;
                        label_minuutitm = ((mustamax + sum_incrementm - (sekuntitm0 + sekuntitm))-label_sekuntitm)/60;
                        rogres_sekuntitm = mustamax + sum_incrementm - (sekuntitm0 + sekuntitm)
                        //console.log("if4" , mustamax)
                    }
                }
            }

            Item {
                id : valkokello
                property int sekuntitv: 0
                property int sekuntitv0: 0 // Total time the White has accumulated before the move
                property int rogres_sekuntitv : valkomax
                property int label_sekuntitv
                property int label_minuutitv : valkomax/60
                property int sum_incrementv : 0
                function timeValko() {sekuntitv0 = sekuntitv0 + sekuntitv}
                function updateValko() {
                    kello.timeChanged();
                    if (tilat.pelialkoi && countDirDown == true && rogres_sekuntitv <= 0) {
                        tilat.peliloppui = true;
                        tilat.peliLoppui()
                    }
                    else if (tilat.pelialkoi && countDirDown == false && rogres_sekuntitv >= valkomax) {
                        tilat.peliloppui = true;
                        tilat.peliLoppui()
                    }
                    else if (countDirDown == false) {
                        sekuntitv = kello.sekuntit;
                        label_sekuntitv = (-sum_incrementv + (sekuntitv0 + sekuntitv))%60;
                        label_minuutitv = ((-sum_incrementv + (sekuntitv0 + sekuntitv))-label_sekuntitv)/60;
                        rogres_sekuntitv = -sum_incrementv + (sekuntitv0 + sekuntitv)
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
                    //////////////////////////////////////////////////////////////////////////////////////
                    // Logic to reset the timer and changing the button to enable a move to settings page
                    /////////////////////////////////////////////////////////////////////////////////////
                    if (tilat.pelialkoi == true) {
                        maharollisuuret = qsTr("Settings");
                        tilat.asetaTilat();
//                        valkomax = 300;
//                        mustamax = 300;
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
                        //startButton.text = qsTr("Start")
                        //////////////////////////////
                        // Logic to move to settings page
                        //////////////////////////
                    } else {
//                        valkomax = 300;
//                        mustamax = 300;
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
                        //startButton.text = qsTr("Start")
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

            BackgroundItem {
                width: page.width
                //height: Screen.height == 1280 ? 435 : (Screen.height == 2048 ? 819 : 275)
                height: Screen.height == 1280 ? 435 : (Screen.height == 2048 ? 819 : (Screen.height == 1920 ? 680 : 275))
                enabled: tilat.juoksee && tilat.valko
                onClicked: vuoro.vaihdaMustalle()
                PageHeader {
                    title: qsTr("Chess clock")
                }
                ProgressBar {
                    id: progressBar2
                    width: parent.width
                    height: 200
                    maximumValue: valkomax
                    //valueText: valkokello.label_minuutitv + ":" + (valkokello.label_sekuntitv < 10 ? "0" : "") + valkokello.label_sekuntitv
                    valueText: {(valkokello.rogres_sekuntitv < 0 && valkokello.rogres_sekuntitv > -60 ? "-":"")
                                + valkokello.label_minuutitv + ":"
                                + (Math.abs(valkokello.label_sekuntitv) < 10 ? "0" : "")
                                + Math.abs(valkokello.label_sekuntitv)}
                    label: qsTr("min:s")+ "     (" + (valkomax-valkomax%60)/60 + ":00)"
                    value: valkokello.rogres_sekuntitv
                    rotation: 180
                    anchors.verticalCenter: parent.verticalCenter
                    //anchors.verticalCenterOffset: 100
                    Timer {
                        interval: 100
                        running: tilat.juoksee && tilat.valko && Qt.application.active
                        repeat: true
                        onTriggered: valkokello.updateValko()
                    }
                }
            }

            Row {
                Image {
                    source: "vaihtoValkoinen.png"
                    rotation: 180
                }
                Text {
                    text: qsTr("White´s clock")
                    color: Theme.highlightColor
                    rotation: 180
                }
            }

            Text {
                text: "              " + qsTr("Controls")
                color: Theme.highlightColor
            }

            Row {
                spacing: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    id: startButton
                    text: aloitapause
                    enabled: !tilat.peliloppui
                    onClicked: {
                        tilat.aloitaPeli();
                        tilat.juoksee = !tilat.juoksee;
                        startti.timeAsetus(); // Zero time referece setting
                        kello.sekuntit = 0; //Zeroing the master clock
                        valkokello.timeValko(); // Saving accumulated time for White
                        valkokello.sekuntitv = 0;
                        muttakello.timeMutta(); // Saving accumulated time for Black
                        muttakello.sekuntitm=0;
//                        muttakello.rogres_sekuntitm = mustamax;
                        if (!countDirDown) {
                            muttakello.rogres_sekuntitm = -muttakello.sum_incrementm + muttakello.sekuntitm0;
                            valkokello.rogres_sekuntitv = -valkokello.sum_incrementv + valkokello.sekuntitv0;
                        }
                        tilat.vaihdaTila();
                        maharollisuuret = qsTr("Reset")
                    }
                }
                Button {
                    text: maharollisuuret
                    onClicked: asetussivulle.siirrytKo()
                    enabled: !tilat.juoksee || tilat.peliloppui
                }
            }

            Row {
                Image {
                    source: "vaihtoMusta.png"
                }
                Text {
                    text: qsTr("Black´s clock")
                    color: Theme.highlightColor
                }
            }

            BackgroundItem {
                width: page.width
                //height: Screen.height == 1280 ? 435 : (Screen.height == 2048 ? 819 : 275)
                //height: JollaC ? 435 : JollaTablet ? 819 : TuringPhone&&Oysters ? xxx: Jolla1 : 275)
                height: Screen.height == 1280 ? 435 : (Screen.height == 2048 ? 819 : (Screen.height == 1920 ? 680 : 275))
                enabled: tilat.juoksee && tilat.musta
                onClicked: vuoro.vaihdaValkealle()
                ProgressBar {
                    id: progressBarm
                    width: parent.width
                    maximumValue: mustamax
                    valueText: {(muttakello.rogres_sekuntitm < 0 && muttakello.rogres_sekuntitm > -60 ? "-":"")
                                + muttakello.label_minuutitm + ":"
                                + (Math.abs(muttakello.label_sekuntitm) < 10 ? "0" : "")
                                + Math.abs(muttakello.label_sekuntitm)}
                    label: qsTr("min:s")+ "     (" + (mustamax-mustamax%60)/60 + ":00)"
                    value: muttakello.rogres_sekuntitm
                    anchors.verticalCenter: parent.verticalCenter
                    Timer {interval: 100
                        running: tilat.juoksee && tilat.musta && Qt.application.active
                        repeat: true
                        onTriggered: muttakello.updateMutta()}
                }
            }
            // loppusulkeet
        }
    }
    //Component.onCompleted: Mysets.loadSettings()
}
