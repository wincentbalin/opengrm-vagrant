FROM ubuntu:18.04
# Update packages
RUN apt-get update
# Install installation utilities
RUN apt-get install -y apt-utils
# Install utilities
RUN apt-get install -y tmux vim mc
# Install OpenFST compilation requirements
RUN apt-get install -y build-essential make zlib1g-dev python-dev libreadline6-dev libncurses5-dev
# Install Pynini prerequisites
RUN apt-get install -y python-setuptools libre2-dev
# Install everything OpenFST and OpenGRM
RUN apt-get install -y wget
COPY install-opengrm.sh .
RUN ./install-opengrm.sh
