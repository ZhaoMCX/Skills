# Secrets And TLS

## Credentials And Secrets

- Never ask the user to paste private keys, certificate private keys, passwords, API tokens, database URLs, or `.env` secrets into chat when there is a safer alternative.
- If a secret is already exposed in chat, recommend rotating it.
- Prefer SSH keys over passwords. Use the public key only; never upload or display the private key.
- When a private key file is needed on the server, have the user upload it or reference an existing server path. Do not print the key.
- Redact secrets in summaries and command output.

## Certificates And HTTPS

For TLS/Nginx work:

- Confirm the domain, certificate files, private key path, backend port, and current Nginx layout before editing.
- Do not request the contents of `.key` files. Use file paths and permissions checks instead.
- Set certificate private keys to restrictive permissions, commonly `600` and owned by `root`.
- Validate with `nginx -t` before reload.
- Test HTTP and HTTPS after reload, including certificate chain and reverse proxy behavior.
