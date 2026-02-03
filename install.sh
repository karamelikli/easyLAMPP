#! /bin/bash
### Start
clear

# Configuration
user_home=$HOME
phpMyAdminVer="5.2.1" # Updated to a modern version

# Text Formatting
txtund=$(tput sgr 0 1) # Underline
txtbld=$(tput bold)    # Bold
txtred=$(tput setaf 1) # Red
txtgrn=$(tput setaf 2) # Green
txtylw=$(tput setaf 3) # Yellow
txtblu=$(tput setaf 4) # Blue
txtpur=$(tput setaf 5) # Purple
txtcyn=$(tput setaf 6) # Cyan
txtwht=$(tput setaf 7) # White
txtrst=$(tput sgr0)    # Reset
bldred=${txtbld}$(tput setaf 1)
bldblu=${txtbld}$(tput setaf 4)
bldwht=${txtbld}$(tput setaf 7)
info=${txtgrn}*${txtrst}
pass=${bldblu}*${txtrst}
warn=${bldred}!${txtrst}
question_no=0

# Function: Check and Install Packages
function check_install(){
    for p in "$@"; do
        dpkg -s "$p" >/dev/null 2>&1 && {
            echo "${txtgrn}${txtbld}$p${txtrst}${txtgrn} is already installed.${txtrst}" [cite: 2, 3]
        } || {
            echo "${txtred}${txtbld}$p${txtrst}${txtred} is not installed.${txtrst}" [cite: 3, 4]
            echo "${bldblu}Starting to install $p ...${txtrst}" [cite: 4]
            sudo apt-get install "$p" -y
        }
    done
}

# Function: Print Info
function print_info(){
    echo "${txtylw}${1}${txtrst}"
}

# Function: Print Warning/Attention
function attention(){
    echo "${txtylw}${txtbld}${1}${txtrst}" [cite: 6]
}

# Function: Ask Question
function ask_prompt(){
    echo -e "${txtcyn}${txtbld}${1}${txtylw}${txtbld}"
    read -r ${2}
    echo "${txtrst}"
}

# Function: Run Sudo Commands
function run_sudo(){
    echo "${bldblu}>> sudo ${1}${txtrst}"
    sudo bash -c "${1}" [cite: 5]
}

# Function: Confirmation Loop
function confirm_step(){
    question_no=$((question_no+1))
    local response_var="resp$question_no"
    echo -e "${1}"
    ask_prompt "Continue? [y/n/e] (Yes / No / Exit)" "$response_var"

    if [ "${!response_var}" = 'y' ]; then
        echo "Proceeding..."
    elif [ "${!response_var}" = 'e' ]; then
        echo "Exiting installer."
        exit
    else
        confirm_step "${1}"
    fi
}

# --- Main Script Start ---

ask_prompt "Do you want to start the installation? [y/n/e]" "action"
if [ "$action"  = 'e' ]; then
    exit
else
    attention "Attention: Installation process has started!" [cite: 6]
fi

if [ "$action"  = 'y' ]; then
    cd "$HOME" || exit
    mkdir -p "temp_install"
    cd temp_install

    # Cleanup previous installations
    print_info "Removing previous web server components..."
    run_sudo "apt-get autoremove -y"
    run_sudo "apt-get remove --purge php* apache2* mysql-server* -y"
    run_sudo "apt-get update && apt-get upgrade -y"

    # Install Apache, PHP 8.3, and dependencies
    check_install "kate" "gedit" "apache2" "mysql-server" "curl" "sysbench"
    check_install "php8.3" "libapache2-mod-php8.3" "php8.3-mysql" "php8.3-curl" "php8.3-mbstring" "php8.3-intl" "php8.3-xml" "php8.3-zip" "php8.3-gd" "php8.3-soap"
    
    run_sudo "a2enmod rewrite"

    # Directory Setup
    mkdir -p "$user_home/Public"

    # Apache Configuration - Virtual Host
    confirm_step "${bldred}The installer will open 000-default.conf.\nPlease replace:\n${bldblu}DocumentRoot /var/www/html${bldred}\nWith:\n${bldblu}DocumentRoot $user_home/Public${txtrst}" 
    run_sudo "gedit /etc/apache2/sites-enabled/000-default.conf"
    
    # Apache Configuration - Directory Permissions
    confirm_step "${bldred}The installer will open apache2.conf.\nPlease replace:\n${bldblu}<Directory /var/www/>\n AllowOverride None${bldred}\nWith:\n${bldblu}<Directory $user_home/Public>\n AllowOverride All${txtrst}"
    run_sudo "gedit /etc/apache2/apache2.conf"

    run_sudo "service apache2 restart"

    # PHP Pear and Tools
    print_info "Setting up PHP Pear and development tools..." [cite: 8]
    check_install "php-pear" "php-dev"
    
    # Pear logic often requires manual intervention in modern systems; provided here as requested
    run_sudo "pear config-set auto_discover 1"
    run_sudo "pear upgrade"

    confirm_step "${bldred}Opening /usr/bin/pear.\nAfter the first line ${bldblu}(#!/bin/sh)${bldred}, add:\n${bldblu}export LC_ALL=\"C\"\nexport LANG=\"C\"${txtrst}"
    run_sudo "gedit /usr/bin/pear"

    # Hosts File
    confirm_step "${txtpur}Opening hosts file. Add the following lines:\n${bldblu}127.0.0.1 www.localhost.com\n127.0.0.1 localhost.com${txtrst}" [cite: 9]
    run_sudo "gedit /etc/hosts"

    run_sudo "service apache2 restart"

    # phpMyAdmin Installation
    print_info "Downloading and configuring phpMyAdmin $phpMyAdminVer..."
    cd "$user_home/Public" || exit
    wget "https://files.phpmyadmin.net/phpMyAdmin/$phpMyAdminVer/phpMyAdmin-$phpMyAdminVer-all-languages.tar.gz"
    
    run_sudo "tar -xzvf phpMyAdmin-$phpMyAdminVer-all-languages.tar.gz -C ./"
    run_sudo "mv phpMyAdmin-$phpMyAdminVer-all-languages phpmyadmin"
    run_sudo "cp ./phpmyadmin/config.sample.inc.php ./phpmyadmin/config.inc.php"

    confirm_step "${bldred}In config.inc.php, change:\n${bldblu}auth_type = 'cookie';${bldred}\nTo:\n${bldblu}auth_type = 'http';${txtrst}" 
    run_sudo "gedit ./phpmyadmin/config.inc.php"

    # Final Web Directory Linking
    attention "Finalizing installation..."
    cd "/var/www" || exit
    run_sudo "mv html _html_backup"
    run_sudo "ln -s $user_home/Public html"
    run_sudo "chown -R $USER:$USER $user_home/Public"
    run_sudo "chmod o+x $user_home"
    run_sudo "chmod o+x $user_home/Public"

    attention "All Done! Installation is complete."
    
    cd ~
    rm -rf "temp_install"
else
    echo "Installation canceled."
fi
exit
