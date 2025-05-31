# ai-workspace

```shell
   ./scripts/compose.sh
```

```shell
   docker exec n8n-web n8n import:credentials --input=/data/provision/credentials.json
#    docker exec n8n-web n8n import:workflows --input=/data/provision/workflows
```


### Export things

```shell
docker exec n8n-web n8n export:credentials --backup --output=/data/credentials
```