FROM ruby:2.4-alpine
LABEL maintainer="Mike Glenn <mike.glenn@rammount.com>"

RUN \
	apk --no-cache add build-base bash freetds-dev git nodejs openssh-client && \
	rm -rf /var/cache/apk/*

ENV HOME=/root
ENV GEM_HOME /gems
ENV RAILS_ENV=development

RUN \
	mkdir -p $HOME && \
  mkdir -p $GEM_HOME && \
  mkdir -p $HOME/.ssh && \
  ssh-keyscan -H github.com >> $HOME/.ssh/known_hosts && \
  ssh-keyscan -H bitbucket.org >> $HOME/.ssh/known_hosts && \
  echo "alias l='ls -lha'" >> ~/.bashrc && \
  echo "alias ll='ls -lha'" >> ~/.bashrc && \
  echo "alias la='ls -A'" >> ~/.bashrc && \
  echo "alias cls='clear && printf '\''\e[3J'\'''" >> ~/.bashrc && \
  echo "alias berlc='bundle exec rake log:clear'" >> ~/.bashrc && \
  echo "alias devrc='bundle exec rails c'" >> ~/.bashrc 

#COPY config/containers/keys/id_rsa $HOME/.ssh/

#RUN chmod -R 600 $HOME/.ssh

WORKDIR /app

ENV PATH $GEM_HOME/bin:$PATH
# Point Bundler at /gems. This will cause Bundler to re-use gems that have already been installed on the gems volume
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_HOME $GEM_HOME
ENV BUNDLE_BIN $GEM_HOME/bin

# Increase how many threads Bundler uses when installing. Optional!
ENV BUNDLE_JOBS 4

# How many times Bundler will retry a gem download. Optional!
ENV BUNDLE_RETRY 3

EXPOSE 3000

#COPY config/containers/web/docker-entrypoint.sh /usr/local/bin/
#RUN chmod +x /usr/local/bin/docker-entrypoint.sh
CMD ["./start.sh"]
