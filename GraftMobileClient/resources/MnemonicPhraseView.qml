import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

GridLayout {
    id: gridLayout

    property string bigString: ""
    readonly property int mnemonicPhraseSize: 25

    anchors {
        verticalCenter: parent.verticalCenter
        left: parent.left
        right: parent.right
        leftMargin: 5
        rightMargin: 5
    }
    columns: 5
    rows: 5
    columnSpacing: 5
    rowSpacing: 35

    Repeater {
        id: repeater
        model: bigString.split(' ', mnemonicPhraseSize)

        Label {
            font.pointSize: 20
            Layout.alignment: Qt.AlignHCenter
            text: modelData
        }
    }
}
