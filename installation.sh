#!/bin/bash

#SWI
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:swi-prolog/stable
sudo apt-get update
sudo apt-get install swi-prolog

#sCASP
# install ciao Prolog
git clone https://github.com/ciao-lang/ciao
cd ciao
sudo ./ciao-boot.sh global-install
cd ..
rm -rf ciao
# install sCASP
sudo ciao get gitlab.software.imdea.org/ciao-lang/sCASP
