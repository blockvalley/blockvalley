FROM node:6.11-alpine

WORKDIR "/opt"

RUN apk add --update git make g++ && git clone https://gitlab.com/blockvalley/ethereum-blockchain-explorer.git 

WORKDIR "/opt/ethereum-blockchain-explorer"

RUN git checkout aa6e4e3b53a6c1ae3642ebc46ad7811ad9bd211a
RUN npm install

CMD npm run start

EXPOSE 8080
