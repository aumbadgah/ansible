# docker-ansible-ec2

Ansible with dynamic AWS ec2 inventory and AWS CLI

## Usage

### Define your credentials and mount your playbook

`docker-compose.yml`

```
version: '3'
services:
  ansible-ec2-example:
    stdin_open: true
    tty: true
    command: bash
    volumes:
      - ./group_vars:/app/group_vars
      - ./roles:/app/roles
      - ./webservers.yml:/app/webservers.yml
    environment:
      - AWS_REGION=eu-central-1
      - AWS_ACCESS_KEY_ID=my_access_key_id
      - AWS_SECRET_ACCESS_KEY=my_secret_access_key
```

The Ansible ec2 inventory is available in `/app` directory.

### Run container

```
docker-compose run ansible-ec2-example bash
```

### Run your Ansible playbook

```
ansible-playbook -i ec2.py webservers.yml
```

If you `exec` into the container, and have issues with the playbook, get `pip` and `boto` by running `source scl_source enable rh-python36`.
