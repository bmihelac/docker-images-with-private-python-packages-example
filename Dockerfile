# this is our first build stage, it will not persist in the final image
FROM python:3.6 as intermediate

# install git
RUN apt-get update
RUN apt-get install -y git

# add credentials on build
ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

# make sure your domain is accepted
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# copy requirements.txt
COPY requirements.txt /
# download packages
WORKDIR /pip-packages/
RUN pip download -r /requirements.txt

# create new image
FROM python:3.6
# copy downloaded packages
WORKDIR /pip-packages/
COPY --from=intermediate /pip-packages/ /pip-packages/
# install packages
RUN pip install --no-index --find-links=/pip-packages/ /pip-packages/*

WORKDIR /code/
