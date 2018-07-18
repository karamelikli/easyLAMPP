#! /bin/bash
### Start
clear


kullanici=$HOME
phpMyAdminVer="4.8.2"
 

txtund=$(tput sgr 0 1) # Underline
txtbld=$(tput bold) # Bold
txtred=$(tput setaf 1) # Red
txtgrn=$(tput setaf 2) # Green
txtylw=$(tput setaf 3) # Yellow
txtblu=$(tput setaf 4) # Blue
txtpur=$(tput setaf 5) # Purple
txtcyn=$(tput setaf 6) # Cyan
txtwht=$(tput setaf 7) # White
txtrst=$(tput sgr0) # Text reset
txtund=$(tput sgr 0 1) # Underline
txtbld=$(tput bold) # Bold
bldred=${txtbld}$(tput setaf 1) # red
bldblu=${txtbld}$(tput setaf 4) # blue
bldwht=${txtbld}$(tput setaf 7) # white
txtrst=$(tput sgr0) # Reset
info=${txtgrn}*${txtrst} # Feedback
pass=${bldblu}*${txtrst}
warn=${bldred}!${txtrst}
sorno=0
function chackkur(){
for p; do
 dpkg -s "$p" >/dev/null 2>&1 && {
        echo  $txtgrn$txtbld  $p $txtrst$txtgrn " is installed." $txtrst
    } || {
    echo  $txtred$txtbld  $p $txtrst$txtred " is not installed." $txtrst
    echo $bldblu "Starting to install $p ....."
      echo  $txtpur
      sudo  apt-get install $p  -y
      echo $txtrst
    }
 done
}
function yazdir(){
  echo $txtylw 
  echo ${1} 
  echo $txtrst  
}
function dikkat(){
  echo $txtylw$txtbld
  echo ${1} 
  echo $txtrst  
}
function sor(){
echo $txtcyn$txtbld ${1} $txtylw$txtbld
read ${2}
echo $txtrst
}
function sudolama(){
  echo $bldblu ">> sudo ${1}"
      echo  $txtrst$txtpur
      sudo  ${1}
      echo $txtrst
}
function anladinmi(){
sorno=$(($sorno+1))
sorgir="devam$sorno"
echo -e "${1}"
sor "Devam ? [y/n/e] Yes / No / Exit "   sorgir 

if [ "$sorgir" = 'y' ]
then
echo "vay be"
elif [ "$sorgir" = 'e' ] 
then
echo "ok"
exit

else
 anladinmi "${1}"
  
fi
}










sor "Do you want to start install? [y/n/e] Yes / No / Exit" "devam"
if [ "$devam"  = 'e' ]
then
exit
else
dikkat   "Attention it is started!"  

fi;


if [ "$devam"  = 'y' ]
then

cd $HOME
 mkdir "gecici"
 cd gecici

sudolama "apt-get autoremove /n"
yazdir "oncekileri sil"
sudolama "apt-get remove --purge php5-mysql  -y" 
sudolama "apt-get remove --purge mysql-server -y"
sudolama "apt-get remove --purge libapache2-mod-php5 -y"
sudolama "apt-get remove --purge php5 -y"
sudolama "apt-get remove --purge apache2 -y"
sudolama "apt-get update && apt-get upgrade"
chackkur  "kate" "gedit"  "apache2" "php php7.2-mysql php7.2-curl php7.2-json php7.2-cgi  php7.2 libapache2-mod-php7.2" "libapache2-mod-php" "mysql-server" "php-mysql" "php-curl php-soap php-mcrypt php-xdebug php-zip" "sysbench" " php-pear php-dev libmysqlclient-dev" 
sudolama "a2enmod rewrite"

anladinmi $bldred" Open (Installer will open it for you!) the 000-default.conf file and replace following row.  $bldblu \n
DocumentRoot /var/www/html  $bldred \n
 with following one\n
$bldblu DocumentRoot $kullanici/Public  \n$bldred" 
sudolama "gedit /etc/apache2/sites-enabled/000-default.conf"
anladinmi   $txtylw$txtbld" did you changed it?"$txtrst

anladinmi $bldred"Open (Installer will open it for you!) the  /etc/apache2/apache2.conf dfile and replace following row:  $bldblu \n
<Directory /var/www/>\n AllowOverride None  $bldred \n
 with following one: \n
$bldblu <Directory $kullanici/Public>\n AllowOverride All \n$bldred" 
sudolama "gedit /etc/apache2/apache2.conf"
anladinmi   $txtylw$txtbld" did you changed it?"$txtrst

sudolama "service apache2 restart"


chackkur "curl" "libcurl3" "libcurl3-dev" "php-curl php5-curl"
echo "Tamam $devam";
echo "Dont hurry!!!! DUR BU NE ACELE?!"
sudolama "apt-get update"
chackkur "php-pear"
sudolama "pear channel-discover pear.phpunit.de"
sudolama "pear install phpunit/PHPUnit"
sudolama "pear config-set auto_discover 1"
sudolama "pear install --force --alldeps pear.phpqatools.org/phpqatools"
sudolama "pear install phpunit/PHPUnit_SkeletonGenerator"
sudolama "pear install phpunit/ppw"
sudolama "pear install pear.apigen.org/apigen"
sudolama "pear upgrade"

anladinmi $bldred" Open (Installer will open it for you!) the pear file and exactly one row after  $bldblu \n
#!/bin/sh $bldred \n
you should add following rows:\n
$bldblu export LC_ALL=\"C\"\n
export LANG=\"C\"\n$bldred
" 

sudolama "gedit /usr/bin/pear"
anladinmi   $txtylw$txtbld" did you changed it?"$txtrst



anladinmi   $txtbld$txtpur" Open (Installer will open it for you!) the hosts file $bldred and add following rows:   \n$bldblu 127.0.0.1	www.localhost.com\n 127.0.0.1	localhost.com\n $bldred "
sudolama "gedit /etc/hosts"
anladinmi   $txtylw$txtbld" did you changed it?"$txtrst

sudolama "service apache2 restart"
chackkur "php5-gd"

sudo sh -c 'echo "ServerName localhost" >> /etc/apache2/conf.d/name' && sudo service apache2 restart

#sudolama 'rm -R "/var/www/html/phpMyAdmin"'




#sudolama 'rm -R "/var/www/html/phpMyAdmin"'

cd "$kullanici/Public"

##wget "http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/$phpMyAdminVer/phpMyAdmin-$phpMyAdminVer-all-languages.tar.gz"
wget "https://files.phpmyadmin.net/phpMyAdmin/$phpMyAdminVer/phpMyAdmin-$phpMyAdminVer-all-languages.tar.gz"

sudolama "tar -xzvf phpMyAdmin-$phpMyAdminVer-all-languages.tar.gz -C ./"

sudolama  "mv phpMyAdmin-$phpMyAdminVer-all-languages phpmyadmin"
sudolama  "cp ./phpmyadmin/config.sample.inc.php ./phpmyadmin/config.inc.php"


anladinmi   $bldred"make the following change in it\n $bldblu /* Authentication type */ \n 29 \$cfg['Servers'][\$i]['auth_type'] = ‘cookie’;\n $bldred with \n $bldblu /* Authentication type */\n 29 \$cfg['Servers'][\$i]['auth_type'] = ‘http’; "
sudolama  "gedit ./phpmyadmin/config.inc.php"
anladinmi   $txtylw$txtbld" did you changed it?"$txtrst

dikkat "@@@@@@@@@@@@@@@@@@ All Done!!!......"
cd "/var/www"
sudolama  "mv html _html"
#sudolama  "ln -s  ./phpmyadmin $kullanici/Public/phpmyadmin " 
sudolama  "ln -s  $kullanici/Public html" 

#'/var/www/$site'"

sudolama  "chown -R $USER:$USER ~/Public" 

dikkat "%%%%%%%%%%%%%%%% İşimiz bitti nihayet ......"
 

  cd ~
  rm -R  gecici
else
 # ls

#sudo rm -R  "$kullanici/$site"
#sudo rm -R  "/var/www/$site"
echo "WHAT IS IT"
fi
exit
