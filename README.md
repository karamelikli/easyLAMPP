# easyLAMPP
## Install All web-based servers easily.
### Lazy coders' version

Make install.sh executable. 
Run it in termeinal by ./install.sh

This installation script includes **PHP, Apache, MySql, PhpMyadmin, pear**, and other related packages for web-based coding. Thşs script uses the core packages on Ubuntu. Therefore, all packages will be updated automatically. Configurations are quickly done by automatically opening related config files and continuing for the next operation.


This solution belongs to the previous version of MySQL. By logging in to MySQL using socket authentication, you can do it.

sudo mysql -u root
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';

