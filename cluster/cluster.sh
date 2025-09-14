#!/bin/bash

# --- Set your subnets ---
SUBNETS="subnet-00416eb02730bee7f,subnet-054ba5508ec2c9bac"

# --- Create EKS cluster using existing VPC ---
eksctl create cluster --name Pulkit-eks \
                      --region ap-south-1 \
                      --version 1.30 \
                      --without-nodegroup \
                      --vpc-private-subnets $SUBNETS \
