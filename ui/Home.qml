import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    function buildProdList() {
        listProductions.model.clear()

        let productions = dbProductionList.list

        if (selectSortMethod.currentValue == 0)
            productions = sortDate(productions)
        else
            productions = sortName(productions)

        //productions.sort((a, b) => a.date - b.date)
        for (var key in productions) {
            listProductions.model.append(productions[key])
        }
    }

    function sortDate(productions) {
        for (var key in productions) {
            let currentObject = productions[key]
            currentObject.jsDate = new Date(currentObject.date)
            productions[key]=currentObject
        }

        if (selectSortOrder.currentValue == 1)
            productions.sort((a,b) => b.jsDate - a.jsDate)
        else
            productions.sort((a,b) => a.jsDate - b.jsDate)

        return productions
    }

    function sortName(productions) {
        for (var key in productions) {
            let currentObject = productions[key]
            currentObject.jsName = String(currentObject.name).toLowerCase()
            productions[key]=currentObject
        }

        if (selectSortOrder.currentValue == 1)
            productions.sort((a,b) => {
                                 if (a.jsName < b.name)
                                    return -1
                                 if (a.jsName > b.jsName)
                                    return 1
                                 return 0
                             })
        else
            productions.sort((a,b) => {
                                 if (a.jsName > b.name)
                                    return -1
                                 if (a.jsName < b.jsName)
                                    return 1
                                 return 0
                             })

        return productions
    }

    Component.onCompleted: buildProdList()
    StackView.onActivating: buildProdList()

    Rectangle {
        id: containerOptions
        anchors.verticalCenter: parent.verticalCenter
        color: "transparent"
        height: (parent.height * 0.33); width: (parent.width * 0.33)

        Row {
            anchors.top: parent.top
            width: parent.width

            Text {
                id: labelSort
                font.pixelSize: appContentTracker.fontSizeDefault
                text: "Sort"
                width: (parent.width * 0.2)
            }

            ComboBox {
                id: selectSortMethod
                currentIndex: 0
                font.pixelSize: appContentTracker.fontSizeDefault
                model: ListModel {
                    ListElement {
                        name: "Date"
                        value: 0
                    }
                    ListElement {
                        name: "Name"
                        value: 1
                    }
                }
                textRole: "name"
                valueRole: "value"
                width: ((parent.width - labelSort.width) * 0.5)

                onCurrentValueChanged: buildProdList()
            }

            ComboBox {
                id: selectSortOrder
                currentIndex: 1
                font.pixelSize: appContentTracker.fontSizeDefault
                model: ListModel {
                    ListElement {
                        name: "Asc"
                        value: 0
                    }
                    ListElement {
                        name: "Desc"
                        value: 1
                    }
                }
                textRole: "name"
                valueRole: "value"
                width: ((parent.width - labelSort.width) * 0.5)

                onCurrentValueChanged: buildProdList()
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: (parent.height * 0.05)
            width: parent.width

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                font.pixelSize: appContentTracker.fontSizeBtnLrg
                text: "Add"
                width: (parent.width * 0.8)

                onClicked: stackMain.push("qrc:/ContentTracker/ui/ProductionAdd.qml")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                enabled: !(listProductions.selectedIndex === -1)
                font.bold: true
                font.pixelSize: appContentTracker.fontSizeBtnLrg
                text: "Manage"
                width: (parent.width * 0.8)

                onClicked: stackMain.push("qrc:/ContentTracker/ui/ProductionManage.qml", {tableUid: listProductions.model.get(listProductions.selectedIndex).uid})
            }
        }
    }

    Rectangle {
        anchors.left: containerOptions.right
        color: "transparent"
        height: parent.height; width: (parent.width - containerOptions.width)

        ListView {
            id: listProductions
            anchors.horizontalCenter: parent.horizontalCenter
            delegate: Rectangle {
                color: (index === listProductions.selectedIndex) ? "lightblue" : ((index % 2) === 0) ? "transparent" : "lightgray"
                height: (appContentTracker.fontSizeDefault * 1.5); width: listProductions.width

                MouseArea {
                    anchors.fill: parent

                    onClicked: listProductions.selectedIndex=index
                    onDoubleClicked: stackMain.push("qrc:/ContentTracker/ui/ProductionManage.qml", {tableUid: uid})
                }

                Row {
                    anchors.fill: parent

                    Text {
                        font.pixelSize: appContentTracker.fontSizeDefault
                        horizontalAlignment: Text.AlignHCenter
                        text: name
                        width: (parent.width * 0.5)
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        font.pixelSize: appContentTracker.fontSizeDefault
                        horizontalAlignment: Text.AlignHCenter
                        text: date
                        width: (parent.width * 0.5)
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
            header: Rectangle {
                color: "transparent"
                height: (Qt.application.font.pixelSize * 2.5); width: listProductions.width

                Row {
                    height: (parent.height-3); width: parent.width

                    Text {
                        font.bold: true
                        font.pixelSize: (Qt.application.font.pixelSize * 1.8)
                        horizontalAlignment: Text.AlignHCenter;
                        text: "Name"
                        height: parent.height; width: (parent.width * 0.5)
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        font.bold: true
                        font.pixelSize: (Qt.application.font.pixelSize * 1.8)
                        horizontalAlignment: Text.AlignHCenter
                        text: "Date"
                        height: parent.height; width: (parent.width * 0.5)
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    color: "black"
                    height: 2; width: parent.width
                }
            }
            height: parent.height; width: (parent.width * 0.95)
            model: ListModel { }

            property int selectedIndex: -1
        }
    }
}
