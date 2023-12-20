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

# install Scala
curl -fL https://github.com/coursier/coursier/releases/latest/download/cs-x86_64-pc-linux.gz | gzip -d > cs && chmod +x cs && ./cs setup
rm cs

# install sbt
echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | sudo tee /etc/apt/sources.list.d/sbt.list
echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | sudo tee /etc/apt/sources.list.d/sbt_old.list
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add
sudo apt-get update
sudo apt-get install sbt



# install Fusemate
cd systems/fusemate
./install.sh
cd ../..
