/*Copyright (c) 2015-2016, Riku Lahtinen
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
import "setting.js" as Mysets
//import harbour.shakkikello.btservice 1.0
//import harbour.shakkikello.chessservice 1.0
//import harbour.shakkikello.server 1.0
import QtBluetooth 5.2

Page {
    id: page
    //onStatusChanged: game.text = openingGame
    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {

            MenuItem {
                text: qsTr("Save settings")
                onClicked: Mysets.saveSettings()
            }
            MenuItem {
                text: qsTr("Play chess")
                onClicked: {pageStack.push(Qt.resolvedUrl("Boardview.qml"));
                    openingECO = eku.text;
                    //console.log(openingECO)
                }
            }
            MenuItem {
                text: qsTr("Clock view")
                onClicked: pageStack.push(Qt.resolvedUrl("Pelisivu.qml"))
            }
        }

        PushUpMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("Tietoja.qml"))
            }

        }
        contentHeight: column.height

        Item {
            id: sets
            property bool indexUpdater: false;
            property var labels: [{lab:qsTr("-1 min")},
                {lab:qsTr("+1 min")},
                {lab:qsTr("-1 s")},
                {lab:qsTr("+1 s")},
                {lab:qsTr("min")},
                {lab:qsTr("s")}
            ]

        }

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingMedium
            PageHeader {
                title: qsTr("Settings page")
            }

            SectionHeader { text: qsTr("Clock settings") }

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingLarge
                Text {
                    width: page.width /2
                    color: Theme.secondaryHighlightColor
                    text: qsTr("White") +" "+ valkomax/60 + " " + sets.labels[4].lab
                }

                Button {
                    text: sets.labels[0].lab
                    width: page.width /6
                    onClicked: {valkomax = valkomax - 60
                    }
                }
                Button {
                    text: sets.labels[1].lab
                    width: page.width /6
                    onClicked: {valkomax = valkomax + 60
                    }
                }
            }

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingLarge
                Text {
                    width: page.width /2
                    color: Theme.secondaryHighlightColor
                    text: qsTr("Black") +" "+ mustamax/60 + " " + sets.labels[4].lab
                }
                Button {
                    text: sets.labels[0].lab
                    width: page.width /6
                    onClicked: {mustamax = mustamax - 60
                    }
                }
                Button {
                    text: sets.labels[1].lab
                    width: page.width /6
                    onClicked: {mustamax = mustamax + 60
                    }
                }
            }

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingLarge
                //anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    width: page.width /2
                    color: Theme.secondaryHighlightColor
                    text: qsTr("Increment/move") + " " + increment + " " + sets.labels[5].lab
                }
                Button {
                    text: sets.labels[2].lab
                    width: page.width /6
                    onClicked: {increment > 0 ? increment = increment - 1 : increment = 0
                    }
                }
                Button {
                    text: sets.labels[3].lab
                    width: page.width /6
                    onClicked: {increment = increment + 1
                    }
                }
            }

            ComboBox {
                id: timeCounting
                width: parent.width
                label: qsTr("Time counting")
                currentIndex: countDirInt

                menu: ContextMenu {
                        MenuItem {
                            text: qsTr("Downwards")
                            onClicked: {sets.indexUpdater = true;
                                countDirInt = timeCounting.currentIndex;
                                countDirDown = true;
                            }
                        }
                        MenuItem {
                            text: qsTr("Upwards")
                            onClicked: {sets.indexUpdater = true;
                                countDirInt = timeCounting.currentIndex;
                                countDirDown = false;
                            }
                        }
                }
            }

            SectionHeader { text: qsTr("Chess settings")
            }

            ComboBox {
                id: setOpponent
                width: parent.width
                label: qsTr("Opponent")
                currentIndex: playMode == "stockfish" ? 0 : (playMode == "human" ? 1 : 2)

                menu: ContextMenu {
                        MenuItem {
                            text: qsTr("Stockfish")
                            onClicked: {
                                //console.log("stockfish")
                                playMode = "stockfish"
                                setOpponent.currentIndex = 0
                            }
                        }
                        MenuItem {
                            text: qsTr("Human")
                            onClicked: {
                                //console.log("human")
                                playMode = "human"
                                setOpponent.currentIndex = 1
                            }
                        }
                        MenuItem {
                            text: qsTr("Another device")
                            onClicked: {
                                //console.log("othDevice")
                                playMode = "othDevice"
                                setOpponent.currentIndex = 2
                                //pageStack.push(Qt.resolvedUrl("Chat3.qml"));
                            }
                        }
                }
            }

           /* ComboBox { // for dynamic creation see Pastie: http://pastie.org/9813891
                id: serverSettings
                visible: playMode == "othDevice"
                width: page.width*2/3
                label: qsTr("My role")
                //currentIndex: openingMode
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Server")
                        onClicked: {
                            //sets.indexUpdater = true;
                            console.log("Myrole server")
                            //btCom.startServer()
                        }
                    }
                    MenuItem {
                        text: qsTr("Client")
                        onClicked: {
                            //sets.indexUpdater = true;
                            //pageStack.push(Qt.resolvedUrl("GameSelector.qml"));
                            console.log("Myrole client")
                            //btCom.startClient()
                        }
                    }
                }
            }
            Button {
              text: "test"
              onClicked:pageStack.push(Qt.resolvedUrl("Chat3.qml"));
            }*/

            ComboBox {
                id: setColor
                width: parent.width
                label: qsTr("My color")
                currentIndex: isMyStart ? 0 : 1

                menu: ContextMenu {
                        MenuItem {
                            text: qsTr("White")
                            onClicked: {
                                //console.log("white")
                                setColor.currentIndex = 0
                                isMyStart = true
                            }
                        }
                        MenuItem {
                            text: qsTr("Black")
                            onClicked: {
                                //console.log("black")
                                setColor.currentIndex = 1
                                isMyStart = false
                            }
                        }
                }
            }


            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingMedium
                anchors.left: parent.left
                visible: playMode == "stockfish" ? true : false
                //anchors.fill: parent
                ComboBox { // for dynamic creation see Pastie: http://pastie.org/9813891
                    id: opsiSettings
                    width: page.width*2/3
                    label: qsTr("Opening")
                    currentIndex: openingMode
                    menu: ContextMenu {
                        MenuItem {
                            text: "Stockfish"
                            onClicked: {sets.indexUpdater = true;
                            }
                        }
                        MenuItem {
                            text: qsTr("Random")
                            onClicked: {sets.indexUpdater = true;
                            }
                        }
                        MenuItem {
                            text: "ECO"
                            onClicked: {sets.indexUpdater = true;
                            }
                        }
                        MenuItem {
                            text: qsTr("Saved game")
                            onClicked: {sets.indexUpdater = true;
                                pageStack.push(Qt.resolvedUrl("GameSelector.qml"));
                            }
                        }
                    }
                }
                TextField {
                    id: eku
                    text: openingECO
                    placeholderText: "E20"
                    //label: qsTr("ECO code")
                    visible: openingMode == 2
                    width: page.width/4
                    //validator: RegExpValidator { regExp: /^([A-E])([0-9])([0-9])$/ }
                    //validator: RegExpValidator { regExp: /^([A-E])([0-9])([0])$/ }
                    //validator: RegExpValidator { regExp: /^((([A-E])([0-9])([0]))|((A)([0-3])([0-9])))$/ }
                    validator: RegExpValidator { regExp: /^((([A-E])([0-9])([0]))|((A)([0-5])([0-9]))||((R)([0])([1-5])))$/ }
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints: Qt.ImhNoPredictiveText
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        openingECO = eku.text;
                    }
                }

                TextField {
                    id: game
                    text: openingGame
                    placeholderText: "1"
                    visible: openingMode == 3
                    width: page.width/4
                    validator: RegExpValidator { regExp: /^[0-9]+$/ }
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints: Qt.ImhNoPredictiveText
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        openingGame = game.text;
                    }
                }
            }

            /*Button {
                id:tcpSeverStart
                visible: playMode == "othDevice"
                text:"Start TCP server"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("Chat3a.qml"));
                    //conTcpSrv.Server();
                    tcpSeverStart.text = "Starting köhä"
                }
            }*/
            /*Button {
                id:tcpClientStart
                visible: playMode == "othDevice"
                text:"Start tcp thing"
                onClicked: pageStack.push(Qt.resolvedUrl("Chat3.qml"));
            }*/

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingLarge
                visible: playMode == "stockfish" ? true : false
                Text {
                    width: page.width /2
                    color: Theme.secondaryHighlightColor
                    text: qsTr("Skill Level") + " " + stockfishSkill
                }

                Button {
                    text: "-1"
                    width: page.width /6
                    onClicked: {stockfishSkill > 0 ? stockfishSkill = stockfishSkill - 1 : stockfishSkill = 0
                    }
                }
                Button {
                    text: "+1"
                    width: page.width /6
                    onClicked: {stockfishSkill < 20 ? stockfishSkill = stockfishSkill + 1 : stockfishSkill = 20
                    }
                }
            }
            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingLarge
                visible: playMode == "stockfish" ? true : false
                Text {
                    width: page.width /2
                    color: Theme.secondaryHighlightColor
                    text: qsTr("Movetime") + " " + stockfishMovetime + " " + sets.labels[5].lab
                }

                Button {
                    text: sets.labels[2].lab
                    width: page.width /6
                    onClicked: {stockfishMovetime > 1 ? stockfishMovetime = stockfishMovetime - 1 : stockfishMovetime = 1
                    }
                }
                Button {
                    text: sets.labels[3].lab
                    width: page.width /6
                    // Stockfish movetime in seconds
                    onClicked: {stockfishMovetime = stockfishMovetime + 1
                    }
                }
            }

            SectionHeader { text: qsTr("View settings")
            }

            ComboBox {
                id: setView
                width: parent.width
                label: qsTr("Default view")
                currentIndex: startPage

                menu: ContextMenu {
                        MenuItem {
                            text: qsTr("Chess clock")
                            onClicked: {
                                //console.log("Chess clock")
                                startPageTxt = "pages/Pelisivu.qml"
                                startPage = 0
                                setView.currentIndex = 0
                            }
                        }
                        MenuItem {
                            text: qsTr("Chess board")
                            onClicked: {
                                //console.log("Chess board")
                                startPageTxt = "pages/Boardview.qml"
                                startPage = 1
                                setView.currentIndex = 1
                            }
                        }

                        MenuItem {
                            text: qsTr("Settings page")
                            onClicked: {
                                //console.log("Settings page")
                                startPageTxt = "pages/Asetukset.qml"
                                startPage = 2
                                setView.currentIndex = 2
                            }
                        }
                }
            }

            VerticalScrollDecorator {}

            // This timer is requested to change currentIndex values to global variables
            Timer {
                interval:50
                running:sets.indexUpdater && Qt.ApplicationActive
                repeat:true
                onTriggered: {
                    openingMode = opsiSettings.currentIndex;
                    countDirInt = timeCounting.currentIndex;
                    sets.indexUpdater = false;
                }
            }
            //loppusulkeet
        }
    }
}
