#!/bin/bash
sudo bmake clean &&
sudo bmake stage-install &&
sudo bmake print-PLIST >PLIST &&
sudo bmake install &&
sudo bmake package &&
sudo find /content/packages -type d -exec chmod o+rx \{\} \;  &&
sudo find /content/packages -type f -exec chmod o+rx \{\} \;
