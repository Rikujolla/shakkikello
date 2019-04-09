/*Copyright (c) 2019, Riku Lahtinen
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
import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    id: dial
    property string name

    Column {
        width: parent.width

        DialogHeader {
        }

        SectionHeader { text: qsTr("Current folder path") }

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.paddingMedium
            }
            text: qsTr("If the current folder path is already right, please cancel this operation.")
        }

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.secondaryColor
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.paddingLarge
            }
            text: piePat
        }

        SectionHeader { text: qsTr("File selection") }

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.paddingMedium
            }
            text: qsTr("Selecting only one image file from your personal art folder is required.")
        }

        SectionHeader { text: qsTr("Files required") }

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            text:qsTr("Your personal art folder should have all the image files as follows:")
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.paddingMedium
            }
        }

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.secondaryColor
            text:"B.png, b.png, empty.png, frame.png, framemoved.png, grid.png, K.png, k.png, N.png, n.png, P.png, p.png, Q.png, q.png,  R.png, r.png"
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.paddingLarge
            }
        }

        SectionHeader { text: qsTr("Testing") }

        Label{
            width: parent.width
            wrapMode: Text.WordWrap
            font.pixelSize: Theme.fontSizeMedium
            text:qsTr("For the start of the testing of this feature you can copy the required files from the device path:")
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.paddingMedium
            }
        }

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.secondaryColor
            text:"/usr/share/harbour-shakkikello/qml/pages/images/piece0/"
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.paddingLarge
            }
        }
    }
}
