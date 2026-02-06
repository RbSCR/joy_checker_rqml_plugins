cmake_minimum_required(VERSION 3.15)
project(joy_checker_rqml_plugins)

find_package(ament_cmake REQUIRED)

# Install QML files
install(DIRECTORY qml DESTINATION share/${PROJECT_NAME})

# Register the plugin resource
ament_index_register_resource(rqml_plugin CONTENT_FILE rqml_plugins.yaml.in)

ament_environment_hooks(register_qml_module.dsv.in)

ament_package()
