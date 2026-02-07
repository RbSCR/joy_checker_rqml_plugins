/*
 * Copyright (C) 2026  RbSCR
 *
 * This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick

Rectangle {
    id: root

    required property int index
    required property int value

    width: 70
    height: 26
    radius: 8
    color: "#f2f2f2"
    border.color: "#b3b3b3"
    border.width: 1

    Text {
        id: label

        text: index
        color: "black"
        width: 16
        anchors.margins: 6
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
    }
    Rectangle {
        id: joy_circle

        width: 22
        height: width
        radius: width / 2
        color: root.value > 0 ? "green" : "white"
        border.color: "black"
        border.width: 1
        anchors.margins: 4
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
    }
}
