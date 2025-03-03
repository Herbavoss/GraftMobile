import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0

Button {
    id: headerButton

    property alias name: label.text

    flat: true
    Material.foreground: pressed ? "#616A78" : ColorFactory.color(DesignFactory.LightText)
    background: Item {
        anchors.fill: parent

        Label {
            id: label
            anchors.centerIn: parent
            font.pixelSize: 17
            color: headerButton.enabled ? "#FFFFFF" : "#5C6675"
        }
    }
}
