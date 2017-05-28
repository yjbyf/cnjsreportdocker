FROM ubuntu:yakkety
MAINTAINER Jan Blaha
EXPOSE 5488

RUN apt-get update && apt-get install -y curl sudo && \
    curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && \
    apt-get install -y nodejs libgtk2.0-dev libxtst-dev libxss1 libgconf2-dev libnss3-dev libasound2-dev xvfb xfonts-75dpi xfonts-base && \
    apt-get install -y build-essential chrpath git-core libssl-dev libfontconfig1-dev && \
    apt-get install -y language-pack-zh* && \
    apt-get install -y chinese* && \
    apt-get install -y fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core && \
    apt-get install -y fonts-arphic-bkai00mp fonts-arphic-bsmi00lp fonts-arphic-gbsn00lp fonts-arphic-gkai00mp fonts-arphic-ukai fonts-arphic-uming fonts-cns11643-kai fonts-cns11643-sung fonts-cwtex-fs fonts-cwtex-heib fonts-cwtex-kai fonts-cwtex-ming fonts-cwtex-yen && \
    apt-get install -y fonts-wqy-zenhei

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

RUN adduser --disabled-password --gecos "" jsreport
RUN echo "jsreport ALL=(root) NOPASSWD: /usr/local/bin/node" >> /etc/sudoers
RUN echo "jsreport ALL=(root) NOPASSWD: /usr/local/bin/npm" >> /etc/sudoers

VOLUME ["/jsreport"]

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN pwd
RUN ls -al
#RUN sudo npm install jsreport --production
RUN sudo yarn add jsreport --production
#RUN yarn config set registry https://registry.npm.taobao.org
#RUN npm config set registry https://registry.npm.taobao.org

RUN ls -al
RUN sudo node node_modules/jsreport --init

#RUN sudo npm install --production --save --save-exact jsreport-ejs jsreport-jade jsreport-freeze jsreport-phantom-image \
RUN sudo yarn add --production --save --save-exact jsreport-ejs jsreport-jade jsreport-freeze jsreport-phantom-image \
    jsreport-mssql-store jsreport-postgres-store jsreport-mongodb-store jsreport-wkhtmltopdf \
    electron jsreport-electron-pdf

ADD run.sh /usr/src/app/run.sh
COPY . /usr/src/app

ENV NODE_ENV production
ENV electron:strategy electron-ipc
ENV phantom:strategy phantom-server
ENV tasks:strategy http-server

CMD ["bash", "/usr/src/app/run.sh"]
