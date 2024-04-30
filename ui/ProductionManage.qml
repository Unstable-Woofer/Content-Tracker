import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import Qt.labs.platform

import ContentTracker.Database

Page {
    function buildFileListEdits() {
        let editFiles = dbTableProduction.editFiles

        listFilesEdits.model.clear();

        for (var key in editFiles) {
            listFilesEdits.model.append(editFiles[key])
        }
    }

    function buildFileListRaw() {
        let rawFiles = dbTableProduction.rawFiles

        listFilesRaw.model.clear();

        for (var key in rawFiles) {
            listFilesRaw.model.append(rawFiles[key])
        }
    }

    function buildSiteList() {
        let sites = dbTableSiteList.sites

        listSites.model.clear()

        for (var key in sites) {
            listSites.model.append(sites[key])
        }
    }

    function previewFile(filepath) {
        itemPreviewVideo.visible=false
        itemPreviewImage.visible=false

        if (mediaPlayer.playbackState == MediaPlayer.PlayingState || mediaPlayer.playbackState == MediaPlayer.PausedState)
            mediaPlayer.stop()

        if (fileManager.isImage(filepath)) {
            imageLoader.source="file:///" + filepath
            itemPreviewImage.visible=true
        } else if (fileManager.isVideo(filepath)) {
            itemPreviewVideo.visible=true
            mediaPlayer.source="file:///"+filepath
        }
    }

    property var tableUid

    Component.onCompleted: {
        dbTableProduction.tableUid=tableUid
        toolbarTitle.text=dbTableProduction.productionName

        buildFileListEdits()
        buildFileListRaw()
        buildSiteList()
    }

    Rectangle {
        id: containerFiles
        color: "transparent"
        height: (parent.height * 0.30); width: parent.width

        Column {
            height: parent.height; width: (parent.width * 0.5)

            ListView {
                id: listFilesRaw
                delegate: Rectangle {
                    color: (listFilesRaw.selectedIndex == index) ? "lightblue" : ((index % 2) === 0) ? "transparent" : "lightgray"
                    height: (Qt.application.font.pixelSize * 2); width: listFilesRaw.width

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: filename
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            listFilesRaw.selectedIndex=index
                            previewFile(filepath)
                        }
                    }
                }
                header: Rectangle {
                    color: "darkgray"
                    height: (Qt.application.font.pixelSize * 2); width: listFilesRaw.width

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: (Qt.application.font.pixelSize * 1.75)
                        text: "Raw Files"
                    }
                }
                height: (parent.height - btnUploadRaw.height); width: (parent.width * 0.95)
                model: ListModel { }

                property int selectedIndex: -1
            }

            Button {
                id: btnUploadRaw
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Upload"

                onClicked: fileDialogRaw.open()
            }
        }

        Column {
            anchors.right: parent.right
            height: parent.height; width: (parent.width * 0.5)

            ListView {
                id: listFilesEdits
                delegate: Rectangle {
                    color: (listFilesEdits.selectedIndex == index) ? "lightblue" : ((index % 2) === 0) ? "transparent" : "lightgray"
                    height: (Qt.application.font.pixelSize * 2); width: listFilesEdits.width

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: filename
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            listFilesEdits.selectedIndex=index
                            listSites.filehash=filehash

                            previewFile(filepath)
                        }
                        onDoubleClicked: fileManager.openFileLocation(filepath)
                    }
                }
                header: Rectangle {
                    color: "darkgray"
                    height: (Qt.application.font.pixelSize * 2); width: listFilesEdits.width

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: (Qt.application.font.pixelSize * 1.75)
                        text: "Edit Files"
                    }
                }
                height: (parent.height * 0.85); width: (parent.width * 0.95)
                model: ListModel { }

                property int selectedIndex: -1
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Upload"

                onClicked: fileDialogEdit.open()
            }
        }
    }

    Rectangle {
        anchors.right: parent.right
        anchors.top: containerFiles.bottom
        height: (parent.height - containerFiles.height); width: (parent.width * 0.33)

        Column {
            anchors.fill: parent

            ListView {
                id: listSites
                delegate: Rectangle {
                    color: ((index % 2) === 0) ? "transparent" : "lightgray"
                    height: (Qt.application.font.pixelSize * 2.5); width: (listSites.width)

                    property bool uploaded: dbTableSiteUploadList.hasUpload(listSites.filehash, siteid)

                    Row {
                        anchors.fill: parent

                        Image {
                            id: imageUploadStatus
                            anchors.verticalCenter: parent.verticalCenter
                            height: (parent.height * 0.8); width: (parent.height * 0.8)
                            source:  uploaded ? "qrc:/ContentTracker/images/tick_green.svg" : "qrc:/ContentTracker/images/cross_red.svg"
                        }

                        Text {
                            font.pixelSize: appContentTracker.fontSizeDefault
                            height: parent.height; width: (parent.width - imageUploadStatus.width)
                            horizontalAlignment: Text.AlignHCenter
                            text: sitename
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            let currentHash = listSites.filehash

                            if (currentHash == undefined)
                                return

                            if (uploaded) {
                                dbTableSiteUploadList.deleteUpload(listSites.filehash, siteid)
                            } else {
                                dbTableSiteUploadList.addUpload(listSites.filehash, siteid)
                            }

                            listSites.filehash=""
                            listSites.filehash=currentHash
                        }
                    }
                }
                height: parent.height; width: parent.width
                model: ListModel { }

                property var filehash: undefined

                onFilehashChanged: buildSiteList()
            }
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        height: (parent.height - containerFiles.height); width: (parent.width * 0.5)

        Item {
            id: itemPreviewVideo
            anchors.fill: parent
            visible: false

            MediaPlayer {
                id: mediaPlayer
                videoOutput: videoOutput
            }

            VideoOutput {
                id: videoOutput
                height: (parent.height - playbackControls.height); width: parent.width
            }

            Rectangle {
                anchors.bottom: parent.bottom
                color: "lightgray"
                height: minHeight; width: parent.width

                property real minHeight: (playbackControls.height + playbackOption.height)

                Column {
                    id: playbackControls
                    anchors.fill: parent

                    Slider {
                        id: playbackPosition
                        from: 0; to: mediaPlayer.duration
                        value: mediaPlayer.position
                        width: parent.width

                        onValueChanged: mediaPlayer.position=value
                    }

                    Button {
                        id: playbackOption
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: appContentTracker.fontSizeBtnSml
                        text: (mediaPlayer.playbackState === MediaPlayer.PlayingState) ? "\u23F8" : "\u23F5"

                        onClicked: (mediaPlayer.playbackState === MediaPlayer.PlayingState) ? mediaPlayer.pause() : mediaPlayer.play()
                    }
                }
            }
        }

        Item {
            id: itemPreviewImage
            anchors.fill: parent
            visible: true

            Image {
                id: imageLoader
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }
        }
    }

    FileDialog {
        id: fileDialogEdit
        fileMode: FileDialog.OpenFiles

        onAccepted: {
            for (let i=0; i<files.length; i++) {
                let filepath = String(files[i]).replace("file:///", '')
                let uploadInfo = fileManager.uploadFileEdit(filepath,tableUid)

                dbTableProduction.addEditFile(uploadInfo)
            }
        }
    }

    FileDialog {
        id: fileDialogRaw
        fileMode: FileDialog.OpenFiles

        onAccepted: {
            for (let i=0; i<files.length; i++) {
                let filepath = String(files[i]).replace("file:///", '')
                let uploadInfo = fileManager.uploadFileRaw(filepath,tableUid)

                dbTableProduction.addRawFile(uploadInfo)
            }
        }
    }

    Production {
        id: dbTableProduction

        onFileEditAdded: buildFileListEdits()
        onFileRawAdded: buildFileListRaw()
    }

    SiteList {
        id: dbTableSiteList
    }

    SiteUploadList {
        id: dbTableSiteUploadList
    }
}
