# drupal_10_nginx_php_fpm
# Updated: 27 Jun 2024

Shows how to configure a Docker container for Drupal 10, nginx, and PHP-FPM.

## Install Docker and Docker Compose
You can use these instructions to set up Docker

### Linux Instructions
Install Docker CE (also called "Docker Engine"):
* CentOS: https://docs.docker.com/engine/install/centos/
* Debian: https://docs.docker.com/engine/install/debian/
* Fedora: https://docs.docker.com/engine/install/fedora/
* Ubuntu: https://docs.docker.com/engine/install/ubuntu/
* Others: https://docs.docker.com/engine/install/
Install Docker Compose:
* https://docs.docker.com/compose/install/standalone/

### Windows Instructions
Install Docker Desktop for Windows:
* https://docs.docker.com/desktop/install/windows-install/
  * Already includes Docker Compose

### Mac Instructions
Install Docker Desktop for Mac:
* https://docs.docker.com/desktop/install/mac-install/
  * Already includes Docker Compose
  * Note that there are two installers
    * One is for "Apple Silicon"
    * The other is for Mac with the Intel chip


## Clone the Repository
The first thing you need to do, of course, is to clone (or download and unzip) this repository.
For the purposes of these instructions we'll call the directory into which you place the
cloned repository as `/path/to/repo`.

## Change the configuration
All configuration for the scripts provided are in `/path/to/repo/Docker/secrets.sh`.
* If you are on Windows, look for `C:\path\to\repo\Docker\secrets.cmd`.
* Make changes as suits your environment

## Build the Image on Windows
Open a command prompt to perform the installation.
* You can use `C:\path\to\repo\admin.bat` to help you with the image.
* Build the image as follows:
```
cd \path\to\repo\
admin build
```
Add "drupal.local" to your "hosts" file
* The Windows "hosts" file is found here:
```
C:\System Files\System32\drivers\etc\hosts
```
* Use Notepad or a plain text editor to add this entry at the end:
```
10.10.60.10   drupal.local
```
Bring the image online:
```
admin up
```

Shell Into the Image:
```
admin shell
```

## Build the Image on Linux or Mac
Open a terminal window to perform the installation.
* You can use `/path/to/repo/admin.sh` to help you with the image.
* Build the image as follows:
```
cd /path/to/repo/
./admin.sh build
```
Add "drupal.local" to your "hosts" file
* Use a plain text editor (e.g., vi or nano) to add this entry at the end:
```
10.10.60.10   drupal.local
```
Bring the image online:
```
./admin.sh up
```

Shell Into the Image:
```
./admin.sh shell
```

## Install Drupal Using the Image
You can install Drupal shelled into the Docker container
* You'll be doing this as the `root` user
* The installation will actually be on a shared folder which lets you edit the source code from outside the container
```
# /home/training/install_drupal.sh
```



