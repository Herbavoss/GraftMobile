import QtQuick 2.9
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import org.graft 1.0
import "../"
import "../components"

GraftApplicationWindow {
    id: root
    title: qsTr("WALLET")

    property bool allowClose: false

    signal animationCompleted()

    Loader {
        id: drawerLoader
        onLoaded: {
            drawerLoader.item.pushScreen = menuTransitions()
            drawerLoader.item.balanceInGraft = GraftClient.balance(GraftClientTools.UnlockedBalance)
            drawerLoader.item.interactive = mainLayout.currentIndex > 1
        }
    }

    footer: Item {
        id: graftApplicationFooter
        height: Qt.platform.os === "ios" ? 49 : 0
        visible: !createWalletStackViewer.visible

        Loader {
            id: footerLoader
            anchors.fill: parent
            onLoaded: footerLoader.item.pushScreen = menuTransitions()
        }
    }

    Component.onCompleted: {
        if (Qt.platform.os === "ios") {
            footerLoader.source = "qrc:/wallet/GraftToolBar.qml"
        } else {
            drawerLoader.source = "qrc:/wallet/GraftMenu.qml"
        }
    }

    Connections {
        target: GraftClient

        onErrorReceived: {
            if (message !== "") {
                messageDialog.title = qsTr("Network Error")
                messageDialog.text = message
            } else {
                messageDialog.title = qsTr("Pay failed!")
                messageDialog.text = qsTr("Pay request failed.\nPlease try again.")
            }
            messageDialog.open()
        }
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("Pay failed!")
        icon: StandardIcon.Warning
        text: qsTr("Pay request failed.\nPlease try again.")
        standardButtons: MessageDialog.Ok
        onAccepted: {
            if (GraftClient.isAccountExists()) {
                openMainScreen()
            }
        }
    }

    PopupMessageLabel {
        id: closeLabel
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 35
        }
        labelText: qsTr("Please, click again to close \nthe application.")
        opacityAnimator.onStopped: animationCompleted()
    }

    onAnimationCompleted: allowClose = false

    SwipeView {
        id: mainLayout
        anchors.fill: parent
        interactive: false
        currentIndex: GraftClient.settings("license") ? GraftClient.isAccountExists() ? 2 : 1 : 0
        focus: true
        Keys.onReleased: {
            if (event.key === Qt.Key_Back || event.key === Qt.Key_Escape) {
                if (!event.accepted) {
                    if (allowClose) {
                        event.accepted = false
                    } else {
                        showCloseLabel()
                        event.accepted = true
                    }
                    allowClose = !allowClose
                }
            }
        }

        onCurrentIndexChanged: {
            if (Qt.platform.os === "ios") {
                graftApplicationFooter.visible = currentIndex > 1
            } else {
                if (drawerLoader && drawerLoader.status === Loader.Ready) {
                    drawerLoader.item.interactive = currentIndex > 1
                }
            }
        }

        LicenseAgreementScreen {
            id: licenseScreen
            logoImage: "qrc:/imgs/graft-wallet-logo.png"
            acceptAction: acceptLicense
        }

        CreateWalletStackViewer {
            id: createWalletStackViewer
            pushScreen: generalTransitions()
            menuLoader: drawerLoader
            isActive: SwipeView.isCurrentItem
        }

        WalletStackViewer {
            id: walletViewer
            pushScreen: generalTransitions()
            menuLoader: drawerLoader
            isActive: SwipeView.isCurrentItem
        }

        SettingsStackViewer {
            id: settingsStackViewer
            pushScreen: generalTransitions()
            appType: "wallet"
            isActive: SwipeView.isCurrentItem
        }
    }

    function generalTransitions() {
        var transitionsMap = {}
        transitionsMap["showMenu"] = showMenu
        transitionsMap["hideMenu"] = hideMenu
        transitionsMap["openMainScreen"] = openMainScreen
        transitionsMap["openCreateWalletStackViewer"] = openCreateWalletStackViewer
        return transitionsMap
    }

    function menuTransitions() {
        var transitionsMap = {}
        transitionsMap["hideMenu"] = hideMenu
        transitionsMap["openSettingsScreen"] = openSettingsScreen
        transitionsMap["openMainScreen"] = openMainScreen
        return transitionsMap
    }

    function showMenu() {
        drawerLoader.item.open()
    }

    function hideMenu() {
        drawerLoader.item.close()
    }

    function openMainScreen() {
        mainLayout.currentIndex = 2
        selectButton("Wallet")
    }

    function openCreateWalletStackViewer() {
        mainLayout.currentIndex = 1
    }

    function openSettingsScreen() {
        mainLayout.currentIndex = 3
        selectButton("Settings")
    }

    function selectButton(name) {
        if (Qt.platform.os === "ios") {
            footerLoader.item.seclectedButtonChanged(name)
        }
    }

    function acceptLicense() {
        GraftClient.setSettings("license", true)
        GraftClient.saveSettings()
        if (GraftClient.isAccountExists()) {
            openMainScreen()
        } else {
            openCreateWalletStackViewer()
        }
    }

    function showCloseLabel() {
        closeLabel.opacity = 1.0
        closeLabel.timer.start()
    }
}
