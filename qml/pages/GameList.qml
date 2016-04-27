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
//import org.nemomobile.notifications 1.0
import "infofuncs.js" as Myinfo


Page {
    id: page
    onStatusChanged: {
        Myinfo.fillGameList()
    }

    SilicaListView {
        id: listView
        model: listix
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Save current game")
                visible: movesDone != ""
                onClicked:{
                    Myinfo.saveGameDB()
                    Myinfo.fillGameList()
                }
            }
        }

        header: PageHeader {
            title: qsTr("Game list")
        }

        delegate: ListItem {
            id: delegate

            Row {
                Label {
                    id: listos
                    text: qsTr("Game") + " " + (iidee + 1) + ": "
                }
                TextInput {
                    id:texti
                    color: Theme.primaryColor
                    text:title
                    onAccepted: {
                        title=text
                        Myinfo.updateName(iidee, text)
                    }
                }
            }

            menu: ContextMenu {
                MenuItem {
                    text: qsTr("Show game")
                    onClicked: {
                        selectedGame = iidee;
                        pageStack.push(Qt.resolvedUrl("GameInfo.qml"))
                    }
                }
                MenuItem {
                    text: qsTr("Animate game")
                    visible: false
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("GameInfo.qml"))
                    }
                }
                MenuItem {
                    text: qsTr("Delete game")
                    onClicked: {
                        Myinfo.deleteGame(iidee)
                    }
                }
                /*MenuItem {
                    text: ("Error")
                    onClicked: {
                        ermes.publish()
                    }
                }*/
            }
        }
        VerticalScrollDecorator {}

        /*Notification {
            id: ermes
            previewBody: "Notification preview body"
        }*/

        Component.onCompleted: {}

    }
}





