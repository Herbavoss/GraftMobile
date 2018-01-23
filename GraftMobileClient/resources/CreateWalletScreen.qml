import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "components"

BaseScreen {
    id: root
    title: qsTr("Create wallet")
    screenHeader.navigationButtonState: Qt.platform.os === "ios"

    Connections {
        target: GraftClient

        onCreateAccountReceived: {
            if (isAccountCreated) {
                pushScreen.openMnemonicViewScreen(false)
            } else {
                root.state = "accountNotExist"
            }
        }
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: 15
        }

//qweqwe
        PasswordFields {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
        }

        WideActionButton {
            id: createWalletButton
            Layout.bottomMargin: 15
            text: qsTr("Create New Wallet")
            onClicked: {
                root.state = "createWalletPressed"
                GraftClient.createAccount(passwordTextField.text)
            }
        }

        Item {
            Layout.fillHeight: true
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            Label {
                Layout.fillWidth: true
                horizontalAlignment: Label.AlignHCenter
                font {
                    bold: true
                    pointSize: 18
                }
                color: "#BBBBBB"
                text: qsTr("If you have one")
            }

            Label {
                Layout.fillWidth: true
                horizontalAlignment: Label.AlignHCenter
                color: "#BBBBBB"
                text: qsTr("Restore wallet from mnemonic phrase")
            }
        }

        WideActionButton {
            id: restoreWalletButton
            Layout.alignment: Qt.AlignBottom
            Layout.bottomMargin: 15
            text: qsTr("Restore Wallet")
            onClicked: pushScreen.openRestoreWalletScreen()
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
    }

    states: [
        State {
            name: "createWalletPressed"

            PropertyChanges {
                target: busyIndicator
                running: true
            }
            PropertyChanges {
                target: root
                enabled: false
            }
        },
        State {
            name: "accountNotExist"

            PropertyChanges {
                target: busyIndicator
                running: false
            }
            PropertyChanges {
                target: root
                enabled: true
            }
        }
    ]
}
