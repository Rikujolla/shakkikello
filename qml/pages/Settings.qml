/*Copyright (c) 2015-2019, Riku Lahtinen
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
import Sailfish.Pickers 1.0
import "setting.js" as Mysets

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
                onClicked: pageStack.push(Qt.resolvedUrl("Clockview.qml"))
            }
        }

        PushUpMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }

        }
        contentHeight: column.height

        Item {
            id: sets
            property bool indexUpdater: false;
            //: Reduce time by 1 minute
            property var labels: [{lab:qsTr("-1 min")},
                //: Increase time by 1 minute
                {lab:qsTr("+1 min")},
                //: Reduce time by 1 second
                {lab:qsTr("-1 s")},
                //: Increase time by 1 second
                {lab:qsTr("+1 s")},
                //: min is an abbreviation of a minute
                {lab:qsTr("min")},
                //: s is an abbreviation of a second
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
                    font.pixelSize: Theme.fontSizeSmall
                    text: qsTr("White") +" "+ valkomax/60 + " " + sets.labels[4].lab
                }

                Button {
                    text: sets.labels[0].lab
                    width: page.width /6
                    onClicked: {
                        valkomax > 119 ? valkomax = valkomax - 60 : valkomax= valkomax
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
                    font.pixelSize: Theme.fontSizeSmall
                    text: qsTr("Black") +" "+ mustamax/60 + " " + sets.labels[4].lab
                }
                Button {
                    text: sets.labels[0].lab
                    width: page.width /6
                    onClicked: {
                        mustamax > 119 ? mustamax = mustamax - 60 : mustamax = mustamax
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
                    font.pixelSize: Theme.fontSizeSmall
                    //: Sets how many seconds are added to the total remaining time of the game per move.
                    text: qsTr("Increment/move") + " " + increment + " " + sets.labels[5].lab
                    wrapMode: Text.WordWrap
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
                //contentHeight: Theme.paddingMedium
                //: The time is counted upwards from zero to max or downwards from max to zero. This is label for that ComboBox.
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
                //contentHeight: Theme.paddingMedium
                label: qsTr("Opponent")
                currentIndex: playMode == "stockfish" ? 0 : (playMode == "human" ? 1 : 2)

                menu: ContextMenu {
                        MenuItem {
                            //: Stockfish is a name of the chess engine, more info https://stockfishchess.org/
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

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingMedium
                anchors.left: parent.left
                visible: playMode == "othDevice" ? true : false
                ComboBox { // for dynamic creation see Pastie: http://pastie.org/9813891
                    id: portSettings
                    //width: page.width*2/3
                    width: currentIndex == 0 ? page.width : page.width*2/3
                    label: qsTr("Port number")
                    currentIndex: portFixed
                    menu: ContextMenu {
                        MenuItem {
                            text: qsTr("Random")
                            onClicked: {
                                portFixed = 0;
                                myPort = 0;
                                //console.log(myPort);
                            }
                        }
                        MenuItem {
                            text: qsTr("Fixed")
                            onClicked: {
                                portFixed = 1;
                                myPort = portValue.text;
                            }
                        }
                    }
                }

                TextField {
                    id: portValue
                    text: myPort
                    placeholderText: "12345"
                    //label: qsTr("ECO code")
                    visible: portSettings.currentIndex == 1
                    width: page.width/4
                    //validator: RegExpValidator { regExp: /^([A-E])([0-9])([0-9])$/ }
                    //validator: RegExpValidator { regExp: /^([A-E])([0-9])([0])$/ }
                    //validator: RegExpValidator { regExp: /^((([A-E])([0-9])([0]))|((A)([0-3])([0-9])))$/ }
                    //validator: RegExpValidator { regExp: /^((([A-E])([0-9])([0]))|((A)([0-5])([0-9]))||((R)([0])([1-5])))$/ }
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints:  Qt.ImhDigitsOnly
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        myPort = text;
                        //console.log(myPort);

                    }
                }
            }

            ComboBox {
                id: setColor
                width: parent.width
                //contentHeight: Theme.paddingMedium //not working properly
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
                    validator: RegExpValidator { regExp: /^((([A-E])([0-9])([0]))|((A)([0-6])([0-9]))||((R)([0])([1-5])))$/ }
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints: Qt.ImhNoPredictiveText
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        openingECO = eku.text;
                    }
                }
           //}

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

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingLarge
                visible: playMode == "stockfish" ? true : false
                Text {
                    width: page.width /2
                    color: Theme.secondaryHighlightColor
                    font.pixelSize: Theme.fontSizeSmall
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
                    font.pixelSize: Theme.fontSizeSmall
                    //: Sets the time the Stockfish engine has per move.
                    text: qsTr("Movetime") + " " + stockfishMovetime + " " + sets.labels[5].lab
                    wrapMode: Text.WordWrap
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
                                startPageTxt = "pages/Clockview.qml"
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
                                startPageTxt = "pages/Settings.qml"
                                startPage = 2
                                setView.currentIndex = 2
                            }
                        }
                }
            }

            ComboBox {
                id: setPieces
                width: parent.width
                //: The style of the pieces selector
                label: qsTr("Style of the pieces")
                currentIndex: pieceStyle

                menu: ContextMenu {
                    MenuItem {
                        //: The style of the pieces is unlike
                        text: qsTr("Unlike")
                        onClicked: {
                            pieceStyle = 0
                            piePat = "images/piece0/"
                            setPieces.currentIndex = 0
                        }
                    }
                    MenuItem {
                        //: The style of the pieces is classic
                        text: qsTr("Classic")
                        onClicked: {
                            pieceStyle = 1
                            piePat = "images/piece1/"
                            setPieces.currentIndex = 1
                        }
                    }

                    MenuItem {
                        //: Player can select the pieces of her or his choice
                        text: qsTr("Personal art")
                        onClicked: {
                            var dialog = pageStack.push(Qt.resolvedUrl("Settings_dialog_personal_art.qml"),
                                                        {"name": "test"})
                            dialog.accepted.connect(function() {
                                filepicker_timer.start()
                            })
                            dialog.rejected.connect(function() {
                                setPieces.currentIndex = pieceStyle
                            })
                        }
                    }
                }
            }

            Timer {
                id:filepicker_timer
                interval: 500
                running: false
                repeat: false

                onTriggered: pageStack.push(filePickerPage)
            }


            property string personal_art_filename
            property string personal_art_path

            Component {
                id: filePickerPage
                FilePickerPage {
                    nameFilters: ['*.png']
                    onSelectedContentPropertiesChanged: {
                        column.personal_art_filename = selectedContentProperties.fileName
                        column.personal_art_path = selectedContentProperties.filePath;
                        piePat = column.personal_art_path.slice(0,column.personal_art_path.length-column.personal_art_filename.length)
                        pieceStyle = 2
                        setPieces.currentIndex = 2
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
