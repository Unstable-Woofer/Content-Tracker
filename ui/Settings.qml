import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform

Page {
    function saveSettings() {
        appSettings.contentDirectory=inputContentDirectory.text
        appSettings.uploadMethod=selectUploadMethod.currentValue
    }

    Component.onCompleted: {
        let uploadMethod = appSettings.uploadMethod
        let index=0

        while (index < selectUploadMethod.count) {
            let method = selectUploadMethod.model.get(index)

            if (method.value == uploadMethod) {
                selectUploadMethod.currentIndex=index
                index=0;
                break;
            }

            index++
        }
    }

    Column {
        height: (parent.height - containerSettingControls.height); width: parent.width
        spacing: 5

        Row {
            width: parent.width

            Text {
                font.pixelSize: appContentTracker.fontSizeDefault
                text: "Content Directory"
                width: (parent.width * 0.20)
            }

            TextField {
                id: inputContentDirectory
                text: appSettings.contentDirectory
                width: (parent.width * 0.45)

                MouseArea {
                    anchors.fill: parent

                    onClicked: folderDialogContentDir.open()
                }
            }
        }

        Row {
            width: parent.width

            Text {
                font.pixelSize: appContentTracker.fontSizeDefault
                text: "Upload Method"
                width: (parent.width * 0.20)
            }

            ComboBox {
                id: selectUploadMethod
                model: ListModel {
                    ListElement {
                        name: "Copy"
                        value: "copy"
                    }
                    ListElement {
                        name: "Move"
                        value: "move"
                    }
                }
                textRole: "name"
                valueRole: "value"
            }
        }
    }

    Rectangle {
        id: containerSettingControls
        anchors.bottom: parent.bottom
        color: "gray"
        height: (appContentTracker.fontSizeBtnLrg + 15); width: parent.width

        Row {
            anchors.centerIn: parent

            Button {
                font.pixelSize: appContentTracker.fontSizeBtnSml
                text: "Save"
            }

            Button {
                font.pixelSize: appContentTracker.fontSizeBtnSml
                text: "Cancel"
            }
        }
    }

    /*ColumnLayout {
        anchors.fill: parent

        Row {
            Text {
                text: "Content Directory"
            }

            TextField {
                id: inputContentDirectory
                text: appSettings.contentDirectory

                MouseArea {
                    anchors.fill: parent

                    onClicked: folderDialogContentDir.open()
                }
            }
        }

        Row {
            Text {
                text: "Upload Method"
            }

            ComboBox {
                id: selectUploadMethod
                model: ListModel {
                    ListElement {
                        name: "Copy"
                        value: "copy"
                    }
                    ListElement {
                        name: "Move"
                        value: "move"
                    }
                }
                textRole: "name"
                valueRole: "value"
            }
        }

        Row {
            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter

            Button {
                text: "Save"

                onClicked: saveSettings()
            }

            Button {
                text: "Cancel"

                onClicked: stackMain.pop()
            }
        }
    }*/


    FolderDialog {
        id: folderDialogContentDir

        onAccepted: inputContentDirectory.text=String(folder).replace("file:///", '')
    }
}
