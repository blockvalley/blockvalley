FROM node:6.11-alpine

WORKDIR "/opt"

RUN apk add --update git make g++ && \
    git clone https://gitlab.com/blockvalley/ethereum-blockchain-explorer.git

WORKDIR "/opt/ethereum-blockchain-explorer"

RUN git checkout cef27fb10be40f69cc5ff423b34cc42b10cd6dd7
RUN npm install

CMD npm run start

EXPOSE 8080
