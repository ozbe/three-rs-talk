#!/bin/bash
#
# View myapp
#
# Dependencies
#   open
#   kubectl
#

SVC_IP=$(kubectl get svc myapp -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
open "http://$SVC_IP/"