import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import com.graft.design 1.0
import org.graft.models 1.0
import com.device.platform 1.0
import org.navigation.attached.properties 1.0
import "../components"
import "../"

BaseScreen {
    id: editingItem
    title: qsTr("Add item")
    action: confirmProductParameters
    screenHeader.actionButtonState: true

    property alias currencyModel: productItem.currencyModel
    property int index: -1

    Component.onCompleted: {
        if (Detector.isPlatform(Platform.IOS | Platform.Desktop)) {
            navigationText: qsTr("Cancel")
            actionText: qsTr("Done")
        }
    }

    onIndexChanged: {
        title = qsTr("Edit item")
        multiTaskingButton.text = qsTr("Save")
        productItem.titleText = ProductModel.productData(index, ProductModelEnum.TitleRole)
        productItem.productImage = ProductModel.productData(index, ProductModelEnum.ImageRole)
        productItem.price = ProductModel.productData(index, ProductModelEnum.CostRole)
        productItem.descriptionText = ProductModel.productData(index, ProductModelEnum.DescriptionRole)
        productItem.currencyIndex = currencyModel.indexOf(ProductModel.productData(index,
                                    ProductModelEnum.CurrencyRole))
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: 15
        }

        ProductItemView {
            id: productItem
            Layout.fillWidth: true
            Layout.fillHeight: true
            screenHeight: height
            screenWidth: width
        }

        WideActionButton {
            id: multiTaskingButton
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            text: qsTr("Confirm")
            KeyNavigation.tab: editingItem.Navigation.implicitFirstComponent
            onClicked: confirmProductParameters()
        }
    }

    function confirmProductParameters() {
        if (!openScreenDialog(productItem.titleText, productItem.price)) {
            disableScreen()
            if (index >= 0) {
                ProductModel.setProductData(index, productItem.titleText, ProductModelEnum.TitleRole)
                ProductModel.setProductData(index, productItem.productImage, ProductModelEnum.ImageRole)
                ProductModel.setProductData(index, productItem.price, ProductModelEnum.CostRole)
                ProductModel.setProductData(index, productItem.currencyText,
                                            ProductModelEnum.CurrencyRole)
                ProductModel.setProductData(index, productItem.descriptionText,
                                            ProductModelEnum.DescriptionRole)
            } else {
                ProductModel.add(productItem.productImage, productItem.titleText, productItem.price,
                                 productItem.currencyText, productItem.descriptionText)
            }
            editingItem.pushScreen.goBack()
            GraftClient.saveProducts()
        }
    }
}
