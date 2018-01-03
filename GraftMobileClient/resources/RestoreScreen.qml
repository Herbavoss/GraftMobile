import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "components"

BaseScreen {
    id: root
    title: qsTr("Restore wallet")
    action: restoreWallet
    screenHeader {
        navigationButtonState: Qt.platform.os === "ios"
        actionButtonState: true
    }

    Component.onCompleted: {
        if (Qt.platform.os === "ios") {
            navigationText: qsTr("Cancel")
            actionText: qsTr("Restore")
        }
    }

    Connections {
        target: GraftClient

        onRestoreAccountReceived: {
            pushScreen.openMainScreen()
        }
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: 15
        }

        LinearEditItem {
            id: seedTextField
            Layout.fillWidth: true
            Layout.maximumHeight: 130
            Layout.alignment: Qt.AlignTop
            title: qsTr("Mnemonic Phrase")
            wrapMode: TextInput.WordWrap
            letterCountingMode: false
            maximumLength: 25
            validator: RegExpValidator {
                regExp: /^([^\s]([a-z]+\s){24}([a-z]+){1})/g
            }
            inputMethodHints: Qt.ImhNoPredictiveText
        }

        LinearEditItem {
            id: passwordTextField
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            title: Qt.platform.os === "ios" ? qsTr("Password:") : qsTr("Password")
            maximumLength: 50
            echoMode: TextInput.Password
            passwordCharacter: '•'
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        WideActionButton {
            id: restoreWalletButton
            Layout.alignment: Qt.AlignBottom
            text: qsTr("Restore wallet")
            onClicked: {
                root.state = "restoreWalletPressed"
                restoreWallet()
            }
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
    }

    states: [
        State {
            name: "restoreWalletPressed"

            PropertyChanges {
                target: busyIndicator
                running: true
            }
            PropertyChanges {
                target: root
                enabled: false
            }
        }
    ]

    function restoreWallet() {
        GraftClient.restoreAccount(seedTextField.text, passwordTextField.text)
    }
}