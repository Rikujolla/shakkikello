import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            quickSelect: true
            MenuItem {
                text: qsTr("Mustan vuoro")
                onClicked: vuoro.vaihdaMustalle()
            }
        }

        PushUpMenu {
            quickSelect: true
            MenuItem {
                text: qsTr("Valkoisen vuoro")
                onClicked: vuoro.vaihdaValkealle()
            }
        }

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Shakkikello")
            }


            Item {
                id : vuoro
                function vaihdaMustalle() {
                    if (tilat.musta == true) {} else {
                        startti.timeAsetus();
                        tilat.musta = !tilat.musta; tilat.valko = !tilat.valko;
                        kello.sekuntit = 0;
                        valkokello.timeValko();
                        valkokello.sekuntitv = 0;
                        muttakello.timeMutta();
                        muttakello.sekuntitm=0
                    }
                }
                function vaihdaValkealle() {
                    if (tilat.valko == true) {} else {
                        startti.timeAsetus();
                        tilat.musta = !tilat.musta; tilat.valko = !tilat.valko;
                        kello.sekuntit = 0;
                        valkokello.timeValko();
                        valkokello.sekuntitv = 0;
                        muttakello.timeMutta();
                        muttakello.sekuntitm=0
                    }
                }
            }

            Item {
                id : tilat
                property bool musta
                property bool valko
                property bool juoksee
                property bool pelialkoi : false
                function asetaTilat() {
                    musta = false
                    valko = true
                    juoksee = false
                    pelialkoi = false
                }
                function vaihdaTila() {
                    if (pelialkoi == true && juoksee == true)  { aloitapause = qsTr("Keskeytä")} else {aloitapause = qsTr("Jatka")
                    }
                }
                function aloitaPeli() {
                    pelialkoi = true
                }
            }

            Item {
                id : muttakello
                property int sekuntitm0: 0
                property int sekuntitm : 0
                property int label_sekuntitm
                property int label_minuutitm : mustamax/60
                function timeMutta() {sekuntitm0 = sekuntitm0 + sekuntitm}
                function updateMutta() {sekuntitm = kello.sekuntit;
                    label_sekuntitm = (mustamax - (sekuntitm0 + sekuntitm))%60;
                    label_minuutitm = ((mustamax - (sekuntitm0 + sekuntitm))-label_sekuntitm)/60
                }
            }

            Item {
                id : valkokello
                property int sekuntitv: 0
                property int sekuntitv0: 0
                property int label_sekuntitv
                property int label_minuutitv : valkomax/60
                function timeValko() {sekuntitv0 = sekuntitv0 + sekuntitv}
                function updateValko() {sekuntitv = kello.sekuntit;
                    label_sekuntitv = (valkomax - (sekuntitv0 + sekuntitv))%60;
                    label_minuutitv = ((valkomax - (sekuntitv0 + sekuntitv))-label_sekuntitv)/60
                }
            }

            Item {
                id : startti
                property int hours0
                property int minutes0
                property int sekuntit0
                function timeAsetus() {
                    var date0 = new Date;
                    hours0 = date0.getHours()
                    minutes0 = date0.getMinutes()
                    sekuntit0= date0.getSeconds()
                }
            }

            Item {
                id : asetussivulle
                function siirrytKo() {
                    if (tilat.pelialkoi == true) {
                        maharollisuuret = qsTr("Asetukset");
                        tilat.asetaTilat();
                        valkomax = 300;
                        mustamax = 300;
                        valkokello.sekuntitv0 = 0;
                        valkokello.sekuntitv = 0;
                        muttakello.sekuntitm0 = 0;
                        muttakello.sekuntitm = 0;
                        kello.sekuntit = 0;
                        valkokello.updateValko();
                        muttakello.updateMutta()
                    } else {
                        pageStack.push(Qt.resolvedUrl("Asetukset.qml"))
                    }
                }
            }

            Item {
               id : kello
               property int hours
               property int minutes
               property int sekuntit
               function timeChanged() {
                   var date = new Date;
                   hours = date.getHours()-startti.hours0
                   minutes = date.getMinutes()-startti.minutes0+60*hours
                   sekuntit= date.getSeconds()-startti.sekuntit0+60*minutes
               }
           }



            Timer {
                interval: 50; running: true; repeat: false
                onTriggered: {startti.timeAsetus();valkokello.timeValko();muttakello.timeMutta();tilat.asetaTilat()}
            }

            Timer {
                interval: 100; running: tilat.juoksee; repeat: true
                onTriggered: {kello.timeChanged()}
            }


            Row {
                Image {
                    source: "vaihtoValkoinen.png"
                }
                Text {
                    text: qsTr("Valkoisen kello")
                    color: Theme.highlightColor
                }
            }

            ProgressBar {
                id: progressBar2
                width: parent.width
                maximumValue: valkomax
                valueText: valkokello.label_minuutitv + ":" + valkokello.label_sekuntitv
                label: qsTr("min:s")
                value: valkomax - (valkokello.sekuntitv0 + valkokello.sekuntitv)
                Timer {
                    interval: 100; running: tilat.valko; repeat: true
                    onTriggered: valkokello.updateValko()
                }
            }

            Text {
                text: qsTr("              Ohjaukset")
                color: Theme.highlightColor
            }

            Row {
                spacing: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    text: aloitapause
                    onClicked: {tilat.juoksee = !tilat.juoksee;startti.timeAsetus()
                        tilat.aloitaPeli();
                        kello.sekuntit = 0;
                        valkokello.timeValko();
                        valkokello.sekuntitv = 0;
                        muttakello.timeMutta();
                        muttakello.sekuntitm=0;
                        tilat.vaihdaTila();
                        maharollisuuret = qsTr("Nollaa")
                    }
                }
                Button {
                    text: maharollisuuret
                    onClicked: asetussivulle.siirrytKo()
                    enabled: !tilat.juoksee
                }
            }

            Row {
                Image {
                    source: "vaihtoMusta.png"
                }
                Text {
                    text: qsTr("Mustan kello")
                    color: Theme.highlightColor
                }
            }


            ProgressBar {
                id: progressBarm
                width: parent.width
                maximumValue: mustamax
                valueText: muttakello.label_minuutitm + ":" + muttakello.label_sekuntitm
                label: qsTr("min:s")
                value: mustamax - (muttakello.sekuntitm0 + muttakello.sekuntitm)
                Timer {interval: 100; running: tilat.musta; repeat: true
                    onTriggered: muttakello.updateMutta()}
            }




        }
    }
}
