# Desc: Dockerfile for jaseci-playground
FROM docker:stable-dind

# install nodejs
RUN apk add --update nodejs npm

#install pm2
RUN npm install pm2 -g

# create jaseci-playground directory
RUN mkdir /jaseci-playground

# copy jaseci-playground files to container
COPY . /jaseci-playground

# install jaseci-playground dependencies
RUN cd /jaseci-playground && npm install

# expose port 3000
EXPOSE 3000

# run sh run.sh
CMD ["sh", "jaseci-playground/run.sh"]
