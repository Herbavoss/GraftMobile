#ifndef GRAFTPOSCLIENT_H
#define GRAFTPOSCLIENT_H

#include "graftbaseclient.h"
#include <QSettings>

class SelectedProductProxyModel;
class PatrickQRCodeEncoder;
class ProductModel;
class GraftPOSAPI;

class GraftPOSClient : public GraftBaseClient
{
    Q_OBJECT
public:
    explicit GraftPOSClient(QObject *parent = nullptr);
    ~GraftPOSClient();

    ProductModel *productModel() const;
    SelectedProductProxyModel *selectedProductModel() const;

    Q_INVOKABLE void setSettings(const QString &key, const QVariant &value);
    Q_INVOKABLE QVariant settings(const QString &key) const;
    Q_INVOKABLE void saveSettings() const;

signals:
    void saleReceived(bool result);
    void rejectSaleReceived(bool result);
    void saleStatusReceived(bool result);

public slots:
    void save();
    void sale();
    void rejectSale();
    void getSaleStatus();

private slots:
    void receiveSale(int result);
    void receiveRejectSale(int result);
    void receiveSaleStatus(int result, int saleStatus);

private:
    void initProductModels();
    void initSettings();

    GraftPOSAPI *mApi;
    PatrickQRCodeEncoder *mQRCodeEncoder;
    QString mPID;
    ProductModel *mProductModel;
    SelectedProductProxyModel *mSelectedProductModel;
    QSettings *mSettings;
};

#endif // GRAFTPOSCLIENT_H
