import QtQuick
import QtQuick.Controls

import ContentTracker.Database

Page {
    function buildSiteList() {
        let sites = tableSiteList.sites
        let model = listSites.model

        model.clear();

        for (var key in sites) {
            model.append(sites[key])
        }
    }

    Component.onCompleted: buildSiteList()

    Rectangle {
        id: containerSiteControls
        height: parent.height; width: (parent.width * 0.33)

        Column {
            anchors.centerIn: parent
            width: parent.width

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                font.pixelSize: appContentTracker.fontSizeBtnLrg
                text: "New Site"
                width: (parent.width * 0.75)
                onClicked: containerSiteAdd.visible=true
            }
        }
    }

    Rectangle {
        id: containerSiteAdd
        anchors.right: parent.right
        color: "transparent"
        height: (parent.height * 0.25); width: (parent.width - containerSiteControls.width)
        visible: false

        Column {
            spacing: 10
            width: parent.width

            Row {
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    font.pixelSize: appContentTracker.fontSizeDefault
                    text: "Site Name"
                }

                TextField {
                    id: inputSiteName
                }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    font.bold: true
                    font.pixelSize: appContentTracker.fontSizeBtnSml
                    text: "Add"

                    onClicked: {
                        tableSiteList.addSite(inputSiteName.text)
                        buildSiteList()
                        containerSiteAdd.visible=false
                        inputSiteName.text=""
                    }
                }

                Button {
                    font.bold: true
                    font.pixelSize: appContentTracker.fontSizeBtnSml
                    text: "Cancel"

                    onClicked: {
                        containerSiteAdd.visible=false
                    }
                }
            }
        }
    }

    Rectangle {
        id: containerSiteList
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        height: (parent.height - (containerSiteAdd.visible ? containerSiteAdd.height : 0))
        width: (parent.width - containerSiteControls.width)

        ListView {
            id: listSites
            delegate: Rectangle {
                color: ((index % 2) === 0) ? "transparent" : "lightgray"
                height: (Qt.application.font.pixelSize * 2); width: listSites.width

                Row {
                    anchors.fill: parent

                    Item {
                        height: parent.height
                        width: listSites.sizeColDrag
                        Drag.active: dragArea.held

                        Text {
                            font.pixelSize: appContentTracker.fontSizeDefault
                            horizontalAlignment: Text.AlignHCenter
                            text: "\u2630"
                            verticalAlignment: Text.AlignVCenter
                            width: parent.width
                        }

                        MouseArea {
                            id: dragArea
                            anchors.fill: parent
                            drag.target: parent
                            drag.axis: Drag.YAxis

                            property bool held: false
                            property int defaultY

                            onPressed: {
                                held=true
                                listSites.activeItem=index

                                defaultY=parent.y
                            }

                            onReleased: {
                                parent.Drag.drop()
                                held=false

                                if (!listSites.hasDrop) {
                                    parent.y=defaultY
                                }
                            }
                        }
                    }

                    Text {
                        font.pixelSize: appContentTracker.fontSizeDefault
                        horizontalAlignment: Text.AlignHCenter
                        text: sitename
                        width: listSites.sizeColName
                    }

                    Text {
                        font.pixelSize: appContentTracker.fontSizeDefault
                        horizontalAlignment: Text.AlignHCenter
                        text: position
                        width: listSites.sizeColPos
                    }
                }

                DropArea {
                    id: dropArea
                    anchors.fill: parent
                    visible: true

                    onEntered: {
                        parent.color="lightgreen"
                        listSites.hasDrop=true
                    }
                    onExited: {
                        parent.color=((index % 2) === 0) ? "transparent" : "lightgray"
                        listSites.hasDrop=false
                    }

                    onDropped: {
                        let currentOrder = [];

                        for (var i=0; i< listSites.model.count; i++) {
                            let site = listSites.model.get(i)
                            currentOrder.push({siteid: site.siteid, sitename: site.sitename, position: site.position})
                        }

                        let movedItem = currentOrder.splice(listSites.activeItem, 1)[0];
                        currentOrder.splice(index, 0, movedItem)

                        for (var b=0; b<currentOrder.length; b++) {
                            let newPosition = b + 1
                            currentOrder[b]["position"] = String(newPosition);
                        }


                        for (var c=0; c<currentOrder.length; c++) {
                            let site=currentOrder[c]
                            tableSiteList.updateSite(site.sitename, site.siteid, site.position)
                        }

                        buildSiteList()
                    }
                }
            }
            header: Rectangle {
                color: "gray"
                height: (appContentTracker.fontSizeHeader * 1.40); width: containerSiteList.width

                Row {
                    anchors.fill: parent

                    Text {
                        text: ""
                        width: listSites.sizeColDrag
                    }

                    Text {
                        font.bold: true
                        font.pixelSize: appContentTracker.fontSizeHeader
                        horizontalAlignment: Text.AlignHCenter
                        text: "Site Name"
                        verticalAlignment: Text.AlignVCenter
                        width: listSites.sizeColName
                    }

                    Text {
                        font.bold: true
                        font.pixelSize: appContentTracker.fontSizeHeader
                        horizontalAlignment: Text.AlignHCenter
                        text: "Display Order"
                        verticalAlignment: Text.AlignVCenter
                        width: listSites.sizeColPos
                    }
                }
            }
            height: parent.height; width: parent.width
            model: ListModel { }

            property bool hasDrop: false
            property var activeItem: null
            property real sizeColDrag: (parent,width * 0.1)
            property real sizeColName: ((parent.width - sizeColDrag) * 0.5)
            property real sizeColPos: ((parent.width - sizeColDrag) * 0.5)
        }
    }

    SiteList {
        id: tableSiteList
    }
}
