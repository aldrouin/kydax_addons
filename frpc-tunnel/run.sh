#!/usr/bin/with-contenv bashio
# Render frpc.toml from the add-on options and run frpc in the foreground.
set -e

SERVER_ADDR=$(bashio::config 'server_addr')
SERVER_PORT=$(bashio::config 'server_port')
USER=$(bashio::config 'user')
TOKEN=$(bashio::config 'token')
SUBDOMAIN=$(bashio::config 'subdomain')
LOCAL_HOST=$(bashio::config 'local_host')
LOCAL_PORT=$(bashio::config 'local_port')
USE_WSS=$(bashio::config 'use_wss')

if bashio::var.is_empty "${SERVER_ADDR}" || bashio::var.is_empty "${TOKEN}" \
   || bashio::var.is_empty "${SUBDOMAIN}" || bashio::var.is_empty "${USER}"; then
  bashio::exit.nok "server_addr, user, token and subdomain are required — copy them from the portal."
fi

CONFIG=/tmp/frpc.toml
{
  echo "serverAddr = \"${SERVER_ADDR}\""
  echo "serverPort = ${SERVER_PORT}"
  echo "user = \"${USER}\""
  echo "metadatas.token = \"${TOKEN}\""
  echo "loginFailExit = false"
  echo "transport.tls.enable = true"
  if bashio::var.true "${USE_WSS}"; then
    # ride outbound 443 for egress-restricted venues (portal must front frps on 443)
    echo "transport.protocol = \"wss\""
  fi
  echo ""
  echo "[[proxies]]"
  echo "name = \"ha\""
  echo "type = \"http\""
  echo "subdomain = \"${SUBDOMAIN}\""
  echo "localIP = \"${LOCAL_HOST}\""
  echo "localPort = ${LOCAL_PORT}"
} > "${CONFIG}"

bashio::log.info "Kydax Tunnel: connecting to ${SERVER_ADDR}:${SERVER_PORT} as ${SUBDOMAIN}"
exec frpc -c "${CONFIG}"
