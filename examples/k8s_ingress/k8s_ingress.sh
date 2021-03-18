#!/bin/bash
#
# View myapp
#
# Inputs
#   $1 - service
#
# Dependencies
#   open
#   kubectl
#

SVC=$1

SVC_IP=$(kubectl get svc $SVC -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
open "http://$SVC_IP/"