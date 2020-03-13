FROM centos:7

RUN yum -y update \
    && yum -y upgrade \
    && yum install -y \
    epel-release \
    centos-release-scl \
    && yum install -y \
    ansible \
    openssh-clients \
    openssh-server \
    rh-python36 \
    unzip \
    vim \
    && yum autoremove -y

WORKDIR /tmp
RUN curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install

COPY ./bin/container-entrypoint.sh /usr/local/bin

WORKDIR /app
RUN curl \
    -o ec2.py \
    https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py
RUN chmod +x \
    /app/ec2.py
RUN curl \
    -o ec2.ini \
    https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.ini

ENV ANSIBLE_HOSTS=/app/ec2.py
ENV EC2_INI_PATH=/app/ec2.ini
SHELL ["/bin/bash", "-c"]
RUN source scl_source enable rh-python36 \
    && pip3 install \
    --upgrade \
    pip \
    ansible \
    boto \
    boto3 \
    botocore \
    && rm -f /usr/bin/python \
    && rm -f /usr/bin/python3 \
    && ln -s /opt/rh/rh-python36/root/usr/bin/python3 /usr/bin/python \
    && ln -s /opt/rh/rh-python36/root/usr/bin/python3 /usr/bin/python3 \
    && echo "[defaults]" >> ~/.ansible.cfg \
    && echo "host_key_checking = False" >> ~/.ansible.cfg
RUN echo "source scl_source enable rh-python36" >> /root/.bashrc

ENTRYPOINT [ "container-entrypoint.sh" ]
CMD [ "bash" ]
