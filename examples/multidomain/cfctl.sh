#!/usr/bin/env bash
# A menu driven shell script for managing multiple zones with the terraform-cloudflare-dns module.

# Set Bash strict modes
set -o errexit 
set -o nounset
set -o pipefail
IFS=$'\n\t'
trap '' SIGINT SIGQUIT SIGTSTP

####################
# SCRIPT VARIABLES #
####################

# Set debug
#set -x

# Define command locations
TF_BIN=/usr/bin/terraform

# Define constants
STD="\033[0;0;39m"
RED="\033[0;31m"          # Red
BLUE="\033[0;34m"         # Blue
PURPLE="\033[0;35m"       # Purple

# Define globals
zonePath=${1:-}
declare -A zoneFile


####################
# SCRIPT FUNCTIONS #
####################

# Function for printing the script usage
function usage() {

	# Display help text
	cat <<EOF

Usage:
  $0 [Options] <Args>

Required options:
  -p <zone path>	Path to zones

Example:
  $0 -p ./zones/

EOF

	# Exit with error
	exit -1	
}


# Function Pause
function pause() {
        read -p "Press [Enter] key to continue..." fackEnterKey
}

# Function createWorkspace
function createWorkspace() {
	# Create and init workspace
	TF_WORKSPACE=${1} ${TF_BIN} init || { echo "Error creating workspace! Error: $?"; return 1; }
	${TF_BIN} workspace \select ${1} || { echo "Workspace does not exist! Error: $?"; return 1; }
	return 0;
}

# Function selectWorkspace
function selectWorkspace() {
	# Select workspace 
	${TF_BIN} workspace \select ${1} || { echo "Workspace does not exist! Error: $?"; return 1; }
	tfWorkspace=$(${TF_BIN} workspace show)
	return 0;
}

# Function deleteWorkspace
function deleteWorkspace() {
	# Delete workspace and return to default
	${TF_BIN} workspace \select default || { echo "Workspace does not exist! Error: $?"; return 1; }
	${TF_BIN} workspace delete ${1} || { echo "Error deleting workspace! Error: $?"; return 1; }
	return 0;
}


##########
# SCRIPT #
##########

# Get command line arguements
while getopts p: opt
do
	case $opt in
		p)
			zonePath="$OPTARG"
			;;
		?)
			usage
			;;
	esac
done

# Check path exists
if [[ ! -d ${zonePath:-} ]] 
then
	echo "First parameter needs to be a directory containing zone configuration files."
	exit 1
fi

# Check if zone files exist
if [[ ! $(ls -1 ${zonePath:-}/*.vars | wc -l) -ne 0 ]] 
then
	echo "Missing zone files."
	exit 1
fi



# Create menu for config choice
i=1
        clear
        cat <<EOF
~~~~~~~~~~~~~~~~~~~~~  
 S E L E C T  C F G
~~~~~~~~~~~~~~~~~~~~~

EOF

# Display var files excluding files beginning with '_'
for file in $(find ${zonePath} -maxdepth 1 -name '*.vars' ! -name '_*'); do
	echo "[ ${i} ] - ${file}"
	zoneFile[${i}]="${file}"
	((i++))
done

# Choose config file
input=0
echo
while [[ ! "${input:-}" =~ ^[0-9]+$ || ${input:-} -lt 1 || ${input:-} -gt ${i}-1 ]]; do
	read -p "Select a config: " input
done

# Set workspace name
tfWorkspace=$(basename ${zoneFile[${input}]} .vars)

while [[ 1 ]]; do
        clear
	cat <<EOF
~~~~~~~~~~~~~~~~~~~
 M A I N - M E N U
~~~~~~~~~~~~~~~~~~~
	
Zone: ${tfWorkspace:-}

 1.  Create/Update Resources
 2.  Retrieve Resource Summary
 3.  Delete Resources

 x.  Exit

EOF
	read -p "Enter choice [ 1 - 3 ]: " choice

    case $choice in
			1)
				createWorkspace ${tfWorkspace} && rc=$? || rc=$?
				if [[ ${rc} -eq 0 ]]
				then
				${TF_BIN} apply -var-file ${zoneFile[${input}]} || { echo "Error: $?"; };
                fi	
                pause ;;
            2) 
                selectWorkspace ${tfWorkspace} && rc=$? || rc=$?
                if [[ ${rc} -eq 0 ]]
                then
                    ${TF_BIN} output || { echo "Error: $?"; };
                fi
                pause ;;
            3) 
                selectWorkspace ${tfWorkspace} && rc=$? || rc=$?
                if [[ ${rc} -eq 0 ]]
                then
                    ${TF_BIN} destroy -var-file ${zoneFile[${input}]} && { deleteWorkspace ${tfWorkspace}; } || { echo "Error: $?"; }; 
                fi
                pause ;;
            x) exit 0 ;;
            *) echo -e "${RED}Error...${STD}" && sleep 0.5 ;;
    esac
done

exit 0
