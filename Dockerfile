# FROM node:23.3.0
FROM node:23.10.0-alpine

RUN adduser -D -s /bin/sh -g 'nodejs frontend user' appuser

WORKDIR /home/appuser/

USER appuser

WORKDIR /home/appuser/app

COPY --chown=appuser:appuser . . 

# RUN apt update && apt install -y net-tools iputils-ping

RUN npm install --omit=optional
# RUN npm audit fix --force

CMD [ "npm", "start"]

