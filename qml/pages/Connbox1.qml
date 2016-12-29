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

Page {
    id: connectionBox
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                title: qsTr("TCP client page")
            }

            Text {
                text: "MyIP: " + conTcpSrv.cipadd
                color: Theme.highlightColor
            }

            Text {
                text: "My port: " + conTcpSrv.cport
                color: Theme.highlightColor
            }

            TextField {
                id:oppmove
                width: parent.width
                placeholderText: "opponents move"
            }

            TextField {
                id: moveField
                text: "e2e4"
                placeholderText: "e2e4"
                label: qsTr("Move")
                //visible: openingMode == 2
                width: page.width
                inputMethodHints: Qt.ImhNoPredictiveText
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: {
                    conTcpSrv.smove = text
                    conTcpCli.requestNewFortune();
                    //console.log(conTcpSrv.smove);
                    focus = false;
                }
            }

            TextField {
                id: iipee
                text: ""
                placeholderText: "192.168.1.70"
                label: qsTr("Server IP")
                //visible: openingMode == 2
                width: page.width
                inputMethodHints: Qt.ImhNoPredictiveText
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: {
                    conTcpCli.sipadd = text
                    console.log(conTcpCli.sipadd);
                    focus = false;
                }
            }

            TextField {
                id: portti
                text: ""
                placeholderText: "12345"
                label: qsTr("Server port")
                //visible: openingMode == 2
                width: page.width
                inputMethodHints: Qt.ImhNoPredictiveText
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: {
                    conTcpCli.sport = text
                    console.log(conTcpCli.sport);
                    focus = false;
                }
            }

            Button {
                text: "Connect"
                onClicked: connectionBox.destroy()
            }


        }

    }
}
