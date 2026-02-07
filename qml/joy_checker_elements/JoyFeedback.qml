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
import Ros2

Rectangle {
    id: root

    required property string name
    required property double feedbackValue
    required property double updatetrigger

    property var _color_sequence: ["white", "green", "orange", "red", "blue", "yellow"]
    property int _color_index: 0

    onUpdatetriggerChanged: {
        _color_index = _color_index === (_color_sequence.length - 1) ? 1 : _color_index + 1;
    }

    width: 370
    height: 26
    radius: 8
    color: "#f2f2f2"
    border.color: "#b3b3b3"
    border.width: 1

    Text {
        id: name_label

        text: root.name
        color: "black"
        width: 50
        anchors.margins: 4
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
    }
    Rectangle {
        id: outer_bar

        width: 100
        height: 22
        radius: 4
        color: "white"
        border.color: "lightgray"
        border.width: 1
        anchors.margins: 4
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: name_label.right

        Rectangle {
            id: inner_bar

            width: root.feedbackValue * outer_bar.width
            height: outer_bar.height - 2
            color: root._color_sequence[_color_index]
            border.color: inner_bar.color
            border.width: 1
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Text {
        id: value_label

        text: root.updatetrigger === 0.0 ? "no message yet" : root.feedbackValue.toFixed(5) + "  at " + Ros2.now().seconds()
        color: "black"
        width: 50
        anchors.margins: 4
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: outer_bar.right
    }
}
