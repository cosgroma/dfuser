export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

function get_go_version() {
    go version | awk '{print $3}' | sed 's/go//'
}

function download_go() {
    local version=$1
    local os=$2
    local arch=$3
    local file="go${version}.${os}-${arch}.tar.gz"
    local url="https://dl.google.com/go/${file}"
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
    local url="https://dl.google.com/go/${file}"

    curl -sI $url | grep -q "200 OK"
}

function list_go_versions() {
    curl -s https://golang.org/dl/ | grep -o 'go[0-9.]*\.src\.tar\.gz' | sed 's/go//;s/\.src\.tar\.gz//'
}

goenv(){
    local version=$1
    local os=$(uname | tr '[:upper:]' '[:lower:]')
    local arch=$(uname -m)
    local dest="/usr/local/go"

    if [ -z $version ]; then
        echo "Usage: goenv <version>"
        return 1
    fi

    if [ -d $dest ]; then
        sudo rm -rf $dest
    fi

    if query_go_version $version $os $arch; then
        download_go $version $os $arch
    else
        echo "Version $version not found"
        return 1
    fi
}

function query_go_help() {
    go help $1 | sed '1,/^The commands are:/d'
}

function query_go_help_web() {
    local cmd=$1
    local url="https://golang.org/pkg/cmd/$cmd/"
    curl -s $url | grep -A 1 '<h2 id="pkg-overview">OVERVIEW</h2>' | sed 's/<[^>]*>//g'
}