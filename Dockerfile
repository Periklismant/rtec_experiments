FROM ubuntu:22.04
WORKDIR /experiments
COPY . .
# Setup aptitude
RUN apt-get -y update
# Install GCC compiler
RUN apt -y install build-essential
# Install SWI Prolog
RUN apt-get -y install software-properties-common 
RUN apt-add-repository ppa:swi-prolog/stable 
RUN apt-get -y update 
RUN apt-get -y install swi-prolog 
# Install Git
RUN apt -y install git 
# Install Ciao
RUN git clone https://github.com/ciao-lang/ciao 
RUN cd ciao \
    && ./ciao-boot.sh global-install 
RUN rm -rf ciao
# Install 

EXPOSE 3000

CMD ["-i", "swipl"]
