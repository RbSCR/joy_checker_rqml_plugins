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
import RQml.Elements

import "joy_checker_elements"

Rectangle {
    id: root
    // Set the minimum size for this plugin's dock widget
    property var kddockwidgets_min_size: Qt.size(400, 400)
    color: palette.base

    Component.onCompleted: {
        if (context.first_message_seen === undefined) {
            context.first_message_seen = false;
        }
        if (context.max_axes_length === undefined) {
            context.max_axes_length = 0;
        }
        if (context.max_buttons_length === undefined) {
            context.max_buttons_length = 0;
        }
    }

    Subscription {
        id: mySubscription
        messageType: "sensor_msgs/msg/Joy"
        topic: context.topic ?? ""
        enabled: Ros2.isValidTopic(topic)
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

    ColumnLayout {
        id: selectionColumn

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 10
        spacing: 8

        RowLayout {
            id: selectionBar

            Layout.fillWidth: true
            layoutDirection: Qt.LeftToRight
            spacing: 8

            FuzzySelector {
                id: topicSelect
                Layout.fillWidth: true
                Layout.preferredWidth: 400
                placeholderText: qsTr("Select or enter a topic")
                text: context.topic ?? ""
                onTextChanged: {
                    if (text === context.topic) {
                        return;
                    }
                    if (!Ros2.isValidTopic(text)) {
                        return;
                    }
                    context.topic = text;
                }

                function refresh() {
                    let result = Ros2.queryTopics("sensor_msgs/msg/Joy");
                    if (!!context.topic) {
                        const index = result.indexOf(context.topic);
                        if (index != -1) {
                            result.splice(index, 1);
                        }
                        result.unshift(context.topic);
                    }
                    model = result;
                }
                Component.onCompleted: refresh()
            }

            Label {
                text: topicSelect.model.length > 0 ? qsTr("%1 topic(s) found").arg(topicSelect.model.length) : qsTr("No topics found")
                font.italic: true
                opacity: 0.7
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
            }

            RefreshButton {
                onClicked: {
                    animate = true;
                    topicSelect.refresh();
                    animate = false;
                }
                ToolTip.delay: 1000
                ToolTip.timeout: 5000
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Refresh the topic list")
            }
        }
    }

    GridView {
        id: joybuttonView

        anchors.top: selectionColumn.bottom
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

        anchors.top: selectionColumn.bottom
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
        text: qsTr("Data will be displayed when the first message is received.")
        visible: !context.first_message_seen
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    QtObject {
        id: d

        function handle_message(msg) {

            if (!context.first_message_seen) {
                context.first_message_seen = true;
            }

            if (context.max_buttons_length < msg.buttons.toArray().length) {
                increase_joybuttonModel(msg);
            } else if (context.max_buttons_length > msg.buttons.toArray().length) {
                joybuttonModel.clear();
                context.max_buttons_length = 0;
                increase_joybuttonModel(msg);
            }

            if (context.max_axes_length < msg.axes.toArray().length) {
                increase_joyaxesModel(msg);
            } else if (context.max_axes_length > msg.axes.toArray().length) {
                joyaxesModel.clear();
                context.max_axes_length = 0;
                increase_joyaxesModel(msg);
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

        function increase_joybuttonModel(msg) {

            for (let i = context.max_buttons_length; i < msg.buttons.toArray().length; i++) {
                const entry = {
                    index: i,
                    value: 0
                };
                joybuttonModel.append(entry);
            }
            context.max_buttons_length =  msg.buttons.toArray().length;
        }

       function increase_joyaxesModel(msg) {

            for (let i = context.max_axes_length; i < msg.axes.toArray().length; i++) {
                const entry = {
                    index: i,
                    value: 0
                };
                joyaxesModel.append(entry);
            }
            context.max_axes_length =  msg.axes.toArray().length;
       }

    } // end QtObject d
}
