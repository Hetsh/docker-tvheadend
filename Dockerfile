FROM hetsh/alpine:20260127-3
ARG LAST_UPGRADE="2026-03-15T21:43:04+01:00"
RUN apk upgrade --no-cache && \
	apk add --no-cache \
		tvheadend=4.3_git20260214-r1

# App user
ARG APP_USER="tvheadend"
ARG APP_UID=1359
ARG APP_GID=985
RUN sed -i "s|$APP_USER:x:[0-9]\+:[0-9]\+|$APP_USER:x:$APP_UID:$APP_GID|" /etc/passwd && \
	sed -i "s|video:x:[0-9]\+|video:x:$APP_GID|" /etc/group

# Volumes
ARG HOME_DIR="/usr/share/tvheadend"
ARG DATA_DIR="/tvheadend-data"
RUN mkdir "$HOME_DIR/.hts" && \
	ln -s "$DATA_DIR" "$HOME_DIR/.hts/tvheadend"

USER "$APP_USER"
WORKDIR "$DATA_DIR"
ENTRYPOINT ["tvheadend", "-C"]
