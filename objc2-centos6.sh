#!/bin/bash
echo "This script is written for bash."
echo "Construction of Objective-C environment on CentOS 6.x."

# GOAL
# C-blocks(working), ARC(working), libdispatch(unknown), gnustep-base(working), clang libc++(fail)

# KNWON ISSUES
# libffi - Cannot find current version's devel version. Uses old devel package. Required for GNUstep make/base.
# libc++ - I haven't tried to install Clang's libc++.
# libdispatch - Not tried yet. Actually I don't know which port is stable and usable.
# Is this required - "source /usr/GNUstep/System/Library/Makefiles/GNUstep.csh"

echo "Platform Specific Prerequisites: CentOS 6"
echo "Install dependencies using prebuilt-packages to save time."
GCC_DEV_PKGS="gcc gcc-c++ make glibc-devel"
GNUSTEP_DEP_PKGS="libicu libicu-devel libxslt libxslt-devel libxml2 libxml2-devel gnutls gnutls-devel libffi libffi-devel"
LLVM_BUILD_DEP_PKGS="svn perl"
yum install -y $GCC_DEV_PKGS $GNUSTEP_DEP_PKGS $LLVM_BUILD_DEP_PKGS









cd ~/
mkdir t1
cd t1
curl -O http://llvm.org/releases/3.3/cfe-3.3.src.tar.gz &
curl -O http://llvm.org/releases/3.3/llvm-3.3.src.tar.gz &
curl -O http://llvm.org/releases/3.3/compiler-rt-3.3.src.tar.gz &
curl -O http://llvm.org/releases/3.3/clang-tools-extra-3.3.src.tar.gz &
curl -O http://llvm.org/releases/3.3/libcxx-3.3.src.tar.gz &
curl -O http://llvm.org/releases/3.3/lldb-3.3.src.tar.gz &

wait
echo "Downloading done."

tar zxvf cfe-3.3.src.tar.gz
tar zxvf llvm-3.3.src.tar.gz
tar zxvf compiler-rt-3.3.src.tar.gz
tar zxvf clang-tools-extra-3.3.src.tar.gz
tar zxvf libcxx-3.3.src.tar.gz
tar zxvf lldb-3.3.src.tar.gz

mv llvm-3.3.src llvm
mv cfe-3.3.src llvm/tools/clang
mv clang-tools-extra-3.3.src llvm/tools/clang/extra
mv compiler-rt-3.3.src llvm/projects/compiler-rt

cd llvm
./configure
make install

cat << +END >> /etc/ld.so.conf
/usr/local/lib64
/usr/local/lib
+END
ldconfig

echo "LLVM+Clang 3.3 build & installation done."


















echo "Now start using clang."

export PATH=/usr/local/bin:$PATH
export CC=clang
export CXX=clang++
export CPP="clang -E"
export gmake="make"

cd ~/
cd t1
curl -LO https://github.com/atgreen/libffi/archive/v3.0.13.tar.gz
tar xvf v3.0.13.tar.gz
cd libffi-3.0.13
./configure
make install






cd ~/
cd t1
echo "GNUstep(make:2.6.5, base:1.24.5) + libobjc2(1.7) on FreeBSD 9.2."
echo "Versions are specified explicitly to prevent future break."
echo "Now downloading sources from SVN. This will take pretty long to"
echo "initiate, so please wait for a few minutes."
svn co http://svn.gna.org/svn/gnustep/libs/libobjc2/releases/1.7 libobjc2-1.7 &
svn co http://svn.gna.org/svn/gnustep/tools/make/tags/make-2_6_5 make-2_6_5 &
svn co http://svn.gna.org/svn/gnustep/libs/base/tags/base-1_24_5 base-1_24_5 &
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

echo "Rebuild and reinstall gnustep-make using libobjc2."
cd make-2_6_5
./configure --enable-objc-nonfragile-abi
gmake install
cd ..



cd base-1_24_5
echo "I don't know why this named in this way… but the switch"
echo " --disable-unicodeconstants actually just force to use UTF-8."
echo "So no not worry about encoding."
./configure --enable-fake-main --disable-unicodeconstants --disable-tls
gmake install
cd ..




echo "This must be performed all other libraries are installed."
echo "Maybe there's some issues on cache."
ldconfig

cat << +END | cat
Unlike FreeBSD, Clang cannot be system default compiler
on Linux currently. But you can set user-default compiler.
So don't forget to add this code path for each users.

    export PATH=/usr/local/bin:$PATH
    export CC=clang
    export CXX=clang++
    export CPP="clang -E"
    export gmake="make"

+END








































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






