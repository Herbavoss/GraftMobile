#ifndef QUICKEXCHANGEMODEL_H
#define QUICKEXCHANGEMODEL_H

#include <QAbstractListModel>

class QuickExchangeItem;

class QuickExchangeModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum QuickExchangeRole {
        IconPathRole = Qt::UserRole + 1,
        NameRole,
        CodeRole,
        PriceRole,
        PrimaryRole,
    };
    Q_ENUM(QuickExchangeRole)

    explicit QuickExchangeModel(QObject *parent = nullptr);
    ~QuickExchangeModel();

    QVariant data(const QModelIndex &index, int role) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QStringList codeList() const;
    void updatePrice(const QString &code, const QString &price);

    QString imagePath(const QString &code) const;

public slots:
    void add(const QString &name, const QString &code, const QString &price = QString(),
             bool primary = false);
    void clear();

protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    QVector<QuickExchangeItem*> mQuickExchangeItems;
};

#endif // QUICKEXCHANGEMODEL_H
