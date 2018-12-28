FROM node:6.11-alpine

WORKDIR "/opt"

RUN apk add --update git make g++ && git clone https://gitlab.com/blockvalley/ethereum-blockchain-explorer.git 

WORKDIR "/opt/ethereum-blockchain-explorer"

RUN git checkout 9ec721cd6443f5119eba7294d7ca9bf4a8920563
RUN npm install

CMD npm run start

EXPOSE 8080
