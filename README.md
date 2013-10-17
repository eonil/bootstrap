Bootstrap
=========

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
  - gnustep-base 1.24.5
  - clang 3.3.
  
  This contains these features.
  
  - C-blocks
  - ARC
  - Declared properties
  - GCD
  
  This script lacks support for these features.

  - GNUstep GUI
  - GNUstep SSL/TLS
  - GNUstep Web framework

  This is because I don't need them now. 
  If you want support for them investigate this site which has original script I referenced from.
  [http://brilliantobjc.blogspot.kr/2012/12/cocoa-on-freebsd.html](http://brilliantobjc.blogspot.kr/2012/12/cocoa-on-freebsd.html)

