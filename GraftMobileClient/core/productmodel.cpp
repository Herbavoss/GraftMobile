#include "productmodel.h"
#include "productitem.h"

ProductModel::ProductModel(QObject *parent)
    : QAbstractListModel(parent)
    ,mQuickDealMode(false)
{}

ProductModel::~ProductModel()
{
    qDeleteAll(mProducts);
}

QVariant ProductModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= mProducts.count())
    {
        return QVariant();
    }

    ProductItem *productItem = mProducts[index.row()];
    Q_ASSERT(productItem);
    switch (role) {
    case TitleRole:
        return productItem->name();
    case CostRole:
        return productItem->cost();
    case ImageRole:
        return productItem->imagePath();
    case SelectedRole:
        return productItem->isSelected();
    case CurrencyRole:
        return productItem->currency();
    case DescriptionRole:
        return productItem->description();
    default:
        return QVariant();
    }
}

bool ProductModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.isValid() && value.isValid() && data(index, role) != value)
    {
        switch (role)
        {
        case TitleRole:
            mProducts[index.row()]->setName(value.toString());
            break;
        case CostRole:
            mProducts[index.row()]->setCost(value.toDouble());
            break;
        case ImageRole:
            mProducts[index.row()]->setImagePath(value.toString());
            break;
        case SelectedRole:
            mProducts[index.row()]->setSelected(value.toBool());
            break;
        case CurrencyRole:
            mProducts[index.row()]->setCurrency(value.toString());
            break;
        case DescriptionRole:
            mProducts[index.row()]->setDescription(value.toString());
            break;
        default:
            break;
        }
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

int ProductModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return mProducts.count();
}

QVector<ProductItem *> ProductModel::products() const
{
    return mProducts;
}

void ProductModel::changeSelection(int index)
{
    ProductItem* lProduct = mProducts.value(index);
    if (lProduct)
    {
        lProduct->changeSelection();
        QVector<int> changeRole;
        changeRole.append(SelectedRole);
        QModelIndex modelIndex = this->index(index);
        emit dataChanged(modelIndex, modelIndex, changeRole);
        emit selectedProductCountChanged(selectedProductCount());
    }
}

double ProductModel::totalCost() const
{
    double total = 0;
    for (int i = 0; i < mProducts.count(); ++i)
    {
        ProductItem *item = mProducts.value(i);
        if (item->isSelected())
        {
            total += item->cost();
        }
    }
    return total;
}

unsigned int ProductModel::selectedProductCount() const
{
    unsigned int count = 0;
    for (int i = 0; i < mProducts.count(); ++i)
    {
        ProductItem *item = mProducts.value(i);
        if (item->isSelected())
        {
            ++count;
        }
    }
    return count;
}

QVariant ProductModel::productData(int index, int role) const
{
    QModelIndex modelIndex = this->index(index);
    return data(modelIndex, role);
}

bool ProductModel::setProductData(int index, const QVariant &value, int role)
{
    QModelIndex modelIndex = this->index(index);
    return setData(modelIndex, value, role);
}

void ProductModel::removeProduct(int index)
{
    beginRemoveRows(QModelIndex(), index, index);
    mProducts.at(index)->removeImage();
    delete mProducts.takeAt(index);
    endRemoveRows();
    emit selectedProductCountChanged(selectedProductCount());
}

void ProductModel::clearSelections()
{
    if (quickDealMode())
    {
        removeSelectedProducts();
    }
    else
    {
        for (int i = 0; i < mProducts.count(); ++i)
        {
            ProductItem *item = mProducts.value(i);
            if (item->isSelected())
            {
                item->setSelected(false);
                QVector<int> changeRole;
                changeRole.append(SelectedRole);
                QModelIndex modelIndex = this->index(i);
                emit dataChanged(modelIndex, modelIndex, changeRole);
            }
        }
    }
    emit selectedProductCountChanged(0);
}

void ProductModel::clear()
{
    beginRemoveRows(QModelIndex(), 0, mProducts.count());
    qDeleteAll(mProducts);
    mProducts.clear();
    endRemoveRows();
}

void ProductModel::add(const QString &imagePath, const QString &name, double cost,
                       const QString &currency, const QString &description)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    mProducts << (new ProductItem(imagePath, name, cost, currency, description));
    endInsertRows();
}

QHash<int, QByteArray> ProductModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "name";
    roles[CostRole] = "cost";
    roles[ImageRole] = "imagePath";
    roles[SelectedRole] = "selected";
    roles[CurrencyRole] = "currency";
    roles[DescriptionRole] = "description";
    return roles;
}

bool ProductModel::quickDealMode() const
{
    return mQuickDealMode;
}

void ProductModel::setQuickDealMode(bool quickDealMode)
{
    clearSelections();
    mQuickDealMode = quickDealMode;
}

int ProductModel::totalProductsCount() const
{
    return rowCount();
}

void ProductModel::removeSelectedProducts()
{
    if (quickDealMode())
    {
        for (int i = 0; i < mProducts.count(); ++i)
        {
            if (mProducts.at(i)->isSelected())
            {
                beginRemoveRows(QModelIndex(), i, i);
                delete mProducts.takeAt(i);
                endRemoveRows();
                i--;
            }
        }
        mQuickDealMode = false;
    }
}
