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


Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
//            quickSelect: true
            MenuItem {
                text: qsTr("Insert")
                onClicked: kripti.lisaa()

            }
            MenuItem {
                text: qsTr("Black´s turn")
                onClicked: vuoro.vaihdaMustalle()
            }
            MenuItem {
                text: aloitapause
                enabled: !tilat.peliloppui
                onClicked: {
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
            ///////////////////////////////////////////////
                property int koo: 0

                Item {
                    id: kripti
                    property int koo: 0
                    property int aksa: 1
                    property int yyy: 1
                    function lisaa() {
                        while (yyy < 9) {
                        if (yyy%2 > 0) {
                        while (aksa<5){
                            galeryModel.set(koo,{"name":"empty_white", "portrait":"vruutu.png"});
                            koo=koo+1;
                            galeryModel.set(koo,{"name":"empty_black", "portrait":"mruutu.png"});
                            koo=koo+1;
                            aksa++
                        }
                        aksa=1;
                    }
                        else {
                            while (aksa<5){
                                galeryModel.set(koo,{"name":"empty_black", "portrait":"mruutu.png"});
                                koo=koo+1;
                                galeryModel.set(koo,{"name":"empty_white", "portrait":"vruutu.png"});
                                koo=koo+1;
                                aksa++
                            }
                            aksa=1;
                        }
                        yyy++
                        }
                    }

                }

                ListModel {
                    id: galeryModel
                    ListElement {
                        name: "black"
                        portrait: "vaihtoMusta.png"
                    }
                    ListElement {
                        name: "white"
                        portrait: "vaihtoValkoinen.png"
                    }
                    ListElement {
                        name: "empty_black"
                        portrait: "mruutu.png"
                    }
                    ListElement {
                        name: "empty_white"
                        portrait: "vruutu.png"
                    }
                }

            ///////////////////////////////////////////////////////////////////////////

            BackgroundItem {
                width: page.width
                height: 185
                enabled: tilat.juoksee && tilat.valko
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


///////
            Rectangle {
                height: 540
                width:parent.width
                GridView {
                    id: grid
                    cellWidth: width / 8
                    cellHeight: width / 8
                    anchors.fill: parent
                    model: galeryModel

                delegate: Image {
                    asynchronous: true
                    source:  portrait
                    sourceSize.width: grid.cellWidth
                    sourceSize.height: grid.cellHeight
        /*        delegate: Repeater {
                    model: 3
                    Rectangle { width: 20; height: 20; radius: 10; color: "green" }
        */

                    MouseArea {
                        anchors.fill: parent
                        onClicked: window.pageStack.push(Qt.resolvedUrl("Tapahtuma.qml"),
                                                         {currentIndex: index, model: grid.model} )
                    }
                }
//                ScrollDecorator {}
            } // end GridView

} //end Rectangle
///////


            BackgroundItem {
                width: page.width
                height: 185
                enabled: tilat.juoksee && tilat.musta
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