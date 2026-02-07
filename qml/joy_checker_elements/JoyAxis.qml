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
    required property double value

    width: 290
    height: 26
    radius: 8
    color: "#f2f2f2"
    border.color: "#b3b3b3"
    border.width: 1

    Text {
        id: index_label

        text: root.index
        color: "black"
        width: 16
        anchors.margins: 4
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
    }
    Rectangle {
        id: outer_bar

        width: 200
        height: 22
        radius: 4
        color: "white"
        border.color: "black"
        border.width: 1
        anchors.margins: 4
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: index_label.right

        Rectangle {
            id: inner_bar

            x: root.value === 0.00000 ? 100 : root.value > 0.0 ? 100 : 100 + (root.value * 100)
            width: root.value === 0.00000 ? 1 : root.value > 0.0 ? (root.value * 100) : (root.value * - 100)
            height: outer_bar.height - 2
            color: root.value === 0.00000 ? "red" : "green"
            border.color: "black"
            border.width: 1
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Text {
        id: value_label

        text: root.value.toFixed(5)
        color: "black"
        width: 20
        anchors.margins: 4
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: outer_bar.right
    }
}
