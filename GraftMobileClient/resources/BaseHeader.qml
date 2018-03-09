import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Rectangle {
    signal actionButtonClicked()
    signal navigationButtonClicked()

    property string headerText
    property bool navigationButtonState: false
    property bool actionButtonState: false
    property bool cartEnable: false
    property int selectedProductCount: 0
    property bool isNavigationButtonVisible: true
}
