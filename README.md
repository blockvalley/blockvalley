# Blockvalley
![](https://readthedocs.org/projects/blockvalley/badge/?version=latest&style=plastic)

Block Valley Consortium

Per a poder fer funcionar l'entorn serà necessari tenir instal·lat [docker](https://www.docker.com/)

## Imatges
S'han creat 3 imatges de docker diferents amb diferents proposits. Totes elles es poden trobar al [registry](https://hub.docker.com/u/blockvalley) oficial de Docker.

#### Bootnode
Unicament realitza funcions de porta d'accés.
Quan un node vol connectar-se a una xarxa és al primer punt on va a buscar a la resta de _peers_.

S'han muntat 2 bootnodes per tal de proveir l'accés a la xarxa (els nodes ja venen configurats amb aquesta informació):

```
enode://154c842207c5b487a29e7ed51be9073d95f7464d59b5473be8aedb164a8160c1ca86f8a1247afa159980423884019cef3b3c1073c10f608224bbd432d3792a85@194.158.92.150:30301
enode://e76b807b790a1aa6c1266890a585026a955ca5cb8f33ca105ba300a0be3dd77799fdea41b8c90908073e6f28de7d0a9b01f20c542e78236fd700d92b11dd530a@164.132.231.87:30301
```

```bash
# Properament instruccions per a poder montar-ne un.
```

#### Node
Manté una còpia del _ledger_ i verifica que totes les dades siguin correctes. A més a més, transmet totes les dades als _peers_ als quals roman connectat i permet interactuar amb la xarxa.

Aixecar un node i connectar-lo a la xarxa es pot fer de dues maneres diferents:

- Sense persistència de dades:
```bash
user@blockvalley:~$ docker run -it --rm -p 8545:8545 -p 30303:30303 --name=node blockvalley/node:enclar
```

- Amb persistència de dades:
```bash
user@blockvalley:~$ export NETWORK=enclar; sh scripts/init_node.sh <nom_del_volum>
user@blockvalley:~$ docker run -it --rm -p 8545:8545 -p 30303:30303 --mount type=volume,source=<nom_del_volum>,destination=/root/.ethereum --name=node blockvalley/node:enclar
```
> El volum de docker serveix per a persistir les dades  que genera i/o usa un container. Si no es crea un volum a part on guardar totes les dades, aquestes desapareixen amb el container.

#### Sealer
Fa totes les funcions anteriors i a més, té com a funció principal generar els nous blocs de la cadena.És l'encarregat de signar els nous blocs.

> El sealer de BTC Assessors té l'adreça: ```0x5ea1e4D01187347fF9b3BC672f4A628c9c75d007```

```bash
# Properament instruccions per a poder montar-ne un.
```

#### Explorer
Finalment es proporciona el Dockerfile per a poder generar un explorador per tal de tenir una forma visual d'accedir a les dades.

```bash
user@blockvalley:~$ docker build -f explorer/Dockerfile -t explorer .
user@blockvalley:~$ docker run -it --rm -p 8080:8080 explorer
```

Ja serà accessible a través de: http://localhost:8080.

___
Properament es proporcionaran la resta d'eines en aquest mateix lloc.

---
_Totes les proves s'han realitzat sobre Linux (Debian / Arch Linux / Raspbian) i Mac OS X._
