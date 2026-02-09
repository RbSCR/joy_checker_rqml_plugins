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
import RQml.Fonts

import "joy_checker_elements"

Rectangle {
    id: root
    // Set the minimum size for this plugin's dock widget
    property var kddockwidgets_min_size: Qt.size(300, 300)
    color: palette.base


    ColumnLayout {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 8

        GridLayout {
            Layout.fillWidth: true
            columns: 2

            Label {
                text: "Type:"
                font.bold: true
            }
            ComboBox {
                id: selectedType
                model: ["Led", "Rumble", "Buzzer"]
                currentIndex: 1
                ToolTip.delay:   1000
                ToolTip.timeout: 5000
                ToolTip.visible: hovered
                ToolTip.text: "Select a type."
            }

            Label {
                text: "Id:"
                font.bold: true
            }
            SpinBox {
                id: selectedId
                from: 0
                to: 99
                stepSize: 1
                editable: true

                ToolTip.delay:   1000
                ToolTip.timeout: 5000
                ToolTip.visible: hovered
                ToolTip.text: "Enter an id."
            }

            Label {
                text: "Intensity:"
                font.bold: true
            }
            FeedbackSlider {
                id: selectedIntensity
                Layout.fillWidth: true
                direction: Qt.Horizontal
            }

            Button {
                text: "Send message"
                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    let msg = Ros2.createEmptyMessage("sensor_msgs/msg/JoyFeedback");
                    msg.type = selectedType.currentIndex;
                    msg.id = selectedId.value;
                    msg.intensity = selectedIntensity.value.toFixed(5);

                    d.publisher.publish(msg);
                }
            }
        }
    }

    // Use a private object for internal logic and properties
    QtObject {
        id: d
        property var publisher: Ros2.createPublisher("/joy/set_feedback", "sensor_msgs/msg/JoyFeedback")
    }
}
