#!/bin/bash

# --- Set your subnets ---
SUBNETS="<>,<>"

# --- Create EKS cluster using existing VPC ---
eksctl create cluster --name Pulkit-eks \
                      --region ap-south-1 \
                      --version 1.30 \
                      --without-nodegroup \
                      --vpc-private-subnets $SUBNETS \
