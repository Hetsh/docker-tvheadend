# TV-Headend
Super small and simple tvheadend server.

## Running the server
```bash
docker run --detach --name tvheadend --publish 9981:9981 --publish 9982:9982 hetsh/tvheadend
```

## Stopping the container
```bash
docker stop tvheadend
```

## DVB cards
Linux mounts DVB devices at `/dev/dvb` and `/dev/dri`, they can be passed to the container with two simple parameters:
```bash
--device /dev/dvb --device /dev/dri
```

## Configuring
TVHeadend is configured via its [web interface](http://localhost:9981).
A configuration wizard will guide you through the initial setup if you run the server for the first time.
Remember to mount persistent storage if you want to keep the configuration.

## Creating persistent storage
```bash
DATA="/path/to/configuration"
mkdir -p "$DATA"
chown -R 1359:1359 "$DATA"
```
`1359` is the numerical id of the user running the server (see Dockerfile).
The user must have RW access to the configuration and recordings directory.
Start the server with the additional mount flags:
```bash
docker run --mount type=bind,source=/path/to/configuration,target=/tvheadend-data ...
```
Similarly, storage for recordings can be mounted. The path needs to be configured in TVHeadend beforehand:
```bash
docker run --mount type=bind,source=/path/to/recordings,target=/path/as/configured ...
```

## Automate startup and shutdown via systemd
The systemd unit can be found in my GitHub [repository](https://github.com/Hetsh/docker-tvheadend).
```bash
systemctl enable tvheadend --now
```
By default, the systemd service assumes `/apps/tvheadend` for configuration and `/etc/localtime` for timezone.
Since this is a personal systemd unit file, you might need to adjust some parameters to suit your setup.

## Fork Me!
This is an open project (visit [GitHub](https://github.com/Hetsh/docker-tvheadend)).
Please feel free to ask questions, file an issue or contribute to it.
