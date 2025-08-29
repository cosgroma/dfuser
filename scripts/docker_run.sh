# my info
export uname=$(id -u -n) #magpajc
export uid=$(id -u)
export gname=$(id -g -n)
export gid=$(id -g)

export gid_sgt=1000
export gname_sgt=sergeant

docker_image=carlesfernandez/docker-gnsssdr
# docker_image=sergeant/ubuntu


docker run -it \
    --user $uid:$gid \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
    --volume="/etc/sudoers:/etc/sudoers:ro" \
    -v /home/$uname:/home/$uname \
    --network host \
    $docker_image \
     /bin/bash

args=""
args="$args -it"
args="$args -rm"
args="$args --user $uid:$gid"
args="$args --volume="/etc/group:/etc/group:ro""
args="$args --volume="/etc/passwd:/etc/passwd:ro""
args="$args --volume="/etc/shadow:/etc/shadow:ro""
args="$args --volume="/etc/sudoers:/etc/sudoers:ro""
args="$args --workdir="/home/$uname/workspace/sergeant/designs/igem""
args="$args --network host"
args="$args -e DISPLAY=host.docker.internal:0 -v $HOME/.Xauthority:/root/.Xauthority"

make_user_args(){
    # args from first argument in function
    args=$1;
    args="$args --user $uid:$gid";
    args="$args --volume="/etc/group:/etc/group:ro"";
    args="$args --volume="/etc/passwd:/etc/passwd:ro"";
    args="$args --volume="/etc/shadow:/etc/shadow:ro"";
    args="$args --volume="/etc/sudoers:/etc/sudoers:ro"";
    args="$args -v /home/$uname:/home/$uname";
}

# directory_list=(
# "/media/"
# "/opt/"
# "/home/$uname/workspace/sergeant/designs/igem"
# )
# args="$args -v /media/:/media/"
# args="$args -v /opt/:/opt/"
# args="$args -v /tmp/.X11-unix:/tmp/.X11-unix"
# args="$args -v /dev:/dev"


# docker run -it \
#     --user $uid:$gid \
#     --volume="/etc/group:/etc/group:ro" \
#     --volume="/etc/passwd:/etc/passwd:ro" \
#     --volume="/etc/shadow:/etc/shadow:ro" \
#     --volume="/etc/sudoers:/etc/sudoers:ro" \
#     --workdir="/home/$uname/workspace/sergeant/designs/igem" \
#     -v /media/:/media/ \
#     -v /opt/:/opt/ \
#     -v /home/$uname:/home/$uname \
#     --network host \
#      /bin/bash
# docker run -e DISPLAY=host.docker.internal:0 -v $HOME/.Xauthority:/root/.Xauthority \


# docker run -it \
#     -v /opt/:/opt/ \
#     --network host \
#     sergeant/ubuntu /bin/bash
