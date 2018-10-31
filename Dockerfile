# Ubuntu has the necessary framework to start from    
FROM amazonlinux:2018.03

# Run as root
USER root

# Install prerequisites. This provides me with the essential tools for building with.
# Note. You don't need git or mercurial.
RUN yum -y update
RUN yum -y groupinstall 'Development Tools' \
    && yum -y install git mercurial sudo nodejs nodejs-devel http-parser shadow-utils \
    && yum -y install openssh-clients openssh-server curl ca-certificates \
    && yum -y install php71 php71-cli php71-gd php71-mbstring php71-intl php71-pecl-imagick php71-xml php71-common php71-pdo php71-mysqlnd php71-ldap php71-mcrypt php71-enchant php71-soap php71-fpm php71-json php71-process php71-dba php71-pecl-igbinary php71-bcmath

 
# Create Distelli user
RUN /usr/sbin/useradd -ms /bin/bash distelli 

# Set /home/distelli as the working directory
WORKDIR /home/distelli
    
# Update the .ssh/known_hosts file:
RUN sudo sh -c "ssh-keyscan -H github.com bitbucket.org >> /etc/ssh/ssh_known_hosts"

# Install Distelli CLI to coordinate the build in the container
RUN curl -sSL https://pipelines.puppet.com/download/client | sh

# Install gosu
ENV GOSU_VERSION 1.11
RUN sudo curl -o /bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64" \
     && sudo chmod +x /bin/gosu

# Install node version manager as distelli user
USER distelli
RUN mkdir /home/distelli/.nvm
RUN touch /home/distelli/.bash_profile
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | PROFILE=/home/distelli/.bash_profile NVM_DIR=/home/distelli/.nvm bash

# Ensure the final USER statement is "USER root"
USER root
RUN userdel distelli

CMD ["/bin/bash"]
