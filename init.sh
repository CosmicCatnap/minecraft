#!/bin/bash
# setup user and home dir 

MCUSER="minecraft"
MCHOME="/srv/minecraft"


# check that user exists
function check_user() {
	if getent passwd "$MCUSER" > /dev/null 2>&1; then
    	return true;
	else
		return false;
	fi
}

function create_user() {
	useradd -m "$MCUSER"
	passwd "$MCUSER"
}

# check that user home is configured
function validate_home() {
	if [ -d "$MCHOME" ]; then
		return true;
	else
		return false;
	fi
}

function create_home() {
	mkdir $MCHOME
	chown -R $MCUSER $MCHOME
	usermod -d $MCHOME $MCUSER
}

user_status=validate_user();
home_status=validate_home();
		
echo "### MINECRAFTER INIT"
