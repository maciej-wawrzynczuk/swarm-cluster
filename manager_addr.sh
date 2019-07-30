#!/bin/bash

aws ec2 describe-instances \
        --filters "Name=tag:app,Values=swarm-cluster" \
                  "Name=tag:role,Values=manager" \
        --query "Reservations[*].Instances[*].PublicDnsName" |
    jq -r '.[][]' |
    sed -e '/^$/d'
