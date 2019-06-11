import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "setting.js" as Mysets

Item {
    id: connectionBox
    anchors.fill: parent
    property bool vtesttimer: false
    property bool vstarttimer: false

    Rectangle {
        anchors.fill: parent
        id: overlay
        color: "#000000"
        opacity: 1.0
        // add a mouse area so that clicks outside
        // the dialog window will not do anything
        MouseArea {
            anchors.fill: parent
        }
    }
    Column {
        id: column
        width: parent.width
        spacing: Theme.paddingMedium

        PageHeader {
            title: qsTr("TCP connection")
        }

        SectionHeader { text: qsTr("Opponent's device info") }

Row {
        TextField {
            id: iipee
            text: oppIP
            placeholderText: qsTr("IP address")
            label: qsTr("IP address")
            width: page.width*3/4
            inputMethodHints: Qt.ImhNoPredictiveText
            EnterKey.iconSource: "image://theme/icon-m-enter-close"
            EnterKey.onClicked: {
                conTcpCli.sipadd = text;
                oppIP = text;
                Mysets.saveInstantSetting();
                focus = false;
            }
        }

        IconButton {
            visible: iipee.text != ""
            icon.source: "image://theme/icon-m-clear?" + (pressed
                                                          ? Theme.highlightColor
                                                          : Theme.primaryColor)
            onClicked: {
                iipee.text = ""
                Mysets.saveInstantSetting();
            }
        }
    }

        Row {
            TextField {
                id: portti
                text: oppPort
                placeholderText: qsTr("Port number")
                label: qsTr("Port number")
                width: page.width*3/4
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: {
                    conTcpCli.sport = text
                    oppPort = text;
                    Mysets.saveInstantSetting();
                    focus = false;
                }
            }

            IconButton {
                visible: portti.text != ""
                icon.source: "image://theme/icon-m-clear?" + (pressed
                                                              ? Theme.highlightColor
                                                              : Theme.primaryColor)
                onClicked: portti.text = ""
            }
        }

        SectionHeader { text: qsTr("My device info") }

        Text {
            text: qsTr("IP address") + ": " + conTcpSrv.cipadd
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.highlightColor
            anchors.margins: Theme.paddingLarge
            anchors.left: parent.left
        }

        Text {
            id:text3
            text: qsTr("Port number") + ": " + conTcpSrv.cport
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.highlightColor
            anchors.margins: Theme.paddingLarge
            anchors.left: parent.left
        }

        Button {
            id:tstBtn
            text: qsTr("Test connection")
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                isMyStart ? conTcpSrv.smove = "white" : conTcpSrv.smove = "black"
                conTcpCli.sipadd = iipee.text;
                conTcpCli.sport = portti.text
                conTcpSrv.sincrem = increment;
                conTcpCli.requestNewFortune();
                vtesttimer = true;
                tstBtn.text = qsTr("Test in progress") + "..."
                colBtn.visible = false;
            }
        }

        Timer {
            id:connTestTimer
            running:vtesttimer && Qt.application.active
            interval: 1000
            repeat:true
            onTriggered: {
                if ((isMyStart && conTcpCli.cmove === "black") || (!isMyStart && conTcpCli.cmove === "white")){
                    vtesttimer = false;
                    colBtn.visible = false;
                    connBtn.visible = true;
                    tstBtn.visible = false;
                    isMyStart ? mustamax = conTcpCli.ctime : valkomax = conTcpCli.ctime;
                    console.log("Increment", increment, conTcpCli.cincrem)
                    increment > conTcpCli.cincrem ? increment = conTcpCli.cincrem : increment = increment
                    conTcpSrv.sincrem = increment;
                }
                else if (isMyStart && conTcpCli.cmove === "white" || !isMyStart && conTcpCli.cmove === "black"){
                    colBtn.visible = true;
                    connBtn.visible = false;
                    tstBtn.visible = true;
                    tstBtn.text = qsTr("Retest the connection")
                    conTcpCli.requestNewFortune();
                }
                else {
                    conTcpCli.requestNewFortune();
                }
            }
        }

        Button {
            id: colBtn
            visible: false
            //: Reports the player that colors selected in games in different devices prevent the game start. Another player has to change the color the game to proceed.
            text: qsTr("Color mismatch, change my color")
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                isMyStart = !isMyStart;
                isMyStart ? conTcpSrv.smove = "white" : conTcpSrv.smove = "black"
                isMyStart ? conTcpSrv.stime = valkomax : conTcpSrv.stime = mustamax;
                colBtn.visible = false;
                connBtn.visible = false;
            }
        }

        Timer {
            id:startTimer
            running:vstarttimer && Qt.application.active
            interval: 1000
            repeat:true
            onTriggered: {
                if (conTcpSrv.smove === "start" && conTcpCli.cmove === "start"){
                    vstarttimer = false;
                    //
                    hopo.stoDepth = stockfishDepth;
                    hopo.stoMovetime = stockfishMovetime;
                    hopo.stoSkill = stockfishSkill;
                    if (!tilat.pelialkoi) {
                        if (playMode == "stockfish") {hopo.initio();}
                        isMyStart ? stockfishFirstmove = false : stockfishFirstmove = true
                        isMyStart ? feniWhiteReady = false : feniWhiteReady = true
                    }
                    isMyStart ? feniWhite = true : feniWhite = false
                    tilat.aloitaPeli();
                    tilat.juoksee = !tilat.juoksee;
                    startti.timeAsetus();
                    valkokello.timeValko();
                    muttakello.timeMutta();
                    tilat.vaihdaTila();
                    maharollisuuret = qsTr("Reset");
                    conTcpSrv.waitmove = "";
                    conTcpCli.cmove = "";
                    conTcpSrv.smove = "";
                    //
                    connectionBox.destroy()
                }
                else {
                    conTcpCli.requestNewFortune();
                }
            }
        }

        Button {
            id:connBtn
            visible: false
            text: qsTr("Start")
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                conTcpSrv.smove = "start";
                conTcpCli.requestNewFortune();
                vstarttimer = true;
                connBtn.text = qsTr("Waiting your opponent to start") + "..."
            }
        }

        Button {
            text:qsTr("Settings")
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                pageStack.clear()
                pageStack.push(Qt.resolvedUrl("Asetukset.qml"))
            }
        }

        Component.onCompleted: {
            isMyStart ? conTcpSrv.stime = valkomax : conTcpSrv.stime = mustamax;
            //conTcpSrv.sincrem = increment;
            Mysets.loadInstantSetting();
        }
    }
}
