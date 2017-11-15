FROM node:4
LABEL authors="Cecile Tonglet <cecile.tonglet@tenforce.com"

RUN npm -q set progress=false
RUN npm install -q -g bower

RUN mkdir /app
WORKDIR /app

ADD package.json /app/
RUN npm install -q

ADD bower.json /app/
RUN bower --allow-root install

ENV PATH=/app/node_modules/ember-cli/bin:$PATH

ADD . /app/
# RUN ember build --prod >/dev/null

CMD sh -c "npm install -q && ember build --prod"
