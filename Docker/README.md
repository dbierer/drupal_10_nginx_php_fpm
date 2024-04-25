# WP Automation

Creates a base WP installation in a Docker container.
WordPress core comes from the [Roots Bedrock project](https://roots.io/bedrock/).
Administration is done using [WP-CLI](https://wp-cli.org/).

## Prepare for Installation
To run the demo using the existing demo "secrets", proceed as follows:
1. Install Docker
    * If you are running Windows, start here: [https://docs.docker.com/docker-for-windows/install/](https://docs.docker.com/docker-for-windows/install/).
    * If you are on a Mac, start here: [https://docs.docker.com/docker-for-mac/install/](https://docs.docker.com/docker-for-mac/install/).
    * If you are on Linux, have a look here: [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/).
2. Install Docker Compose.  For all operating systems, start here: [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/).
3. Clone this repository
If you have installed git, use the following command:
```
git clone https://github.com/dbierer/automated_wp_installation.git /path/to/repo
```
Otherwise, you can simply download and unzip from this URL: [https://github.com/dbierer/automated_wp_installation/archive/main.zip](https://github.com/dbierer/automated_wp_installation/archive/main.zip),
and then unzip into a folder you create which we refer to as `/path/to/repo` in this guide

If you plan to use this as a basis for your own WordPress website, here is the recommended procedure:
1. Fork this repository into your own account on Github or otherwise.
2. Clone the fork onto the server you plan to use to host Docker


## Configure Website Settings

### Basic Settings
If you're running Docker on Linux or Mac:
* Set entries to all settings in `example.secrets.dist` and rename to `secrets.sh`
If you're running Docker on Windows:
* Set entries to all settings in `example.secrets.cmd.dist` and rename to `secrets.cmd`

### WordPress Package Sources
To configure the list of packages you wish to install from `wpackagist.org` (recommended!):
* See [WordPress Packagist](https://wpackagist.org/) for more information
* Because these packages are installed using Composer, the update process can be automated
* Modify `INSTALL_WPACKAGIST` by adding a list of comma separated plugins in quotes after the "=" sign.  Example:
```
export INSTALL_WPACKAGIST="wordpress-seo,add-from-server,jetpack"
```

To configure the list of packages you wish to install from `packagist.org` (also recommended):
* See [Packagist](https://packagist.org/) for more information
* Because these packages are installed using Composer, the update process can be automated
* Modify `INSTALL_PACKAGIST` by adding a list of comma separated plugins in quotes after the "=" sign.  Example:
```
export INSTALL_PACKAGIST="roots/wp-password-bcrypt,upstatement/routes"
```

To configure the list of packages you wish to install directly from WordPress:
* Modify `INSTALL_WP_PLUGINS` by adding a list of comma separated plugins in quotes after the "=" sign.  Example:
```
export INSTALL_WP_PLUGINS="woocommerce,akismet"
```

### Disable Package Source
If you do not wish to use one of the three provided WP package sources, simply set the value to `""`.
This example disables the `packgist.org` source:
export INSTALL_PACKAGIST=""
```
```

## Install the Website

### From Windows
NOTE: you must have Docker Desktop for Windows installed.
To perform the installation, open a Windows _Power Shell_ prompt and proceed as follows:
```
cd C:\path\to\repo
admin build
```
NOTES:
* you only need to run `build` the first time.

To bring the website online:
```
cd C:\path\to\repo
admin up
```
NOTES:
* if a backup file is available, it's restored along with the database

To take the website offline:
```
cd C:\path\to\repo
admin down
```
NOTES:
* a backup of the website files is made in the form of a ZIP file
* a backup of the database is made in the `REPO_BACKUP_DIR` directory
* the `takeown` command is run to restore full ownership of files in the `C:\path\to\repo` folder
* if you don't want the back, add the `--no-backup`` flag:
```
cd C:\path\to\repo
admin down --no-backup
```

To open a command shell into the website Docker container:
```
cd C:\path\to\repo
admin shell
```

## To access the WordPress site
From a browser on your host computer (outside the Docker container):
```
http://<DNS>
```
NOTES:
* In place of `<DNS>` enter the setting from `secrets.sh` you made for `DNS`

To login as admin use the value you set in the "secrets" file for `WP_HIDE_LOGIN`:
```
http://<DNS>/?<WP_HIDE_LOGIN>
```
NOTES:
* In place of `<DNS>` enter the setting from `secrets.sh` you made for `DNS`
* In place of `<WP_HIDE_LOGIN>` enter the setting from `secrets.sh` you made for `WP_HIDE_LOGIN`

To access the database:
```
http://<DNS>/phpmyadmin
```
NOTES:
* In place of `<DNS>` enter the setting from `secrets.sh` you made for `DNS`


### From Linux or Mac
NOTE: if you are running this on a Mac, you must have Docker Desktop for Mac installed.
To perform the installation, open a terminal window and proceed as follows:
```
cd /path/to/repo
./admin.sh build
```
NOTES:
* you only need to run `build` the first time.

To bring the website online:
```
cd /path/to/repo
./admin.sh up
```
NOTES:
* if a backup file is available, it's restored along with the database

To take the website offline:
```
cd /path/to/repo
./admin.sh down
```
NOTES:
* a backup of the website files is made in the form of a ZIP file
* a backup of the database is made in the `REPO_BACKUP_DIR` directory
* the `chown` and `chmod` commands are run to restore full ownership of files in the `/path/to/repo` folder
* if you don't want the back, add the `--no-backup`` flag:
```
cd /path/to/repo
./admin.sh down --no-backup
```

To open a command shell into the website Docker container:
```
cd /path/to/repo
admin shell
```

## Demo
The `secrets.sh` (or for Windows `secrets.cmd`) files are pre-loaded for a demo.
The following WordPress plugins are installed:
* woocommerce
* elex-bulk-edit-products-prices-attributes-for-woocommerce-basic
* order-import-SET-for-woocommerce
* wordpress-seo
* add-from-server
* jetpack
* w3-total-cache
* imagify"
The following theme is installed:
* business

### Running the Demo in Windows
Assign the IP address `172.18.33.33` to `demo.local`:
* Open _Notepad_ with _administrator_ privileges
* Browse to C:Windows\System32\drivers\etc\hosts
* Open the file
* Add to the bottom of the file `172.18.33.33  demo.local`
* Save and exit

To successfully run the demo, open the Windows _Power Shell_ and proceed as follows:
```
cd C:\path\to\repo
admin build
admin up
```
NOTES:
* you only need to run `admin build` the first time only
* will not work in a regular command prompt: the batch file commands require the _Power Shell_

To stop the demo container (and backup), proceed as follows:
```
cd C:\path\to\repo
admin down
```
NOTES:
* the `takeown` command runs to reset local user permissions.


### Running the Demo in Linx or Mac
Assign the IP address `172.18.33.33` to `demo.local`
```
echo "172.18.33.33  demo.local" >>/etc/hosts
```

To successfully run the demo, open a terminal window and proceed as follows:
```
cd /path/to/repo
./admin.sh build
./admin up
```
NOTE: you only need to run `admin build` the first time only

To stop the demo container (and backup), proceed as follows:
```
cd /path/to/repo
./admin.sh down
```
NOTE: the `chown` command runs to reset local user permissions.


### To access the WordPress site
From a browser on your host computer (outside the Docker container):
```
http://demo.local
```

To login as admin use the value you set in the "secrets" file for `WP_HIDE_LOGIN`:
```
http://demo.local/?not-the-usual-admin
```
NOTES:
* demo login name is `admin`
* demo login password is `password`
