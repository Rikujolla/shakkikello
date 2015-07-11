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

            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("Tietoja.qml"))
            }
            MenuItem {
                text: qsTr("Board, two-player")
                onClicked: pageStack.push(Qt.resolvedUrl("Pelilauta.qml"))
            }
            MenuItem {
                text: qsTr("Board, Stockfish")
                onClicked: pageStack.push(Qt.resolvedUrl("Boardview.qml"))
            }
            MenuItem {
                text: qsTr("Clock view")
                onClicked: pageStack.push(Qt.resolvedUrl("Pelisivu.qml"))
            }
        }

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Settings page")
            }

            Label {
                x: Theme.paddingLarge
                text: qsTr("White") +" "+ valkomax/60 + " " + qsTr("min")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
                  }

            Row {
                spacing: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    text: qsTr("- 1 min")
                    onClicked: {valkomax = valkomax - 60
                    }
                }
                Button {
                    text: qsTr("+ 1 min")
                    onClicked: {valkomax = valkomax + 60
                    }
                }
            }

            Label {
                x: Theme.paddingLarge
                text: qsTr("Black") +" "+ mustamax/60 + " " + qsTr("min")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
                  }

            Row {
                spacing: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    text: qsTr("- 1 min")
                    onClicked: {mustamax = mustamax - 60
                    }
                }
                Button {
                    text: qsTr("+ 1 min")
                    onClicked: {mustamax = mustamax + 60
                    }
                }
            }

            Label {
                x: Theme.paddingLarge
                text: qsTr("Increment/move") + " " + increment + " " + qsTr("s")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
                  }


            Row {
                spacing: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    text: qsTr("- 1 s")
                    onClicked: {increment > 0 ? increment = increment - 1 : increment = 0
                    }
                }
                Button {
                    text: qsTr("+ 1 s")
                    onClicked: {increment = increment + 1
                    }
                }
            }
//loppusulkeet
        }
    }
}
