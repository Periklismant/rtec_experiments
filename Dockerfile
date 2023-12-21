FROM ubuntu:22.04
WORKDIR /experiments
COPY . .
# Setup aptitude
RUN apt-get -y update
# Install General
RUN apt-get -y install build-essential
RUN apt-get -y install apt-utils
RUN apt-get -y install curl
RUN apt-get -y install wget
RUN apt-get -y install libasound2
RUN apt-get -y install libxi6
RUN apt-get -y install libxtst6
#RUN apt-get -y install emacs
# Install SWI Prolog
RUN apt-get -y install software-properties-common 
RUN apt-add-repository ppa:swi-prolog/stable 
RUN apt-get -y update 
RUN apt-get -y install swi-prolog 
# Install Git
RUN apt-get -y install git 
# Install Ciao
RUN git clone https://github.com/ciao-lang/ciao 
RUN cd ciao \
    && ./ciao-boot.sh global-install \
    && ./ciao-boot.sh get devenv || return 0
RUN rm -rf ciao
# Install sCASP
RUN ciao get gitlab.software.imdea.org/ciao-lang/sCASP
# Install Oracle JDK 18
RUN apt-get -y update
RUN apt-get install -y libc6-x32 libc6-i386
RUN wget https://download.oracle.com/java/18/archive/jdk-18.0.2.1_linux-x64_bin.deb
RUN dpkg -i jdk-18.0.2.1_linux-x64_bin.deb
RUN rm jdk-18.0.2.1_linux-x64_bin.deb
RUN export JAVA_HOME=/usr/lib/jvm/jdk-18
RUN export PATH=\$PATH:\$JAVA_HOME/bin
RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-18/bin/java 1
# Install Scala
RUN sh -c "$(curl -fL https://github.com/coursier/coursier/releases/latest/download/cs-x86_64-pc-linux.gz | gzip -d > cs && chmod +x cs && ./cs setup)" -y -f
RUN rm cs
# Install sbt
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add
RUN apt-get -y update
RUN apt-get -y install sbt
# Install Fusemate 
RUN cd systems/fusemate \
   && ./install.sh
# Install Ticker
RUN cd systems/ticker \
   && sbt assembly
# Install BigQuery
RUN apt-get -y update
RUN apt-get -y install apt-transport-https ca-certificates gnupg 
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && apt-get update -y && apt-get install google-cloud-sdk -y
# Install Logica 
RUN apt-get -y update
RUN apt-get install -y python3
RUN apt-get install -y python3-pip
RUN python3 -m pip install logica

EXPOSE 3000

CMD ["/bin/bash"]
