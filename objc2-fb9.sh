#!/bin/tcsh
echo "Written for csh."
 
 

echo "Switch to Clang. Ensure you're using 3.3 or above."
setenv CC clang
setenv CXX clang++
setenv CPP clang-cpp
 
 
echo "Prerequisites."
echo "I removed 'security/gnutls' package because I don't need it."
echo "But it's required if you want TLS support in GNUstep."
pkg_add -r portmaster
cd /usr/ports
portmaster --no-confirm -G textproc/libxslt devel/icu devel/libdispatch devel/libffi
 
 
 
echo "GNUstep(make:2.6.5, base:1.24.5) + libobjc2(1.7) on FreeBSD 9.2."
echo "Versions are specified explicitly to prevent future break."
cd ~/
mkdir t1
cd t1
pkg_add -r subversion gmake
svn co http://svn.gna.org/svn/gnustep/libs/libobjc2/releases/1.7 libobjc2-1.7 &
svn co http://svn.gna.org/svn/gnustep/tools/make/tags/make-2_6_5 make-2_6_5 &
svn co http://svn.gna.org/svn/gnustep/libs/base/tags/base-1_24_5 base-1_24_5 &
wait
 
cd make-2_6_5
./configure --enable-objc-nonfragile-abi
gmake install
cd ..
 
cd libobjc2-1.7
gmake install
cd ..
 
cd make-2_6_5
./configure --enable-objc-nonfragile-abi
gmake install
cd ..

echo "Now we need to set some path to GNUstep to use gnustep-make."
source /usr/GNUstep/System/Library/Makefiles/GNUstep.csh
 
cd base-1_24_5
echo "I don't know why this named in this way… but the switch
echo " --disable-unicodeconstants actually just force to use UTF-8."
echo "So no not worry about encoding."
./configure --enable-fake-main --disable-unicodeconstants --disable-tls
gmake install
cd ..
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
echo "Don't forget to add these lines to your login script to make sure"
echo "to use Clang for all further builds."
setenv CC clang
setenv CXX clang++
setenv CPP clang-cpp
source /usr/GNUstep/System/Library/Makefiles/GNUstep.csh
 
 
 
 
 
 
 
echo "Now you have working GNUstep installation."
echo "Let's write a test program."
 
cat << +END > main.m
#import <Foundation/Foundation.h>
@interface AAA : NSObject 
- (id)test;
@end
@implementation AAA
- (id)test{ return @"Test OK."; }
@end
int main(int c, char** v)
{
  @autoreleasepool
  {
    AAA* aaa = [[AAA alloc] init];
    NSLog(@"%@", [aaa test]);
    return 1;
  }
}
+END
cat main.m
 
rm -f ./a.out
set EE_GNUSTEP_LIB=/usr/local/GNUstep/System/Library
clang -I $EE_GNUSTEP_LIB/Headers -I /usr/local/include -L /usr/local/lib -l objc -L $EE_GNUSTEP_LIB/Libraries -l gnustep-base main.m
./a.out
 
rm -f ./a.out
clang -I /usr/local/include -L /usr/local/lib -l objc -l gnustep-base -fblocks *.m
./a.out
