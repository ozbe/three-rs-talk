#!/bin/bash
#
# View WAR
#
# Dependencies
#   open
#   kubectl
#

SVC_IP=$(kubectl get svc company-news-tomcat -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
open "http://$SVC_IP/SampleWebApp/"