---
name: server-operation-guardrails
description: Global safety rules for connecting to, inspecting, or changing remote servers over SSH or similar tools. Use when Codex is asked to log into a backend server, production/staging host, VPS, cloud instance, Linux machine, Nginx/SSL/certificate environment, deployment target, systemd service, firewall, database host, or any remote environment where careless commands could interrupt service, expose credentials, or damage data.
---

# Server Operation Guardrails

## Overview

Use these guardrails before and during any remote server operation. Optimize for reversible, observable, least-privilege changes; do not rely on trust when a confirmation, backup, or dry run can reduce risk.

## Reference Map

- `references/change-procedure.md`: read-only discovery, backups, command review, verification, and rollback.
- `references/risky-operations.md`: deletion-like, destructive, security-sensitive, service-impacting, and database operations that need explicit confirmation.
- `references/secrets-and-tls.md`: credentials, secret handling, TLS, Nginx, certificates, and HTTPS checks.
- `references/agent-access-model.md`: dedicated operations users, SSH keys, sudo, access verification, and revocation.

## Operating Mode

- Start with read-only inspection unless the user explicitly asks for a specific write operation and the risk is already clear.
- Explain what context is being gathered and what the command is expected to reveal.
- Before any write, destructive, privilege-escalated, service-impacting, network/firewall, database, certificate, or deployment operation, present the intended command or change and get explicit user confirmation.
- Before any deletion-like operation, always ask the user first and get explicit confirmation. This includes deleting files, removing users, uninstalling packages, clearing directories, truncating data, overwriting paths in a way that discards previous content, and any recursive remove command, even when the user has granted broad server-management permission.
- Prefer narrow commands over broad automation. Avoid shell one-liners that combine discovery, transformation, and mutation when separate steps are safer.
- Treat production and unknown servers as production until proven otherwise.

## Read-Only First

Use harmless checks first, such as:

```bash
whoami
hostname
pwd
id
uname -a
lsb_release -a 2>/dev/null || cat /etc/os-release
ss -tulpn
systemctl status <service> --no-pager
journalctl -u <service> --no-pager -n 100
nginx -v
nginx -T 2>/dev/null
```

Avoid commands that change state during discovery, including package upgrades, service restarts, firewall edits, recursive deletes, database migrations, or permission changes.

## Completion Standard

Do not claim a server change is complete unless there is evidence:

- command output showing the config/service check passed
- service health or process/port status after the change
- a successful external or local request when relevant
- the backup/rollback path is known

If verification cannot be completed, say exactly what was done, what remains unverified, and what the user should check next.
