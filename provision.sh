#!/bin/sh
cd vpn
deploy/vpn-existing-cloud-server.sh --ip-address `cat ../private_ip.txt` --ssh-user ubuntu --site-config ../inventory.yml
