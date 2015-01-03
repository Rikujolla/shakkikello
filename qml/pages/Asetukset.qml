import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
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

        }
    }
}
