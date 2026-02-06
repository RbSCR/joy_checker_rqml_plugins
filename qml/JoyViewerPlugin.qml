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
import QtQuick.Controls
import QtQuick.Layouts
import Ros2

import "elements"

Rectangle {
    id: root
    // Set the minimum size for this plugin's dock widget
    property var kddockwidgets_min_size: Qt.size(400, 400)
    color: palette.base

    Component.onCompleted: {
        if (context.first_message_seen === undefined) {
            context.first_message_seen = false;
        }
    }

    Subscription {
        id: mySubscription
        messageType: "sensor_msgs/msg/Joy"
        topic: "/joy"
        enabled: true
        onNewMessage: msg => {
            d.handle_message(msg);
        }
    }

    ListModel {
        id: joybuttonModel
    }

    ListModel {
        id: joyaxesModel
    }

    GridView {
        id: joybuttonView

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 10
        cellWidth: 80
        cellHeight: 32
        implicitWidth: 250
        implicitHeight: 400
        Layout.alignment: Qt.AlignTop | Qt.AlignLeft
        flow: GridView.FlowLeftToRight
        header: Rectangle {
                    width: joybuttonView.width
                    height: joybuttonView.cellHeight
                    Text {
                        text: "Buttons"
                        anchors.centerIn: parent
                        font.bold: true
                    }

                }
        model: joybuttonModel
        delegate: JoyButton { }
    }

    GridView {
        id: joyaxesView

        anchors.top: parent.top
        anchors.left: joybuttonView.right
        cellWidth: 210
        cellHeight: 32
        implicitWidth: 230
        implicitHeight: 500
        Layout.alignment: Qt.AlignTop | Qt.AlignLeft
        flow: GridView.FlowLeftToRight
        header: Rectangle {
                    width: joybuttonView.width
                    height: joybuttonView.cellHeight
                    Text {
                        text: "Axes"
                        anchors.centerIn: parent
                        font.bold: true
                    }
                }
        model: joyaxesModel
        delegate: JoyAxis { }
    }

    Text {
        text: "Data will be displayed when the first message is received."
        visible: !context.first_message_seen
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    QtObject {
        id: d

        function handle_message(msg) {

            if (!context.first_message_seen) {
                handle_first_message(msg);
            }

            let bt_array = msg.buttons.toArray();
            let bt_length = bt_array.length;
            for (let i = 0; i < bt_length; i++) {
                joybuttonModel.set(i, { value: bt_array[i]});
            }

            let ax_array = msg.axes.toArray();
            let ax_length = ax_array.length;
            for (let i = 0; i < ax_length; i++) {
                joyaxesModel.set(i, { value: ax_array[i]});
            }
        }

        function handle_first_message(msg) {

            for (let i = 0; i < msg.buttons.toArray().length; i++) {
                const entry = {
                    index: i,
                    value: 0
                };
                joybuttonModel.append(entry);
            }
            for (let i = 0; i < msg.axes.toArray().length; i++) {
                const entry = {
                    index: i,
                    value: 0.0
                };
                joyaxesModel.append(entry);
            }
            context.first_message_seen = true;
        }
    } // end QtObject d
}
