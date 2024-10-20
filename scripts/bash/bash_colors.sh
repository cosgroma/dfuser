DULL=0
BRIGHT=1

FG_BLACK=30
FG_RED=31
FG_GREEN=32
FG_YELLOW=33
FG_BLUE=34
FG_VIOLET=35
FG_CYAN=36
FG_WHITE=37

FG_NULL=00

BG_BLACK=40
BG_RED=41
BG_GREEN=42
BG_YELLOW=43
BG_BLUE=44
BG_VIOLET=45
BG_CYAN=46
BG_WHITE=47

BG_NULL=00

##
# ANSI Escape Commands
##
# ESC="\033"
CSTART=""
CEND=""
ESC="\e"
NORMAL="$CSTART$ESC[0m$CEND"
RESET="$CSTART$ESC[${DULL};${FG_WHITE};${BG_NULL}m$CEND"

BLACK="$CSTART$ESC[${DULL};${FG_BLACK}m$CEND"
RED="$CSTART$ESC[${DULL};${FG_RED}m$CEND"
GREEN="$CSTART$ESC[${DULL};${FG_GREEN}m$CEND"
YELLOW="$CSTART$ESC[${DULL};${FG_YELLOW}m$CEND"
BLUE="$CSTART$ESC[${DULL};${FG_BLUE}m$CEND"
VIOLET="$CSTART$ESC[${DULL};${FG_VIOLET}m$CEND"
CYAN="$CSTART$ESC[${DULL};${FG_CYAN}m$CEND"
WHITE="$CSTART$ESC[${DULL};${FG_WHITE}m$CEND"

# BRIGHT TEXT
BRIGHT_BLACK="$CSTART$ESC[${BRIGHT};${FG_BLACK}m$CEND"
BRIGHT_RED="$CSTART$ESC[${BRIGHT};${FG_RED}m$CEND"
BRIGHT_GREEN="$CSTART$ESC[${BRIGHT};${FG_GREEN}m$CEND"
BRIGHT_YELLOW="$CSTART$ESC[${BRIGHT};${FG_YELLOW}m$CEND"
BRIGHT_BLUE="$CSTART$ESC[${BRIGHT};${FG_BLUE}m$CEND"
BRIGHT_VIOLET="$CSTART$ESC[${BRIGHT};${FG_VIOLET}m$CEND"
BRIGHT_CYAN="$CSTART$ESC[${BRIGHT};${FG_CYAN}m$CEND"
BRIGHT_WHITE="$CSTART$ESC[${BRIGHT};${FG_WHITE}m$CEND"

function show_colors() {
    echo -e "${BLACK}BLACK${NORMAL}"
    echo -e "${RED}RED${NORMAL}"
    echo -e "${GREEN}GREEN${NORMAL}"
    echo -e "${YELLOW}YELLOW${NORMAL}"
    echo -e "${BLUE}BLUE${NORMAL}"
    echo -e "${VIOLET}VIOLET${NORMAL}"
    echo -e "${CYAN}CYAN${NORMAL}"
    echo -e "${WHITE}WHITE${NORMAL}"
    echo -e "${BRIGHT_BLACK}BRIGHT_BLACK${NORMAL}"
    echo -e "${BRIGHT_RED}BRIGHT_RED${NORMAL}"
    echo -e "${BRIGHT_GREEN}BRIGHT_GREEN${NORMAL}"
    echo -e "${BRIGHT_YELLOW}BRIGHT_YELLOW${NORMAL}"
    echo -e "${BRIGHT_BLUE}BRIGHT_BLUE${NORMAL}"
    echo -e "${BRIGHT_VIOLET}BRIGHT_VIOLET${NORMAL}"
    echo -e "${BRIGHT_CYAN}BRIGHT_CYAN${NORMAL}"
    echo -e "${BRIGHT_WHITE}BRIGHT_WHITE${NORMAL}"
}

# Reset
Color_Off="\[\033[0m\]"       # Text Reset

# Regular Colors
Black="\[\033[0;30m\]"        # Black
Red="\[\033[0;31m\]"          # Red
Green="\[\033[0;32m\]"        # Green
Yellow="\[\033[0;33m\]"       # Yellow
Blue="\[\033[0;34m\]"         # Blue
Purple="\[\033[0;35m\]"       # Purple
Cyan="\[\033[0;36m\]"         # Cyan
White="\[\033[0;37m\]"        # White

# Bold
BBlack="\[\033[1;30m\]"       # Black
BRed="\[\033[1;31m\]"         # Red
BGreen="\[\033[1;32m\]"       # Green
BYellow="\[\033[1;33m\]"      # Yellow
BBlue="\[\033[1;34m\]"        # Blue
BPurple="\[\033[1;35m\]"      # Purple
BCyan="\[\033[1;36m\]"        # Cyan
BWhite="\[\033[1;37m\]"       # White

# Underline
UBlack="\[\033[4;30m\]"       # Black
URed="\[\033[4;31m\]"         # Red
UGreen="\[\033[4;32m\]"       # Green
UYellow="\[\033[4;33m\]"      # Yellow
UBlue="\[\033[4;34m\]"        # Blue
UPurple="\[\033[4;35m\]"      # Purple
UCyan="\[\033[4;36m\]"        # Cyan
UWhite="\[\033[4;37m\]"       # White

# Background
On_Black="\[\033[40m\]"       # Black
On_Red="\[\033[41m\]"         # Red
On_Green="\[\033[42m\]"       # Green
On_Yellow="\[\033[43m\]"      # Yellow
On_Blue="\[\033[44m\]"        # Blue
On_Purple="\[\033[45m\]"      # Purple
On_Cyan="\[\033[46m\]"        # Cyan
On_White="\[\033[47m\]"       # White

# High Intensty
IBlack="\[\033[0;90m\]"       # Black
IRed="\[\033[0;91m\]"         # Red
IGreen="\[\033[0;92m\]"       # Green
IYellow="\[\033[0;93m\]"      # Yellow
IBlue="\[\033[0;94m\]"        # Blue
IPurple="\[\033[0;95m\]"      # Purple
ICyan="\[\033[0;96m\]"        # Cyan
IWhite="\[\033[0;97m\]"       # White

# Bold High Intensty
BIBlack="\[\033[1;90m\]"      # Black
BIRed="\[\033[1;91m\]"        # Red
BIGreen="\[\033[1;92m\]"      # Green
BIYellow="\[\033[1;93m\]"     # Yellow
BIBlue="\[\033[1;94m\]"       # Blue
BIPurple="\[\033[1;95m\]"     # Purple
BICyan="\[\033[1;96m\]"       # Cyan
BIWhite="\[\033[1;97m\]"      # White

# High Intensty backgrounds
On_IBlack="\[\033[0;100m\]"   # Black
On_IRed="\[\033[0;101m\]"     # Red
On_IGreen="\[\033[0;102m\]"   # Green
On_IYellow="\[\033[0;103m\]"  # Yellow
On_IBlue="\[\033[0;104m\]"    # Blue
On_IPurple="\[\033[10;95m\]"  # Purple
On_ICyan="\[\033[0;106m\]"    # Cyan
On_IWhite="\[\033[0;107m\]"   # White

# Various variables you might want for your PS1 prompt instead
Time12h="\T"
Time12a="\@"
PathShort="\w"
PathFull="\W"
NewLine="\n"
Jobs="\j"

function show_examples() {
    echo -e "${BBlack}BBlack${Color_Off}"
    echo -e "${BRed}BRed${Color_Off}"
    echo -e "${BGreen}BGreen${Color_Off}"
    echo -e "${BYellow}BYellow${Color_Off}"
    echo -e "${BBlue}BBlue${Color_Off}"
    echo -e "${BPurple}BPurple${Color_Off}"
    echo -e "${BCyan}BCyan${Color_Off}"
    echo -e "${BWhite}BWhite${Color_Off}"
    echo -e "${BIBlack}BIBlack${Color_Off}"
    echo -e "${BIRed}BIRed${Color_Off}"
    echo -e "${BIGreen}BIGreen${Color_Off}"
    echo -e "${BIYellow}BIYellow${Color_Off}"
    echo -e "${BIBlue}BIBlue${Color_Off}"
    echo -e "${BIPurple}BIPurple${Color_Off}"
    echo -e "${BICyan}BICyan${Color_Off}"
    echo -e "${BIWhite}BIWhite${Color_Off}"
    echo -e "${On_Black}On_Black${Color_Off}"
    echo -e "${On_Red}On_Red${Color_Off}"
    echo -e "${On_Green}On_Green${Color_Off}"
    echo -e "${On_Yellow}On_Yellow${Color_Off}"
    echo -e "${On_Blue}On_Blue${Color_Off}"
    echo -e "${On_Purple}On_Purple${Color_Off}"
    echo -e "${On_Cyan}On_Cyan${Color_Off}"
    echo -e "${On_White}On_White${Color_Off}"
    echo -e "${On_IBlack}On_IBlack${Color_Off}"
    echo -e "${On_IRed}On_IRed${Color_Off}"
    echo -e "${On_IGreen}On_IGreen${Color_Off}"
    echo -e "${On_IYellow}On_IYellow${Color_Off}"
    echo -e "${On_IBlue}On_IBlue${Color_Off}"
    echo -e "${On_IPurple}On_IPurple${Color_Off}"
    echo -e "${On_ICyan}On_ICyan${Color_Off}"
    echo -e "${On_IWhite}On_IWhite${Color_Off}"
    echo -e "${IBlack}IBlack${Color_Off}"
    echo -e "${IRed}IRed${Color_Off}"
    echo -e "${IGreen}IGreen${Color_Off}"
    echo -e "${IYellow}IYellow${Color_Off}"
    echo -e "${IBlue}IBlue${Color_Off}"
    echo -e "${IPurple}IPurple${Color_Off}"
    echo -e "${ICyan}ICyan${Color_Off}"
    echo -e "${IWhite}IWhite${Color_Off}"
    echo -e "${BIBlack}BIBlack${Color_Off}"
}