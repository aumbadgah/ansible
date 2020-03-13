#!/bin/bash

set -e

ansible --version
aws --version

exec "$@"
