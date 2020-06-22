FROM centos:8

ENV LANG en_US.utf8

RUN dnf install -y epel-release \
    && dnf install -y \
        which \
        make \
        gcc \
        clang \
        swig \
        python36-devel \
        python36 \
        nss-devel \
        msgpack-devel \
    && dnf clean all

# set a default python binary and install scons
RUN alternatives --set python /usr/bin/python3
RUN pip3 install --upgrade pip && pip3 install scons

# symbolically link to name without version suffix for libprio
RUN ln -s /usr/include/nspr4 /usr/include/nspr \
    && ln -s /usr/include/nss3 /usr/include/nss

WORKDIR /app
ADD . /app

RUN scons VERBOSE=1

CMD echo "starting ptest" && time build/ptest/ptest -vv