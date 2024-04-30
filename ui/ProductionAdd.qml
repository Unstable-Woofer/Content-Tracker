import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    function modelYears() {
        for (var i=2000; i<= new Date().getFullYear(); i++) {
            selectYear.model.append({value: i})
        }

        selectYear.currentIndex=selectYear.model.count-1
    }

    function saveProduction() {
        let prodDate = inputDate.selectedDate
        let prodName = inputName.text

        if (prodDate === undefined)
            prodDate = new Date()

        let day = new Date(prodDate).getDate()
        let month = Number(new Date(prodDate).getMonth()) + 1
        let year =  new Date(prodDate).getFullYear()

        day = (day < 10) ? ('0' + day) : day
        month = (month < 10) ? ('0' + month) : month

        prodDate = `${year}-${month}-${day}`

        dbProductionList.add(prodName, prodDate)
    }

    function setMonth(month) { }

    Component.onCompleted: modelYears()

    ListModel {
        id: modelMonths

        ListElement {
            monthName: "January"
            monthNo: 1
            calendar: Calendar.January
        }
        ListElement {
            monthName: "February"
            monthNo: 2
            calendar: Calendar.February
        }
        ListElement {
            monthName: "March"
            monthNo: 3
            calendar: Calendar.March
        }
        ListElement {
            monthName: "April"
            monthNo: 4
            calendar: Calendar.April
        }
        ListElement {
            monthName: "May"
            monthNo: 5
            calendar: Calendar.May
        }
        ListElement {
            monthName: "June"
            monthNo: 6
            calendar: Calendar.June
        }
        ListElement {
            monthName: "July"
            monthNo: 7
            calendar: Calendar.July
        }
        ListElement {
            monthName: "August"
            monthNo: 8
            calendar: Calendar.August
        }
        ListElement {
            monthName: "September"
            monthNo: 9
            calendar: Calendar.September
        }
        ListElement {
            monthName: "October"
            monthNo: 10
            calendar: Calendar.October
        }
        ListElement {
            monthName: "November"
            monthNo: 11
            calendar: Calendar.November
        }
        ListElement {
            monthName: "December"
            monthNo: 12
            calendar: Calendar.December
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: (parent.width * 0.8)

        Row {
            Layout.fillWidth: true

            Text {
                text: "Production Name"
                width: (parent.width * 0.2)
            }

            TextField {
                id: inputName
                width: (parent.width * 0.4)
            }
        }

        Row {
            Layout.fillWidth: true

            Text {
                text: "Production Date"
                width: (parent.width * 0.2)
            }

            Column {
                width: (parent.width * 0.4)

                Row {
                    width: parent.width

                    ComboBox {
                        model: modelMonths
                        textRole: "monthName"
                        valueRole: "calendar"

                        onCurrentValueChanged: inputDate.month=modelMonths.get(currentValue).calendar
                    }

                    ComboBox {
                        id: selectYear
                        model: ListModel { }

                        onCurrentValueChanged: inputDate.year=currentValue
                    }
                }

                DayOfWeekRow {
                    width: parent.width
                }

                MonthGrid {
                    id: inputDate
                    delegate: Rectangle {
                        color: (inputDate.selectedDay === model.day && displayed) ? "lightblue" : "transparent"
                        height: Qt.application.font.pixelSize; width: Qt.application.font.pixelSize

                        Text {
                            anchors.centerIn: parent
                            opacity: (model.month === inputDate.month)
                            text: model.day
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: inputDate.selectedDay=model.day
                        }

                        property bool displayed: (model.month === inputDate.month)
                    }
                    width: parent.width
                    year: new Date().getFullYear()

                    property int selectedDay
                    property var selectedDate

                    onSelectedDayChanged: selectedDate=new Date(inputDate.year, inputDate.month, selectedDay)
                }
            }
        }

        Row {
            Layout.alignment: Qt.AlignHCenter

            Button {
                font.pixelSize: (Qt.application.font.pixelSize * 1.5)
                text: "Add"

                onClicked: saveProduction()
            }

            Button {
                font.pixelSize: (Qt.application.font.pixelSize * 1.5)
                text: "Cancel"
            }
        }
    }
}
