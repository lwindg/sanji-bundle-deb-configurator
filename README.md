# sanji-bundle-deb-configurator
A Debian package configurator for sanji bundles

## Rules
1. location
    ``/usr/lib/sanji<version>/``
2. do not install test files
3. both online & offline install is available
    * online: ``pip install -r requirements.txt``
    * offline: ``pip install --no-index --find-links file:./packages -r requirements.txt``
   (how to check online or offline)


## Notes
* all required python libraries will be downloaded for offline install
   ``pip install -r requirement.txt --download ./packages``


## TODO
* verify the policy when python libraries need to be compiled
   https://packaging.python.org/en/latest/installing.html
   1. cross compile
   2. install gcc
