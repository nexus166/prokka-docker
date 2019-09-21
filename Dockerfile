FROM	debian:buster-slim
SHELL	["/bin/bash", "-xeuo", "pipefail", "-c"]

ARG     UID=1000
ARG     GID=1000
ARG     NAME="prokka"

RUN	groupadd --gid ${GID} ${NAME}; \
	useradd --create-home --system --shell /sbin/nologin --gid "${GID}" --uid "${UID}" "${NAME}"; \
	export DEBIAN_FRONTEND=noninteractive; \
	apt-get update; \
	apt-get dist-upgrade -y; \
	apt-get install -y bioperl build-essential default-jre git libdatetime-perl libdigest-md5-perl libxml-simple-perl sudo

RUN	git clone https://github.com/tseemann/prokka.git /usr/local/prokka; \
	/usr/local/prokka/bin/prokka --setupdb; \
	usermod -aG med "${NAME}"; \
	apt-get clean; \
	apt-get autoclean; \
	echo "$NAME ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers

ENV	PATH="${PATH}:/usr/local/prokka/bin"

USER	"${NAME}"
