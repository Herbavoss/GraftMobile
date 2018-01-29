import QtQuick 2.9
import QtQuick.Layouts 1.3
import com.graft.design 1.0
import "../"

BaseHeader {
    id: rootItem
    height: 60
    color: ColorFactory.color(DesignFactory.Foreground)

    onNavigationButtonStateChanged: {
        if (navigationButtonState) {
            menuIcon.source = "qrc:/imgs/menu_icon.png"
            menuIcon.width = 24
        } else {
            menuIcon.source = "qrc:/imgs/back_icon.png"
            menuIcon.width = 20
        }
    }

    RowLayout {
        anchors {
            fill: parent
            leftMargin: 15
            rightMargin: 15
        }

        Item {
            Layout.fillHeight: true
            Layout.preferredWidth: 24
            Layout.alignment: Qt.AlignLeft
            visible: isNavigationButtonVisible

            Image {
                id: menuIcon
                width: 20
                height: 18
                anchors.centerIn: parent
                source: "qrc:/imgs/back_icon.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: navigationButtonClicked()
            }
        }

        Text {
            Layout.fillWidth: true
            Layout.leftMargin: isNavigationButtonVisible ? 25 : 5
            Layout.alignment: Qt.AlignLeft
            text: rootItem.headerText
            font {
                bold: true
                pixelSize: 17
            }
            color: ColorFactory.color(DesignFactory.LightText)
        }

        CartItem {
            visible: rootItem.cartEnable
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.alignment: Qt.AlignRight
            productCount: rootItem.selectedProductCount
        }

        Item {
            Layout.fillHeight: true
            Layout.preferredWidth: 24
            Layout.alignment: Qt.AlignRight
            visible: rootItem.actionButtonState

            Image {
                height: 15
                width: 23
                anchors.centerIn: parent
                source: "qrc:/imgs/done.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: actionButtonClicked()
            }
        }
    }
}
