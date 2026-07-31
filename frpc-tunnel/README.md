# Kydax Tunnel (frpc-tunnel)

Home Assistant add-on that opens an **outbound** tunnel to the Kydax
remote-access portal ("the brain"). The portal can then reach this Home
Assistant, and you open its full UI from `https://<venue>.ha.<domain>`.
**No ports are opened on the venue network** — frpc only dials out.

## Install

1. Settings → Add-ons → Add-on Store → ⋮ → Repositories → add
   `https://github.com/aldrouin/kydax_addons`.
2. Install **Kydax Tunnel**.
3. In the portal (Administration → new venue) copy the generated settings
   into the add-on **Configuration**:
   - `server_addr` — the brain's address (e.g. `ha.example.com`)
   - `server_port` — usually `7000`
   - `user` — the venue id from the portal
   - `token` — the one-time token (shown once)
   - `subdomain` — the venue's subdomain
   - `local_host` / `local_port` — leave `homeassistant` / `8123`
   - `use_wss` — enable only if the venue blocks outbound 7000 (rides 443)
4. Start the add-on. The venue shows **Connected** in the portal.

## Required Home Assistant setting

Because HA is reached through the portal's reverse proxy, add to
`configuration.yaml` (Settings → Add-ons → File editor, then restart HA):

```yaml
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 172.30.32.0/23   # Home Assistant Supervisor add-on network
```

Without it, HA rejects the proxied requests with "400: Bad Request".

## Security notes

- The token is per-venue and revocable from the portal; revoking drops the
  live tunnel. Keep strong Home Assistant user passwords — the portal login
  and HA's own login are two independent layers.
- Container/Core HA installs (no Supervisor) can't use this add-on; use the
  `docker/` compose sidecar in this repo instead.
