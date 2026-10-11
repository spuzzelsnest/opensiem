# SIEM stack on Raspberry Pi (ARM64)

## 1. Wazuh (official single-node compose)
```
git clone https://github.com/wazuh/wazuh-docker.git -b v4.14.0   # use the latest release tag
cd wazuh-docker/single-node
docker compose -f generate-indexer-certs.yml run --rm generator
docker compose up -d
```
Dashboard: https://<pi-ip>:443

Before starting, on the host:
```
sudo sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" | sudo tee /etc/sysctl.d/99-wazuh.conf
```
Also lower the indexer heap in its compose file, e.g. `OPENSEARCH_JAVA_OPTS=-Xms1g -Xmx1g`.

To let Grafana reach the indexer, add the `siem` network to the Wazuh indexer service
(`networks: [default, siem]` plus an external `siem` network definition).

## 2. Grafana + Velociraptor (this folder)
```
cp .env.example .env   # fill in values
docker compose up -d --build
```
- Grafana: http://<pi-ip>:3000 -> add an OpenSearch datasource pointing at https://wazuh.indexer:9200 (index pattern `wazuh-alerts-*`, skip TLS verify or mount the root CA).
- Velociraptor GUI: https://<pi-ip>:8889 ; agents connect on 8000 using `client.config.yaml` from the velociraptor-data volume.
