#ifndef FILEMANAGER_H
#define FILEMANAGER_H

#include <QObject>

class FileManager : public QObject {
    Q_OBJECT

public:
    explicit FileManager(QObject *parent = nullptr);

    Q_INVOKABLE bool isVideo(QString filepath);
    Q_INVOKABLE bool isImage(QString filepath);
    Q_INVOKABLE QJsonObject uploadFileEdit(QString filepath, QString productionUid);
    Q_INVOKABLE QJsonObject uploadFileRaw(QString filepath, QString productionUid);
    Q_INVOKABLE void createFolderProduction(QString uid);
    Q_INVOKABLE void openFileLocation(QString filepath);

signals:
};

#endif // FILEMANAGER_H
