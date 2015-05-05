# sanji-bundle-deb-configurator
A Debian package configurator for sanji bundles

## Guide
1. copy all files (exclude README.md) to sanji bundle directory
2. run "configure-debian-pkg.sh" to produce the debian configuration files and Makefile  
    ``./configure-debian-pkg.sh``
3. after the configuration, run "make deb" will build the debian package for current bundle


## Rules
1. sanji bundle will be placed under  
    ``/usr/lib/sanji<version>/``
2. do not install test files
3. both online & offline install is available (how to check online or offline)
    * online: ``pip install -r requirements.txt``
    * offline: ``pip install --no-index --find-links file:./packages -r requirements.txt``


## Notes
* all required python libraries will be downloaded for offline install  
   ``pip install -r requirement.txt --download ./packages``


## TODO
* verify the policy when python libraries need to be compiled  
   https://packaging.python.org/en/latest/installing.html
   1. cross compile
   2. install gcc
