# Ubuntu has the necessary framework to start from    
FROM centos/php-70-centos7:latest

# Run as root
USER root

# Create Distelli user
RUN useradd -ms /bin/bash distelli 

# Set /home/distelli as the working directory
WORKDIR /home/distelli
    
# Install prerequisites. This provides me with the essential tools for building with.
# Note. You don't need git or mercurial.
RUN yum -y update  \
    && yum -y groupinstall 'Development Tools' \
    && yum -y install git mercurial sudo dpkg \
    && yum -y install openssh-clients openssh-server \
    && yum -y install curl ca-certificates

# Update the .ssh/known_hosts file:
RUN sudo sh -c "ssh-keyscan -H github.com bitbucket.org >> /etc/ssh/ssh_known_hosts"

# Install Distelli CLI to coordinate the build in the container
RUN curl -sSL https://www.distelli.com/download/client | sh

# Install gosu
ENV GOSU_VERSION 1.9
RUN sudo curl -o /bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.9/gosu-$(dpkg --print-architecture)" \
     && sudo chmod +x /bin/gosu

# Install node version manager as distelli user
USER distelli
RUN cd /home/distelli && curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

# Install Composer as distelli user

# Ensure the final USER statement is "USER root"
USER root

CMD ["/bin/bash"]
