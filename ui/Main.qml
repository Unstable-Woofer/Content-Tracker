import QtQuick
import QtQuick.Controls

import ContentTracker.Database
import ContentTracker.Utils

ApplicationWindow {
    id: appContentTracker
    header: ToolBar {
        height: (fontSizeToolbar * 1.4)
        visible: !(stackMain.depth === 1)

        ToolButton {
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: fontSizeToolbar
            text: "<< Return"
            onClicked: stackMain.pop()
        }

        Text {
            id: toolbarTitle
            anchors.centerIn: parent
            font.bold: true
            font.pixelSize: fontSizeToolbar
        }
    }
    height: 512; width: 1024
    menuBar: MenuBar {
        Menu {
            title: "App"

            Action {
                text: "Settings"
                onTriggered: stackMain.push("qrc:/ContentTracker/ui/Settings.qml")
            }

            MenuSeparator { }

            Action {
                text: "Quit"
                onTriggered: Qt.quit()
            }
        }

        MenuBarItem {
            text: "Sites"

            onTriggered: stackMain.push("qrc:/ContentTracker/ui/SiteManager.qml")
        }
    }
    title: Qt.application.name
    visible: true

    property int fontSizeDefault: 15
    property int fontSizeBtnSml: (fontSizeDefault * 1.5)
    property int fontSizeBtnLrg: (fontSizeDefault * 1.75)
    property int fontSizeHeader: (fontSizeDefault * 2)
    property int fontSizeToolbar: (fontSizeDefault * 1.4)


    StackView {
        id: stackMain
        anchors.fill: parent
        initialItem: "qrc:/ContentTracker/ui/Home.qml"
    }

    AppSettings {
        id: appSettings
    }

    FileManager {
        id: fileManager
    }

    ProductionList {
        id: dbProductionList

        onProductionAdded: function(uid) {
            fileManager.createFolderProduction(uid)
            stackMain.pop()
        }

        onProductionAddError: function(error) {
            console.log(error)
        }
    }
}
