#ifndef TABLEPRODUCTION_H
#define TABLEPRODUCTION_H

#include <QJsonObject>
#include <QObject>

class TableProduction : public QObject {
    Q_OBJECT

    Q_PROPERTY(QJsonObject editFiles READ editFiles CONSTANT)
    Q_PROPERTY(QJsonObject rawFiles READ rawFiles CONSTANT)
    Q_PROPERTY(QString productionName READ productionName CONSTANT)
    Q_PROPERTY(QString tableUid READ tableUid WRITE setTableUid CONSTANT)

public:
    explicit TableProduction(QObject *parent = nullptr);

    QString productionName();
    QString tableUid();
    QJsonObject editFiles();
    QJsonObject rawFiles();

    void setTableUid(QString hash);

    static bool createTable(QString uid, QString name);

    Q_INVOKABLE void addEditFile(QJsonObject fileinfo);
    Q_INVOKABLE void addRawFile(QJsonObject fileinfo);

private:
    QString p_tableUid;

signals:
    void fileEditAdded();
    void fileRawAdded();
};

#endif // TABLEPRODUCTION_H
