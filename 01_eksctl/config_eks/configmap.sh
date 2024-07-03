#!/bin/bash

kubectl edit -n kube-system configmap/aws-auth

mapUsers: |
    - userarn: arn:aws:iam::123456789012:user/user-eks
      username: user-eks
      groups:
        - system:masters
