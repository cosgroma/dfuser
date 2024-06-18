export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

function get_arch() {
    local arch=$(uname -m)
    case $arch in
        x86_64)
            echo "amd64"
            ;;
        *)
            echo $arch
            ;;
    esac
} 

function get_go_version() {
    go version | awk '{print $3}' | sed 's/go//'
}

# https://go.dev/dl/
# https://go.dev/dl/go1.22.4.linux-amd64.tar.gz

GOLANG_DL_URL="https://go.dev/dl"

function download_go() {
    local version=$1
    local os=$2
    local arch=$(get_arch)
    local file="go${version}.${os}-${arch}.tar.gz"
    local url="$GOLANG_DL_URL/$file"
    local dest="/tmp/${file}"

    curl -L -o $dest $url
    sudo tar -C /usr/local -xzf $dest
    rm $dest
}

function query_go_version() {
    local version=$1
    local os=$2
    local arch=$3
    local file="go${version}.${os}-${arch}.tar.gz"
    local url="$GOLANG_DL_URL/$file"

    if wget -q --spider $url; then
        return 0
    else
        return 1
    fi
}

# <tr class=" ">
#   <td class="filename"><a class="download" href="/dl/go1.3rc1.windows-386.msi">go1.3rc1.windows-386.msi</a></td>
#   <td>Installer</td>
#   <td>Windows</td>
#   <td>x86</td>
#   <td></td>
#   <td><tt>23534cce0db1f8c0cc0cf0f70472df59ac26bbfa</tt></td>
# </tr>


function goenv_cmd_list() {
    # 1.9.7.linux-amd64
    # 1.9.7.linux-arm64
    # 1.9.7.linux-armv6l
    # 1.9.7.linux-ppc64le
    # 1.9.7.linux-s390x
    # 1.9.darwin-amd64
    # 1.9.freebsd-386
    # 1.9.freebsd-amd64

    version_list=$(wget -qO- $GOLANG_DL_URL | \
    grep -oE "go[0-9]+\.[0-9]+(\.[0-9]+)?\.[a-z0-9]+-[a-z0-9]+\.tar\.gz" | sort | \
    uniq | sed 's/^go//' | sed 's/\.tar\.gz$//' | cut -d'.' -f 1,2,3)

    # echo $version_list | tr ' ' '\n' | sort -V | column -t

    # | sed 's/-/\t/' | column -t | \
    # If version_list item has a dash, replace with tab
    echo $version_list | tr ' ' '\n' | sort -V | \
    while read v; do
        if echo $v | grep -q "-"; then
            echo $v | sed 's/-/\t/' | cut -d'.' -f 1,2
        else
            echo $v
        fi
    done | sort -V | column -t


}

function goenv_cmd_install() {
    local version=$1
    local os=$(uname | tr '[:upper:]' '[:lower:]')
    local arch=$(get_arch)

    if [ -z $version ]; then
        echo "Usage: goenv install <version>"
        return 1
    fi

    if query_go_version $version $os $arch; then
        download_go $version $os $arch
    else
        echo "Version $version.$os-$arch not found"
        return 1
    fi
}

function goenv_cmd_remove() {
    local version=$1
    local dest="/usr/local/go"

    if [ -z $version ]; then
        echo "Usage: goenv remove <version>"
        return 1
    fi

    if [ -d $dest ]; then
        sudo rm -rf $dest
    else
        echo "Go not found at $dest"
        return 1
    fi
}

function goenv_cmd_use() {
    local version=$1
    local dest="/usr/local/go"

    if [ -z $version ]; then
        echo "Usage: goenv use <version>"
        return 1
    fi

    if [ -d $dest ]; then
        export GOROOT=$dest
        export PATH=$GOROOT/bin:$PATH
    else
        echo "Go not found at $dest"
        return 1
    fi
}

os=$(uname | tr '[:upper:]' '[:lower:]')
arch=$(uname -m)
dest="/usr/local/go"



goenv(){
    local cmd=$1
    shift
    case $cmd in
        list)
            goenv_cmd_list
            ;;
        install)
            goenv_cmd_install $@
            ;;
        remove)
            goenv_cmd_remove $@
            ;;
        use)
            goenv_cmd_use $@
            ;;
        *)
            echo "Usage: goenv <list|install|remove|use>"
            return 1
            ;;
    esac

}

function query_go_help() {
    go help $1 | sed '1,/^The commands are:/d'
}

function query_go_help_web() {
    local cmd=$1
    local url="https://golang.org/pkg/cmd/$cmd/"
    curl -s $url | grep -A 1 '<h2 id="pkg-overview">OVERVIEW</h2>' | sed 's/<[^>]*>//g'
}