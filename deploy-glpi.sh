#!/bin/sh
# Deploie MariaDB, GLPI et Nginx dans l'ordre, en attendant que chaque pod soit pret.
# Prerequis : le Secret mariadb-secret existe et l'image localhost/glpi-fpm:11.0.7 est importee dans containerd.
set -e
cd "$(dirname "$0")"

kubectl get secret mariadb-secret >/dev/null
echo "== MariaDB"
kubectl apply -f 10-mariadb.yaml
kubectl rollout status deploy/mariadb --timeout=300s
echo "== GLPI"
kubectl apply -f 20-glpi.yaml
kubectl rollout status deploy/glpi --timeout=300s
echo "== Nginx"
kubectl apply -f 30-nginx.yaml
kubectl rollout status deploy/nginx --timeout=300s
echo
kubectl get pods -o wide
kubectl get svc
echo
echo "GLPI : http://$(hostname -I | awk '{print $1}'):30080"
