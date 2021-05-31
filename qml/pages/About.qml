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


Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {

            MenuItem {
                text: qsTr("Back to settings")
                onClicked: pageStack.pop()
            }
        }

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("About page")
            }

            Image {
                id: logo
                source: "./images/harbour-shakkikello.png"
                anchors.horizontalCenter: parent.horizontalCenter
                height: Screen.width/7
                width: Screen.width/7
            }

            Label {
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                width: parent.width
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                //: The name of the app followed with a version number
                text: {qsTr("Fast chess, version") + " 0.8.8"}
            }

            SectionHeader { text: qsTr("Translations") }
            Text {
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
                width: parent.width
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                text: {qsTr("German (Nit)") + "\n"
                       + qsTr("Spanish (Carlos Gonzalez)") + "\n"
                       + qsTr("Finnish (Riku Lahtinen)") + "\n"
                       + qsTr("French (lutinotmalin)") + "\n"
                       + qsTr("Hungarian (leoka)") + "\n"
                       + qsTr("Dutch (Heimen Stoffels)") + "\n"
                       + qsTr("Dutch (Belgium) (Nathan Follens)") + "\n"
                       + qsTr("Polish (szopin)") + "\n"
                       + qsTr("Chinese (China) (Historyscholar)")
                }
            }

            SectionHeader { text: qsTr("Contributions") }
            Text {
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
                width: parent.width
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                text: {qsTr("The design of the pieces (Kapu)")
                }
            }

            SectionHeader { text: qsTr("Third party software") }
            Text {
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
                width: parent.width
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                text: {qsTr("Stockfish engine, v5 (stockfishchess.org)")
                }
            }

            SectionHeader { text: qsTr("Licence") }
            Text {
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
                width: root.width
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                text: qsTr("Copyright (c) 2015, Riku Lahtinen") + "\n"
                      + qsTr("Licensed under GPLv3. License, source code and more information:") + "\n"
                      + ("https://github.com/Rikujolla/shakkikello")
            }
            // end brackets
        }
    }
}
