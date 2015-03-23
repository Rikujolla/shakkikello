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
import QtDocGallery 5.0 //pois??
import org.nemomobile.thumbnailer 1.0 //pois

Page {
//    DocumentGalleryModel {
//        id: galleryModel
//        rootType: DocumentGallery.Image
//        properties: [ "url", "title", "dateTaken" ]
//        autoUpdate: true
//        sortProperties: ["dateTaken"]
//    }

    property int koo: 4

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

    // Gridview with Sailfish Silica specific
    SilicaGridView {
        id: grid
        header: PageHeader { title: qsTr("Board") }
        cellWidth: width / 8
        cellHeight: width / 8
// ei toimi        count: 64
        anchors.fill: parent
//        anchors.fill: parent.Center
        model: galeryModel

        // Sailfish Silica PulleyMenu on top of the grid
        PullDownMenu {
            MenuItem {
                text: qsTr("Insert")
                onClicked: {galeryModel.set(koo,{"name":"test", "portrait":"vruutu.png"});
                koo=koo+1}

            }
            MenuItem {
                text: qsTr("Back to settings")
                onClicked: pageStack.pop()
            }
        }


        delegate: Image {
            asynchronous: true
            source:  "vaihtoMusta.png"
            sourceSize.width: grid.cellWidth
            sourceSize.height: grid.cellHeight

            MouseArea {
                anchors.fill: parent
                onClicked: window.pageStack.push(Qt.resolvedUrl("Tapahtuma.qml"),
                                                 {currentIndex: index, model: grid.model} )
            }
        }
        ScrollDecorator {}
    }
}

