FROM dockerhub.paypalcorp.com/cloud/ansible/ubuntu-16.04:builder

MAINTAINER Alan Janis <alan.janis@gmail.com>

ENV ANSIBLE_GATHERING="smart"
ENV ANSIBLE_RETRY_FILES_ENABLED="false"
ENV ANSIBLE_ROLES_PATH="/ansible/roles"
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_SSH_PIPELINING True
RUN  DEBIAN_FRONTEND=noninteractive  apt-get update
RUN apt-get install -y openssl ca-certificates
WORKDIR  /tmp/ansible

RUN echo "===> Copying ansible files..."
COPY  . /tmp/ansible

ARG ansible_playbook
ARG ansible_inventory
ARG ansible_vault

RUN ansible localhost --vault-id $ansible_vault -c local -i $ansible_inventory -m setup

RUN ansible-playbook -vvv -i $ansible_inventory --connection=local $ansible_playbook --vault-id $ansible_vault


RUN apt -y purge \
	build-essential \
	python-dev \
	ansible \
	python3.5 \
	python3.5 \
	libpython3.5 \
	python3-minimal \
	python3.5-minimal \
	git-core \
	git \
	gcc \
	gcc-5 \
	net-tools 

RUN apt -y autoremove
RUN rm -rf /tmp/ansible /root/.cache /root/.ansible /srv/* /var/lib/apt/lists/*
WORKDIR /root/


# docker build --build-arg ansible_playbook=playbook.yml ansible_inventory=inventory_file ansible_vault=vaultid -f ansible_build.Dockerfile .

