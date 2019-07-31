#!/bin/bash

readonly ROLE="$1"

if [ -n "$ROLE" ]; then
    role_filter = "Name=tag:role,Values=${ROLE}"
fi

aws ec2 describe-instances \
        --filters "Name=tag:app,Values=swarm-cluster" \
                  $role_filter \
        --query "Reservations[*].Instances[*].PublicDnsName" \
        --output text
