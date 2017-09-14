#
# vim: set ft=dockerfile.sh:
# Base Docker image for Puppet Development
# 

FROM yarnhoj/dbox:latest
MAINTAINER John R. Ray <john@johnray.io>

# Add local vimrc stuff
COPY vimrc.local /home/dev/.vimrc.local
RUN chown dev:dev /home/dev/.vimrc.local

# Install Puppet Agent
#COPY puppet-agent_1.4.1-1jessie_amd64.deb /tmp/puppet-agent_1.4.1-1jessie_amd64.deb
#RUN dpkg -i /tmp/puppet-agent_1.4.1-1jessie_amd64.deb && rm /tmp/puppet-agent_1.4.1-1jessie_amd64.deb
RUN wget https://apt.puppetlabs.com/puppet5-release-jessie.deb && dpkg -i puppet5-release-jessie.deb && apt-get update && apt-get install -y puppet-agent

# Install Puppet Development Kit
COPY pdk_1.0.1.0-1trusty_amd64.deb /tmp/pdk_1.0.1.0-1trusty_amd64.deb
RUN dpkg -i /tmp/pdk_1.0.1.0-1trusty_amd64.deb && rm /tmp/pdk_1.0.1.0-1trusty_amd64.deb

# Install Hiera_Explain
# TODO Figure out how to install this alongside puppet
# RUN /opt/puppetlabs/puppet/bin/gem install hiera_explain puppet-lint --no-rdoc --no-ri

# Stop being root
USER dev
WORKDIR /home/dev
RUN echo "export PATH=/opt/puppetlabs/puppet/bin:$PATH" >> /home/dev/.bashrc

# Add Puppet Module Skeleton for puppet 3.x
RUN git clone https://github.com/garethr/puppet-module-skeleton && cd puppet-module-skeleton && find skeleton -type f \
  | git checkout-index --stdin --force --prefix="$HOME/.puppet/var/puppet-module/" --

# Add Puppet Module Skeleton for puppet 4.x
# RUN git clone https://github.com/garethr/puppet-module-skeleton && cd puppet-module-skeleton && find skeleton -type f \
#  | git checkout-index --stdin --force --prefix="$HOME/.puppet/var/puppet-module/" --

# Add git submodule
WORKDIR /home/dev/.vim
RUN git submodule add -f https://github.com/rodjek/vim-puppet.git ~/.vim/plugins/vim-puppet

# Set Sane Defaults
VOLUME /puppet
WORKDIR /puppet

CMD ["/bin/bash"]
