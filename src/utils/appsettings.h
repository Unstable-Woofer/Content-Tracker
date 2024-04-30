#ifndef APPSETTINGS_H
#define APPSETTINGS_H

#include <QObject>

class AppSettings : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString contentDirectory READ contentDirectory WRITE setContentDirectory NOTIFY contentDirectoryChanged FINAL)
    Q_PROPERTY(QString uploadMethod READ uploadMethod WRITE setUploadMethod CONSTANT)

public:
    explicit AppSettings(QObject *parent = nullptr);

    static QString contentDirectory();
    static QString uploadMethod();

    void setContentDirectory(QString contentDirectory);
    void setUploadMethod(QString method);

signals:
    void contentDirectoryChanged();
};

#endif // APPSETTINGS_H
