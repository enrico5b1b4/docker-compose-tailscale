FROM ubuntu:20.04

# Disable Prompt During Packages Installation
ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ="America/New_York"

RUN apt install -y libgnutls30
RUN apt update
RUN apt install -y \
    firefox \
    libavcodec-extra \
    tzdata \
    curl \
    vim \
    terminator

RUN groupadd -g 1000 user1
RUN useradd -d /home/user1 -s /bin/bash -m user1 -u 1000 -g 1000

USER user1

ENV HOME /home/user1
