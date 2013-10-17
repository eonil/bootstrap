#!/bin/tcsh
echo "Written for tcsh."
echo "This script constructs Objective-C 2.0 environment on FreeBSD 9.2"
echo "Referenced from: http://brilliantobjc.blogspot.kr/2012/12/cocoa-on-freebsd.html"

 

echo "On FreeBSD 9, Clang is not yet default compiler."
echo "Switch to Clang. Ensure you're using 3.3 or above."
setenv CC clang
setenv CXX clang++
setenv CPP clang-cpp
 
 
echo "Prerequisites."
echo "On FreeBSD 9.2, portsnap cannot be executed in a script."
echo "Do it yourself manually if you didn't."
pkg_add -r gnutls
pkg_add -r portmaster
cd /usr/ports
portmaster --no-confirm -G textproc/libxslt devel/icu devel/libdispatch devel/libffi
 
 
echo "GNUstep(make:2.6.5, base:1.24.5 r37245) + libobjc2(1.7) on FreeBSD 9.2."
echo "Versions are specified explicitly to prevent future break."
echo "(GNUstep base r37245 has cricial bug fix, so should be included.)"
echo "Now downloading sources from SVN. This will take pretty long to"
echo "initiate, so please wait for a few minutes."
cd ~/
mkdir -p t1
cd t1
pkg_add -r subversion gmake
svn co http://svn.gna.org/svn/gnustep/libs/libobjc2/releases/1.7 libobjc2-1.7 &
svn co http://svn.gna.org/svn/gnustep/tools/make/tags/make-2_6_5 make-2_6_5 &
echo "svn co http://svn.gna.org/svn/gnustep/libs/base/tags/base-1_24_5 base-1_24_5 &"
svn co http://svn.gna.org/svn/gnustep/libs/base/trunk@37245 base-1_24_5-r37245 &
wait

echo "Build and install gnustep-make without libobjc2."
cd make-2_6_5
./configure --enable-objc-nonfragile-abi
gmake install
cd ..

echo "Build and install libobjc2."
cd libobjc2-1.7
gmake install
cd ..

echo "Rebuild and reinstall gnustep-make to use libobjc2."
cd make-2_6_5
./configure --enable-objc-nonfragile-abi
gmake install
cd ..



echo "Now we need to set some path to GNUstep to use gnustep-make."
echo "source /usr/GNUstep/System/Library/Makefiles/GNUstep.csh"
 
cd base-1_24_5-r37245
echo "I don't know why this named in this way… but the switch"
echo " --disable-unicodeconstants actually just force to use UTF-8."
echo "So no not worry about encoding."
./configure --enable-fake-main --disable-unicodeconstants
gmake install
cd ..
 
 
 
 
 
 
 
 
 
 
 
 
 
 

 
 















echo "Now you have working GNUstep installation."
echo "Let's write a test program."

cat << +END > main.m
#import <Foundation/Foundation.h>
@interface AAA : NSObject
- (id)test;
@end
@implementation AAA
- (id)test
{
    return @"Test OK.";
}
- (void)dealloc
{
    NSLog (@"ARC dealloc!");
}
@end
int main(int c, char** v)
{
    @autoreleasepool
    {
        void (^block1)(int) = ^(int num)
        {
            AAA* aaa = [[AAA alloc] init];
            NSLog(@"%@, %@", [aaa test], @(num));
        };
        block1(1343);
        return 0;
    }
}
+END
cat main.m

rm -f ./a.out
clang -I/usr/local/include -L/usr/local/lib -lobjc -lgnustep-base -fblocks -fobjc-arc -fobjc-abi-version=3 *.m
./a.out



