SmartOS packages
=================

Selfmade SmartOS packages based on [joyent/release/2013Q3](https://github.com/joyent/pkgsrc/tree/joyent/release/2013Q3).


Install
-------

First read Jonathan Perkins article about "[pkgsrc on SmartOS - zone creation and basic builds](http://www.perkin.org.uk/posts/pkgsrc-on-smartos-zone-creation-and-basic-builds.html)".

`bash

# You can also use a different root.
buildroot=/content/pkgsrc/
mkdir -p $buildroot
cd $buildroot
git clone git://github.com/joyent/pkgsrc.git -b joyent/release/2013Q3

# Clone this repo
git clone git://github.com/neuhalje/smartos-packages_jn.git -b release/2013Q3
`


Build a package
--------------

CD into the directory of the package and 
`
sudo bmake install &&
sudo bmake package &&
sudo find /content/packages -type d -exec chmod o+rx \{\} \;  &&
sudo find /content/packages -type f -exec chmod o+rx \{\} \;`

The resulting package gets copied to `/content/packages` and can be put e.g. on a webserver.

Install with `pkg_add -v http://server/All/package.tgz`. 

Ressources
-----------
* http://www.perkin.org.uk/posts/creating-local-smartos-packages.html
* http://www.netbsd.org/docs/pkgsrc/
* https://github.com/joyent/pkgsrc
* http://atl.me/2013/pkgsrc-build-joyent
* http://wiki.smartos.org/display/DOC/Building+Packages
