#include "filemanager.h"
#include "appsettings.h"

#include <QCryptographicHash>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QImageReader>
#include <QJsonObject>
#include <QMediaPlayer>
#include <QProcess>

#include <QDebug>

FileManager::FileManager(QObject *parent) : QObject{parent} {
    AppSettings settings;
    QString contentDirectory = settings.contentDirectory();

    if (contentDirectory.isEmpty() || contentDirectory.isNull()) {
        settings.setContentDirectory(QDir::currentPath() + "/Files");
        contentDirectory = settings.contentDirectory();
    }

    QDir folderRoot(contentDirectory);

    if (!folderRoot.exists())
        folderRoot.mkdir(contentDirectory);
}

bool FileManager::isImage(QString filePath) {
    QImageReader reader(filePath);
    return reader.canRead();
}

bool FileManager::isVideo(QString filepath) {
    QMediaPlayer player;
    player.setSource(QUrl::fromLocalFile(filepath));
    player.play();

    while (player.mediaStatus() == QMediaPlayer::LoadingMedia)
        qApp->processEvents();

    bool hasVideo = player.hasVideo();
    player.stop();

    return hasVideo;
}

QJsonObject FileManager::uploadFileEdit(QString filepath, QString productionUid) {
    QString folderRoot = QString("%1/%2/Edits").arg(AppSettings::contentDirectory(), productionUid);

    QFileInfo fileInfo(filepath);
    QString filename = fileInfo.fileName();
    QString uploadPath = QString("%1/%2").arg(folderRoot, filename);

    if (AppSettings::uploadMethod() == "move")
        QFile::rename(filepath, uploadPath);
    else
        QFile::copy(filepath, uploadPath);

    QJsonObject result;
    result["filename"] = filename;
    result["filepath"] = uploadPath;

    QFile uploadedFile(uploadPath);

    if (uploadedFile.open(QFile::ReadOnly)) {
        QCryptographicHash filehash(QCryptographicHash::Sha1);

        while (!uploadedFile.atEnd()) {
            filehash.addData(uploadedFile.read(4096));
        }

        uploadedFile.close();
        result["filehash"] = QString(filehash.result().toHex());
    }

    return result;
}

QJsonObject FileManager::uploadFileRaw(QString filepath, QString productionUid) {
    QString folderRoot = QString("%1/%2/Raw").arg(AppSettings::contentDirectory(), productionUid);

    QFileInfo fileInfo(filepath);
    QString filename = fileInfo.fileName();
    QString uploadPath = QString("%1/%2").arg(folderRoot, filename);

    if (AppSettings::uploadMethod() == "move")
        QFile::rename(filepath, uploadPath);
    else
        QFile::copy(filepath, uploadPath);

    QJsonObject result;
    result["filename"] = filename;
    result["filepath"] = uploadPath;

    QFile uploadedFile(uploadPath);

    if (uploadedFile.open(QFile::ReadOnly)) {
        QCryptographicHash filehash(QCryptographicHash::Sha1);

        while (!uploadedFile.atEnd()) {
            filehash.addData(uploadedFile.read(4096));
        }

        uploadedFile.close();
        result["filehash"] = QString(filehash.result().toHex());
    }

    return result;
}

void FileManager::createFolderProduction(QString uid) {
    QString folderRoot = QString("%1/%2").arg(AppSettings::contentDirectory(), uid);

    QDir().mkpath(folderRoot);
    QDir().mkpath(QString("%1/Edits").arg(folderRoot));
    QDir().mkpath(QString("%1/Raw").arg(folderRoot));
}

void FileManager::openFileLocation(QString filepath) {
    QFileInfo info(filepath);
    QStringList args;

    if (!info.isDir())
        args << "/select,";

    args << QDir::toNativeSeparators(filepath);

    QProcess::startDetached("explorer", args);
}
