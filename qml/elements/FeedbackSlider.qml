/*
 * Copyright  (C)  2026  Rbscr
 *
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

/*
 *   Based upon the SpeedSlider from RQml by Stefan Fabian
 *
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import RQml.Elements

Item {
    id: root
    property var direction: Qt.Vertical
    property alias value: slider.value
    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    GridLayout {
        id: layout
        anchors.fill: parent
        flow: direction == Qt.Vertical ? GridLayout.LeftToRight : GridLayout.TopToBottom
        columns: 2
        rows: 2

        Slider {
            id: slider
            Layout.column: 0
            Layout.row: 0
            Layout.fillHeight: direction == Qt.Vertical
            Layout.fillWidth: direction == Qt.Horizontal
            from: 0.0
            to: 1.0
            stepSize: (to - from) / 100000
            value: 0
            orientation: direction
            snapMode: Slider.SnapOnRelease

            ToolTip.delay:   1000
            ToolTip.timeout: 5000
            ToolTip.visible: hovered
            ToolTip.text: "Set the intensity with the slider or enter an intensity value in the box."
        }
        DecimalInputField {
            id: valueField
            Layout.alignment: direction == Qt.Vertical ? Qt.AlignLeft | Qt.AlignVCenter : Qt.AlignTop | Qt.AlignHCenter
            Layout.column: direction == Qt.Vertical ? 0 : 1
            Layout.row: direction == Qt.Horizontal ? 0 : 1
            implicitWidth: 60
            from: slider.from
            to: slider.to
            decimals: 5
            value: slider.value
            onValueChanged: slider.value = value

            ToolTip.delay:   1000
            ToolTip.timeout: 8000
            ToolTip.visible: hovered
            ToolTip.text: "Enter an intensity value in this box or select the intensity with the slider." +
                    "\nNote: once a value has been entered in this box, any change to the slider doesn't" +
                    "\n         change the value displayed in this box anymore."
        }
    } // GridLayout
}
