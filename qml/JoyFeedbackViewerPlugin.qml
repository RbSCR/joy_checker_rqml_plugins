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

import "joy_checker_elements"

Rectangle {
    id: root
    // Set the minimum size for this plugin's dock widget
    property var kddockwidgets_min_size: Qt.size(400, 400)
    color: palette.base

    Component.onCompleted: {

        d.create_feedback_list_elements();
    }

    Subscription {
        id: mySubscription
        messageType: "sensor_msgs/JoyFeedback"
        topic: "/joy/set_feedback"
        enabled: true
        onNewMessage: msg => {
            d.handle_message(msg);
        }
    }

    ListModel {
        id: joyfeedbackModel
    }

    ColumnLayout {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 8

        GridView {
            id: joyfeedbackView

            cellWidth: 380
            cellHeight: 32
            implicitWidth: 400
            implicitHeight: 400
            Layout.alignment: Qt.AlignTop

            header: Rectangle {
                width: joyfeedbackView.cellWidth
                height: joyfeedbackView.cellHeight
                Text {
                    text: "Types"
                    anchors.centerIn: parent
                    font.bold: true
                }
            }
            model: joyfeedbackModel
            delegate: JoyFeedback { }
        }
    }

    QtObject {
        id: d

        function handle_message(msg) {

            let trigger = Math.random() + 0.0000000001
            joyfeedbackModel.set(msg.type, {feedbackValue: msg.intensity, updatetrigger: trigger });
        }

        function create_feedback_list_elements() {

            const entry0 = {name: "Led", feedbackValue: 0.0, updatetrigger: 0.0 };
            joyfeedbackModel.append(entry0);

            const entry1 = {name: "Rumble", feedbackValue: 0.0, updatetrigger: 0.0 };
            joyfeedbackModel.append(entry1);

            const entry2 = {name: "Buzzer", feedbackValue: 0.0, updatetrigger: 0.0 };
            joyfeedbackModel.append(entry2);
        }
    }
}
