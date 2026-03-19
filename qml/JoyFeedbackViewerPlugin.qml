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
    property var kddockwidgets_min_size: Qt.size(280, 450)
    color: palette.base

    Component.onCompleted: {

        d.create_feedback_list_elements();
    }

    Subscription {
        id: mySubscription
        messageType: "sensor_msgs/JoyFeedback"
        topic: context.topic ?? ""
        enabled: Ros2.isValidTopic(topic)
        onNewMessage: msg => {
            d.handle_message(msg);
        }
    }

    ListModel {
        id: joyfeedbackModel
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
                    let result = Ros2.queryTopics("sensor_msgs/JoyFeedback");
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

    ColumnLayout {
        anchors.top: selectionColumn.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10

        GridView {
            id: joyfeedbackView

            cellWidth: 220
            cellHeight: 90
            implicitWidth: 250
            implicitHeight: 400
            Layout.alignment: Qt.AlignTop
            model: joyfeedbackModel
            delegate: JoyFeedback { }
        }
    }

    QtObject {
        id: d

        function handle_message(msg) {

            let trigger = Math.random() + 0.0000000001
            joyfeedbackModel.set(msg.type, {
                idValue: msg.id,
                feedbackValue: msg.intensity,
                updatetrigger: trigger
                });
        }

        function create_feedback_list_elements() {

            const entry0 = {
                nameValue: "Led",
                idValue: 0,
                feedbackValue: 0.0,
                updatetrigger: 0.0
            };
            joyfeedbackModel.append(entry0);

            const entry1 = {
                nameValue: "Rumble",
                idValue: 0,
                feedbackValue: 0.0,
                updatetrigger: 0.0
            };
            joyfeedbackModel.append(entry1);

            const entry2 = {
                nameValue: "Buzzer",
                idValue: 0,
                feedbackValue: 0.0,
                updatetrigger: 0.0
            };
            joyfeedbackModel.append(entry2);
        }
    }
}
