# Kydax Add-ons

Home Assistant add-on repository for the Kydax remote-access system.

Add this repository in Home Assistant: Settings → Add-ons → Add-on Store →
⋮ → Repositories → `https://github.com/aldrouin/kydax_addons`.

## Add-ons

- **[Kydax Tunnel](frpc-tunnel/)** — outbound `frpc` tunnel connecting a
  venue's Home Assistant to the self-hosted Kydax portal
  ([aldrouin/kydax_dashboard](https://github.com/aldrouin/kydax_dashboard)).
  No ports are opened at the venue.

For container/Core installs without the Supervisor, use the compose sidecar
in [`docker/`](docker/) instead of the add-on.
