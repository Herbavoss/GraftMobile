import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

ColumnLayout {
    id: linearEditItem
    property alias title: titleItem.text
    property alias text: editItem.text
    property alias wrapMode: editItem.wrapMode
    property alias inputMethodHints: editItem.inputMethodHints
    property alias validator: editItem.validator
    property alias showLengthIndicator: textCount.visible
    property alias inputMask: editItem.inputMask
    property alias echoMode: editItem.echoMode
    property bool letterCountingMode: true
    property int maximumLength: 32767
    property alias passwordCharacter: editItem.passwordCharacter

    spacing: 0

    Text {
        id: titleItem
        Layout.fillWidth: true
        color: "#BBBBBB"
        font.pointSize: 12
    }

    TextField {
        id: editItem
        Layout.fillWidth: true
        verticalAlignment: Qt.AlignTop
        color: "#404040"
        onWrapModeChanged: {
            if (wrapMode === TextField.NoWrap) {
                Layout.fillHeight = false
            } else {
                Layout.fillHeight = true
                Layout.maximumHeight = 200
            }
        }
        maximumLength: letterCountingMode ? linearEditItem.maximumLength : 32767
    }

    Text {
        id: textCount
        Layout.alignment: Qt.AlignRight
        text: qsTr("%1 / %2").arg(letterCountingMode ? editItem.displayText.length :
                                                       wordCounting()).arg(maximumLength)
        color: "#BBBBBB"
        font.pointSize: 12
    }

    function wordCounting() {
        if (editItem.displayText.length !== 0) {
            var wordList = GraftClient.wideSpacingSimplifyRemove(seedTextField.text).split(' ')
            return wordList.length
        } else {
            return 0
        }
    }
}
