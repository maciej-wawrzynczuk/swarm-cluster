#!/bin/bash

readonly ROLE="$1"

filters[0]="Name=tag:app,Values=swarm-cluster"

if [ -n "$ROLE" ]; then
    filters[1]="Name=tag:role,Values=${ROLE}"
fi

aws ec2 describe-instances \
        --filters "${filters[@]}" \
        --query "Reservations[*].Instances[*].PublicDnsName" \
        --output text
