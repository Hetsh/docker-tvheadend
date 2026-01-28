# TV-Headend
Small and simple tvheadend server.

## Running the server
```bash
docker run --detach --name tvheadend --publish 9981:9981 --publish 9982:9982 hetsh/tvheadend
```

## Stopping the container
```bash
docker stop tvheadend
```

## Creating persistent storage
Create persistent storage on your host to avoid data loss:
```bash
DATA="/path/to/configuration"
mkdir -p "$DATA"
chown -R 1359:1359 "$DATA"
```
`1359` is the numerical id of the user running the server (see Dockerfile).
The user must have RW access to the configuration and recordings directory.
Start the server with these additional mount parameters:
```bash
docker run --mount type=bind,source=/path/to/configuration,target=/tvheadend-data ...
```
Similarly, storage for recordings can be mounted. The path needs to be configured in TVHeadend beforehand:
```bash
docker run --mount type=bind,source=/path/to/recordings,target=/path/as/configured ...
```

## DVB cards
Linux mounts DVB devices at `/dev/dvb` and `/dev/dri`, they can be passed to the container with two simple parameters:
```bash
docker --device /dev/dvb --device /dev/dri
```

## Configuring
TVHeadend is configured via its [web interface](http://localhost:9981).
A configuration wizard will guide you through the initial setup if you run the server for the first time.
Remember to mount persistent storage if you want to keep the configuration.
