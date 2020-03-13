# docker-ansible-ec2 example

Run example Ansible-playbook to provision an AWS EC2 instance.

These instructions result in billable resources provisioned in your AWS account, see included role [provision](./roles/provision/tasks/main.yml) for details.

### 1. Create your SSH key

The playbook expects to find an SSH public key file [ `roles/provision/files/my-example-key.pub` ](./roles/provision/files/my-example-key.pub). Run `ssh-keygen -t rsa -b 4096` to create one.

### 2. Define credentials, prefered region and your VPC ID in [ `docker-compose.yml` ](./docker-compose.yml)

```
environment:
    - AWS_REGION=eu-central-1
    - AWS_ACCESS_KEY_ID=my_access_key_id
    - AWS_SECRET_ACCESS_KEY=my_secret_access_key
    - VPC_ID=vpc-abcd1234
```

### 3. Run Ansible playbook to provision an EC2 instance

```
docker-compose run ansible-ec2-example bash
```

In the container, run

```
ansible-playbook -i ec2.py webservers.yml
```

Wait until the playbook has finished.

If you `exec` into the container, and have issues with the playbook, get `pip` and `boto` by running `source scl_source enable rh-python36`.

### 4. Login to your new EC2 instance

Once the playbook has finished, see the ouput of the last task for `public_ip` or `public_dns_name` and connect.

```
# ssh -i roles/provision/files/my-example-key centos@<PUBLIC_DNS_NAME>
ssh -i roles/provision/files/my-example-key centos@ec2-3-122-118-86.eu-central-1.compute.amazonaws.com
```

### 5. Remember to clean up the example resources

Terminate `my-example-webserver` instance. Delete `my-example-sg` security group and `my-example-key` key pair. See playbook role [provision](./roles/provision/tasks/main.yml) for details.
