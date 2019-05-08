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
import QtQuick.LocalStorage 2.0
import "pages/setting.js" as Mysets
import "pages"


ApplicationWindow
{
    id: shakkikelloWindow
    //initialPage: Component { Pelisivu { } }
    //initialPage: Qt.resolvedUrl(startPageTxt)
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.Portrait
    _defaultPageOrientations: Orientation.Portrait
    property string aloitapause: qsTr("Start")
    property bool aloitettu : false
    property string maharollisuuret: qsTr("Settings")
    property int valkomax : 300
    property int mustamax : 300
    property int increment : 0
    //property bool moveStarted : false
    property bool countDirDown: true //Default is Downwards
    property int countDirInt: 0 // For combo box index, related to countDirDown, 0 Downwards
    property string countDirName: qsTr("Downwards")
    property string playMode : "stockfish"
    property int openingMode: 0 // 0 Stockfish, 1 Random, 2 ECO, 3 Saved game
    property string openingECO: "E00" // Used for fixed opening
    property string openingGame  //Selected gameid
    property string openingGameMoves: "e2e4" //Contains the moves of the selected game
    property int stockfishDepth: 4 //depth of stockfish engine
    property int stockfishMovetime: 2 //Movetime in seconds
    property int stockfishSkill: 1 // Skill Level default
    property bool isMyStart: true // Default me playing white
    property int startPage: 0 // 0 = Chess clock, 1 Settings page, 2 Chess board
    property int pieceStyle: 0 // 0 = Unlike style, 1 = Classic style
    property string piePat: "images/piece0/" // Piece sub path
    property string startPageTxt : "pages/Clockview.qml"
    property bool waitPromo : false //if promotion needs to be wait
    property string promotedLong: ""
    property string promotedShort: "q"
    property bool turnWhite  // used for promotion
    property int selectedGame: -1 //Used for game selection
    property string movesDone: ""; //saves done moves to single string eg. e2e4d7d5
    property string movesDon: ""; //temporary length for testing
    property string oppIP:"192.168.1.70" // Opponent's IP
    property int portFixed:0 // Selects if port is random or fixed, default is random
    property int myPort // myIPport
    property int oppPort // Opponent's IPport
    property bool whiteInMate: false // Tells if white is in mate


    ListModel {
        id: listix
        ListElement {
            iidee: 0
            title: "Test3"
            moves: "ouh"
        }
    }


    Component.onCompleted: {
        Mysets.loadSettings()
        pageStack.push(Qt.resolvedUrl(startPageTxt))
        //console.log("width, height", Screen.width, Screen.height)
    }

}
