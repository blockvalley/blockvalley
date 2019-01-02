# Block Valley
[![Documentation](https://readthedocs.org/projects/blockvalley/badge/?version=latest&style=plastic)](https://blockvalley.rtfd.io)
[![](https://img.shields.io/docker/pulls/blockvalley/node.svg)](https://hub.docker.com/u/blockvalley)

**Block Valley** és un consorci promogut per empreses andorranes que treballen
amb tecnologia blockchain. L’objectiu del consorci és promoure la tecnologia
blockchain al país, creant xarxes permisionades en col·laboració de tots els
integrants del consorci, en benefici del país.

## Documentació
Per a més informació sobre les *blockchain* de **Block Valley**, visita la
nostra documentació:

https://blockvalley.rtfd.io

## Connecta't a la xarxa
Si tens instal·lat [Docker](https://www.docker.com/), pots executar un node i
connectar-te a la xarxa en un tres i no res.

> Les instruccions següents són per connectar-se a la xarxa de proves del
> consorci *Proof of Authority* d'*Ethereum*. 

```
docker run -p 30303:30303 -p 8545:8545 blockvalley/node:enclar
```

> És important tenir accesible públicament (tenir el port *obert*) `30303`,
> donat que els nodes de la xarxa l'usaran per connectar-se i poder transmetre
> informació.
>
> En cas que el node només disposi d'un bloc (el gènesis) de la *blockchain*,
> és possible que aquest sigui un dels factors per a que no es sincronitzi la
> *blockchain*

Per a més informació, podeu consultar el capítol d'[ús de la xarxa a la
documentació oficial](https://blockvalley.rtfd.io/ca/latest/ethereum/usage.html)
