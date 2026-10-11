#!/bin/sh
set -e
cd /data

if [ ! -f server.config.yaml ]; then
  echo "Generating Velociraptor server config..."
  velociraptor config generate > server.config.yaml
  # Make the GUI reachable from outside the container and point agents at our host.
  sed -i "s/bind_address: 127.0.0.1/bind_address: 0.0.0.0/" server.config.yaml
  sed -i "s#https://localhost:8000/#https://${VELOCIRAPTOR_HOSTNAME}:8000/#" server.config.yaml
  velociraptor --config server.config.yaml user add "${VELOCIRAPTOR_ADMIN_USER}" \
    "${VELOCIRAPTOR_ADMIN_PASSWORD}" --role administrator
  # Client config to deploy on endpoints
  velociraptor --config server.config.yaml config client > client.config.yaml
fi

exec velociraptor --config server.config.yaml frontend -v
