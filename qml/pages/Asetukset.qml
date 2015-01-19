import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
//Kesken
//            MenuItem {
//                text: qsTr("Tietoja")
//                enabled: false
//                onClicked: pageStack.pop()
//            }
            MenuItem {
                text: qsTr("Palaa peliin")
                onClicked: pageStack.pop()
            }
        }

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Asetussivu")
            }

            Label {
                x: Theme.paddingLarge
                text: qsTr("Valkoinen ") + valkomax/60 + qsTr(" min")
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
                text: qsTr("Musta ") + mustamax/60 + qsTr(" min")
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
                text: qsTr("Lisäys/siirto ") + increment + qsTr(" s")
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
