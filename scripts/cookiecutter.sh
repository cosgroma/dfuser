# This is a script that will be sourced into the login shell
# This script is used to check and setup the user's environment for cookiecutter based projects

# Usage: cookiecutter [OPTIONS] [TEMPLATE] [EXTRA_CONTEXT]...

#   Create a project from a Cookiecutter project template (TEMPLATE).

#   Cookiecutter is free and open source software, developed and managed by
#   volunteers. If you would like to help out or fund the project, please get in
#   touch at https://github.com/cookiecutter/cookiecutter.

# Options:
#   -V, --version                Show the version and exit.
#   --no-input                   Do not prompt for parameters and only use
#                                cookiecutter.json file content. Defaults to
#                                deleting any cached resources and redownloading
#                                them. Cannot be combined with the --replay
#                                flag.
#   -c, --checkout TEXT          branch, tag or commit to checkout after git
#                                clone
#   --directory TEXT             Directory within repo that holds
#                                cookiecutter.json file for advanced
#                                repositories with multi templates in it
#   -v, --verbose                Print debug information
#   --replay                     Do not prompt for parameters and only use
#                                information entered previously. Cannot be
#                                combined with the --no-input flag or with extra
#                                configuration passed.
#   --replay-file PATH           Use this file for replay instead of the
#                                default.
#   -f, --overwrite-if-exists    Overwrite the contents of the output directory
#                                if it already exists
#   -s, --skip-if-file-exists    Skip the files in the corresponding directories
#                                if they already exist
#   -o, --output-dir PATH        Where to output the generated project dir into
#   --config-file PATH           User configuration file
#   --default-config             Do not load a config file. Use the defaults
#                                instead
#   --debug-file PATH            File to be used as a stream for DEBUG logging
#   --accept-hooks [yes|ask|no]  Accept pre/post hooks
#   -l, --list-installed         List currently installed templates.
#   --keep-project-on-failure    Do not delete project folder on failure
#   -h, --help                   Show this message and exit.

# export COOKIECUTTER_CONFIG=/home/audreyr/my-custom-config.yaml
# If you wish to stick to the built-in config and not load any user config file at all, use the CLI option --default-config instead. Preventing Cookiecutter from loading user settings is crucial for writing integration tests in an isolated environment.

# Example user config:

# default_context:
#     full_name: "Audrey Roy"
#     email: "audreyr@example.com"
#     github_username: "audreyr"
# cookiecutters_dir: "/home/audreyr/my-custom-cookiecutters-dir/"
# replay_dir: "/home/audreyr/my-custom-replay-dir/"
# abbreviations:
#     pp: https://github.com/audreyfeldroy/cookiecutter-pypackage.git
#     gh: https://github.com/{0}.git
#     bb: https://bitbucket.org/{0}


# CC_CONFIG_FILE_TEMPLATE='''
# default_context:
#     full_name: "{full_name}"
#     email: "{email}"
#     github_username: "{github_username}"
# cookiecutters_dir: "{cookiecutters_dir}"
# replay_dir: "{replay_dir}"
# '''

# function cc_make_config_file() {
#     local full_name email github_username cookiecutters_dir replay_dir pp gh
#     full_name="${1:-$USER}"
#     email="${2:-$EMAIL}"
#     github_username="${3:-$GITHUB_USERNAME}"
#     cookiecutters_dir="${4:-$HOME/.cookiecutters}"
#     replay_dir="${5:-$HOME/.cookiecutter_replay}"

