# joy_checker_rqml_plugins

This package contains some RQml plugins for visually checking/testing joysticks in ROS2.

The messages of the message types [`sensor_msgs/Joy`](https://docs.ros.org/en/ros2_packages/rolling/api/sensor_msgs/msg/Joy.html) and [`sensor_msgs/JoyFeedback`](https://docs.ros.org/en/ros2_packages/rolling/api/sensor_msgs/msg/JoyFeedback.html) are displayed in a user-friendly format.
Additionally there is a plugin to publish messages of the `sensor_msgs/JoyFeedback` type.

See [RQml](https://github.com/StefanFabian/rqml) for a description of the (required) awesome RQml package by Stefan Fabian.

The 'Joy Viewer' plugin was inspired by Josh Newans [`joy_tester`](https://github.com/joshnewans/joy_tester) package.

## 🔌 Plugins

This package provides the following RQml-plugins:

* **Joy Viewer**: A viewer for `Joy` message type messages.
* **JoyFeedback Viewer**: A viewer for `JoyFeedback` message type messages.
* **JoyFeedback Publisher**: A publisher for `JoyFeedback` message type messages.

## 🚀 Usage

Launch the RQml application with a single command:

```bash
rqml
```

Within the application select the required plugin(s) from the `Plugins` menu.

### 🔎 Joy Viewer

Displays the data (buttons and axes) from a `Joy` message type.

Upon activating the plugin, no data will initially be displayed.
The data will be displayed when the first message is received.

Plugin is in the 'Topic monitor' group.

The relevant topic can either can be entered or can be selected in a dropdown from the (already)
available topics of message type `Joy`. If there is only 1 availabe topic when the plugin
is activated, that topic will be selected by default and the data will be displayed.

### 🔎 JoyFeedback Viewer

Displays the data (id and intensity, for each of the three types) from a `JoyFeedback` message type.
Also the ROStime the message was received is displayed.

Plugin is in the 'Topic monitor' group.

The relevant topic can either can be entered or can be selected in a dropdown from the (already)
available topics of message type `JoyFeedback`. If there is only 1 available topic when the plugin
is activated, that topic will be selected by default and the data will be displayed.

### ✉️ JoyFeedback Publisher

Publishes a `JoyFeedback` message type.
The type, id and intensity can be selected/entered.

Plugin is in the 'Communication' group.

The relevant topic can either can be entered or can be selected in a dropdown from the (already)
available topics of message type `JoyFeedback`. If there is only 1 availabe topic when the plugin
is activated, that topic will be selected by default.


>[!NOTE]
> A 'JoyFeedback' message type could also be published using the `MessagePublisher` (default plugin from RQml).

### 📐 Managing Layouts

RQml allows you to save and load your workspace configurations. Arrange your plugins to your heart's content and save the layout to restore it later! 💾

>[!NOTE]
> Use `Ctrl+Shift+S` to save your current config to one of the directories configured in the settings.
> Use `Ctrl+R` to quickly load one of your recently opened configurations or `Ctrl+O` to open
> a configuration from your config directories.

## 🛠️ Building from Source

1. **Create a ROS 2 workspace** (if you haven't already):

    ```bash
    mkdir -p ~/ros2_ws/src
    cd ~/ros2_ws/src
    ```

2. **Clone the repository**:

    ```bash
    git clone https://github.com/RbSCR/joy_checker_rqml_plugins.git
    git clone https://github.com/StefanFabian/qml6_ros2_plugin.git -b $ROS_DISTRO
    git clone https://github.com/StefanFabian/rqml.git
    ```

    *(Replace `<distro>` with your ROS 2 distribution, e.g., `jazzy`, `kilted`)*

    This clones both this repository and the two main dependencies [RQml](https://github.com/StefanFabian/rqml) and [QML6 ROS2 Plugin](https://github.com/StefanFabian/qml6_ros2_plugin).

    This package is not available on a distro.

    RQml is currently not yet available on all distros. If it is available on yours, you may omit cloning it.

    >[!NOTE]
    > RQml uses qt6 which currently is only available in `rolling`.

3. **Install dependencies** (using rosdep):

    ```bash
    cd ~/ros2_ws
    rosdep install --from-paths src --ignore-src -r -y
    ```

4. **Build the workspace**:

    ```bash
    colcon build --symlink-install --packages-up-to joy_checker_rqml_plugins rqml_default_plugins
    ```

    >[!NOTE]
    > Without `rqml_default_plugins` the default plugins will not be available in the application.
    > For the plugins in this package these default plugins are not needed, but you won't have
    > the opportunity to check them out 😃.

5. **Source the workspace**:

    ```bash
    source install/setup.bash
     ```

---
![QML6](https://img.shields.io/badge/Language-QML6-green)
![License](https://img.shields.io/badge/License-GPL--3-orange)

Tested with:

![ROS2 Rolling](https://img.shields.io/badge/ROS2-Rolling-blue)

---
