# Common setup for FreeBSD 9.

# First, let's reduce boot menu time.
# I don't want' to remove beastie because that's awesome!
cat << +END >> /boot/loader.conf
autoboot_delay="1"
+END

# Second, let package manager to use mirror site for speed up.
# http://www.cyberciti.biz/tips/freebsd-changing-pkg_add-package-ftp-site-location.html
# Never use Korean site. They have shitty speed.
# Use Japanese site.
# List of recommended sites:
# -    ftp://ftp1.jp.FreeBSD.org/pub/FreeBSD/
# List of bad sites:
# -    ftp://ftp.tw.FreeBSD.org/pub/FreeBSD/ (many packages are missing)
setenv PACKAGEROOT ftp://ftp1.jp.FreeBSD.org
cat << +END >> ~/.cshrc

setenv PACKAGEROOT ftp://ftp1.jp.FreeBSD.org
+END








# New system "pkg" is currently offline.
# https://wiki.freebsd.org/pkgng#Availability_of_binary_pkgs_for_Download
# And won't be ready until FreeBSD 10 goes up. Empty repository until then.
# So stick to "pkg_add" until "pkg" is completely up.
pkg_add -r rsync curl git zsh



