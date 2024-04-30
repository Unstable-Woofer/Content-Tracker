#ifndef TABLEPRODUCTIONLIST_H
#define TABLEPRODUCTIONLIST_H

#include <QJsonArray>
#include <QJsonObject>
#include <QObject>

class TableProductionList : public QObject {
    Q_OBJECT

    Q_PROPERTY(QJsonArray list READ list CONSTANT)

public:
    explicit TableProductionList(QObject *parent = nullptr);

    QJsonArray list();

    Q_INVOKABLE void add(QString name, QString date);

signals:
    void productionAdded(QString uid);
    void productionAddError(QString error);
};

#endif // TABLEPRODUCTIONLIST_H
