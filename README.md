Work Environment Bootstrapper
=============================
Hoon H. 2013/10/17

This is a collection of initial configuration script.

- `objc2-fb9.sh`

  This script constructs Objective-C 2.0 environment on FreeBSD 9.2 using these components.
  To run this script, type this on command-line. You should have ports tree and `curl` before installing.
  
        setenv BATCH yes
        portsnap fetch extract update
        cd /usr/ports/ftp/curl
        make install clean BATCH=yes
        
        curl https://raw.github.com/eonil/bootstrap/master/objc2-fb9.sh | tcsh

  - libobjc2 1.7
  - gnustep-base 1.24.5 (r37245, for NSFileHandle bug fix)
  - clang 3.3.

  This contains these important features.
  
  - C-blocks
  - GCD
  - ARC
  - Declared properties
  -	Objective-C literals
  
  This script installs gnustep-base only. No support for GUI or existing Web framework.
  Because I don't need them now.

  If you want support for them investigate this [Johannes Lundberg's site](http://brilliantobjc.blogspot.kr/2012/12/cocoa-on-freebsd.html)
  which has original script that I mostly copied from.

- `objc2-centos6.sh`

  Experimental build script for CentOS 6.
  
  
  
