VERSION 0.7

all:
    FROM ruby:alpine
    RUN wget -q -t3 'https://packages.doppler.com/public/cli/rsa.8004D9FF50437357.key' -O /etc/apk/keys/cli@doppler-8004D9FF50437357.rsa.pub && \
        echo 'https://packages.doppler.com/public/cli/alpine/any-version/main' | tee -a /etc/apk/repositories && \
        apk add --no-progress --update curl docker docker-cli-buildx doppler git nodejs npm openssh
    ENV PATH=$PATH:/root/.pulumi/bin
    RUN mkdir /app
    WORKDIR /app
    RUN apk update && apk add --virtual build-dependencies build-base
    RUN curl -fsSL https://get.pulumi.com/ | sh;
    RUN gem install mrsk
    RUN mkdir ~/.ssh
    RUN --secret DOPPLER_TOKEN doppler secrets get SSH_PRIVATE --plain > ~/.ssh/id_rsa
    RUN --secret DOPPLER_TOKEN doppler secrets get SSH_PUBLIC --plain > ~/.ssh/id_rsa.pub
    RUN chmod 600 ~/.ssh/id_rsa
    COPY . .
    WORKDIR /app/deployment
    RUN npm install
    RUN  --secret DOPPLER_TOKEN doppler run -- pulumi stack select the-vinner/prod/prod
    RUN  --secret DOPPLER_TOKEN doppler run -- pulumi up --yes
    RUN --secret DOPPLER_TOKEN doppler secrets upload secrets.json
    WORKDIR /app
    RUN --secret DOPPLER_TOKEN doppler secrets download --no-file --format env > .env
    RUN --secret DOPPLER_TOKEN echo "DOPPLER_TOKEN=$DOPPLER_TOKEN" >> .env
    RUN --secret DOPPLER_TOKEN doppler run -- mrsk setup
