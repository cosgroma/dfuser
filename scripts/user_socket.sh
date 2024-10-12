#!/bin/bash

# This script will create a directory in /run/user with the user's UID if it doesn't exist
# It will check that the directory has the correct permissions and ownership
# It will then create a socket in the directory with the user's UID
# It will check that the socket has the correct permissions and ownership

DFUSER_SOCKET_NAME="dfu.sock"

# Check if the directory exists in /run/user with the user's UID, if it does just return
if [ -d "/run/user/$UID" ]; then
    return 0
fi

# Check if the user's UID is less than 1000
if [ $UID -lt 1000 ]; then
    echo "User's UID is less than 1000, exiting"
    return 1
fi

# Check if the user is in the sudo group
if [ $(groups $USER | grep -c "sudo") -eq 0 ]; then
    echo "User is not in the sudo group, exiting"
    return 1
fi

# Check if the directory exists in /run/user with the user's UID
if [ ! -d "/run/user/$UID" ]; then
    sudo mkdir "/run/user/$UID"
fi

# Check if the directory has the correct ownership
if [ $(stat -c "%U" "/run/user/$UID") != "$USER" ]; then
    sudo chown $USER "/run/user/$UID"
fi

# Check if the directory has the correct permissions
if [ $(stat -c "%a" "/run/user/$UID") -ne 755 ]; then
    chmod 755 "/run/user/$UID"
fi

# # Check if the socket exists in the directory with the user's UID, if not create a domain socket
# if [ ! -S "/run/user/$UID/socket" ]; then
#     # create domain socket
#     sudo touch "/run/user/$UID/$DFUSER_SOCKET_NAME"
# fi

# # Check if the socket has the correct ownership
# if [ $(stat -c "%U" "/run/user/$UID/$DFUSER_SOCKET_NAME") != "$USER" ]; then
#     sudo chown $USER "/run/user/$UID/$DFUSER_SOCKET_NAME"
# fi

# # Check if the socket has the correct permissions
# if [ $(stat -c "%a" "/run/user/$UID/$DFUSER_SOCKET_NAME") -ne 600 ]; then
#     sudo chmod 600 "/run/user/$UID/$DFUSER_SOCKET_NAME"
# fi

# write_to_socket() {
#     echo "Hello, world!" > "/run/user/$UID/$DFUSER_SOCKET_NAME"
# }

# read_from_socket() {
#     cat "/run/user/$UID/$DFUSER_SOCKET_NAME"
# }