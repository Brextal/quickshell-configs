import QtQuick
import "./shared" as Pywal

Item {
    id: root
    property var pywal: Pywal.Pywal { id: pywalColors }

    property string dayName
    property int dayNumber
    property bool isToday: false
    property bool isSelected: false
    property bool isMarked: false
    property int weatherCode: -1
    property string tempMax: ""
    property int eventCount: 0

    width: 90
    height: 150

    Rectangle {
        anchors.centerIn: parent
        width: parent.width - 6
        height: parent.height - 6
        radius: 12
        color: isToday ? pywalColors.color4 + "33" : (isSelected && !isToday ? "#22ffffff" : "transparent")
        border {
            color: isToday ? pywalColors.color4 + "66" : (isSelected && !isToday ? "#30ffffff" : "transparent")
            width: 1
        }

        Behavior on color {
            ColorAnimation { duration: 150; easing.type: Easing.OutQuad }
        }
    }

    Rectangle {
        anchors {
            top: parent.top
            topMargin: 6
            horizontalCenter: parent.horizontalCenter
        }
        width: 5
        height: 5
        radius: 2.5
        color: pywalColors.color4
        visible: isMarked

        Behavior on visible {
            NumberAnimation { duration: 150 }
        }
    }

    Rectangle {
        anchors {
            top: parent.top
            topMargin: 6
            left: parent.left
            leftMargin: 8
        }
        width: 6
        height: 6
        radius: 3
        color: pywalColors.color5
        visible: eventCount > 0

        Text {
            anchors.centerIn: parent
            text: eventCount > 9 ? "9+" : eventCount
            color: "#000000"
            font.pixelSize: 7
            font.bold: true
            visible: eventCount > 0
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 3

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.dayName.substring(0, 3)
            color: isToday ? pywalColors.color4 : (isSelected ? "#ffffff" : "#aaaaaa")
            font.pixelSize: 11
            font.bold: isToday
            font.capitalization: Font.Capitalize
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.dayNumber
            color: isToday ? "#000000" : (isSelected ? "#ffffff" : "#cccccc")
            font.pixelSize: 18
            font.bold: isToday || isSelected
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: {
                if (root.weatherCode >= 0) return weatherEmoji(root.weatherCode)
                return "?"
            }
            color: isToday ? "#000000" : "#ffffff"
            font.pixelSize: 26
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.tempMax !== "" ? root.tempMax : "?"
            color: isToday ? "#000000" : (isSelected ? "#ffffff" : "#bbbbbb")
            font.pixelSize: 14
            font.bold: true
        }
    }

    function weatherEmoji(code) {
        if (code <= 0) return "\u2600\uFE0F"          // despejado
        if (code === 1) return "\uD83C\uDF24\uFE0F"  // mayormente despejado
        if (code === 2) return "\u26C5"               // parcialmente nublado
        if (code <= 3) return "\u2601\uFE0F"          // nublado
        if (code <= 48) return "\uD83C\uDF2B\uFE0F"  // niebla
        if (code <= 55) return "\uD83C\uDF26\uFE0F"  // llovizna
        if (code <= 57) return "\uD83C\uDF27\uFE0F"  // llovizna helada
        if (code <= 65) return "\uD83C\uDF27\uFE0F"  // lluvia
        if (code <= 67) return "\uD83C\uDF27\uFE0F"  // lluvia helada
        if (code <= 77) return "\uD83C\uDF28\uFE0F"  // nieve
        if (code <= 82) return "\uD83C\uDF26\uFE0F"  // chubascos
        if (code <= 86) return "\uD83C\uDF28\uFE0F"  // chubascos de nieve
        return "\u26C8\uFE0F"                         // tormenta
    }
}
