---
name: server-operation-guardrails
description: Provides safety rules for inspecting or changing remote servers while preserving service availability, credentials, and rollback paths. Use when Codex is asked to log into a backend server, production/staging host, VPS, cloud instance, Linux machine, Nginx/SSL/certificate environment, deployment target, systemd service, firewall, database host, or any remote environment where careless commands could interrupt service, expose credentials, or damage data.
---

# Server Operation Guardrails

## Overview

Use these guardrails before and during any remote server operation. Optimize for reversible, observable, least-privilege changes; treat production and unknown servers as production until proven otherwise.

## Reference Map

- `references/change-procedure.md`: read-only checks, backup patterns, change flow, and completion evidence.
- `references/risky-operations.md`: operations requiring explicit confirmation.
- `references/secrets-and-tls.md`: credential handling, TLS/Nginx checks, and HTTPS completion rules.
- `references/agent-access-model.md`: dedicated operations account, public-key access, sudoers validation, and revocation safety.

## Operating Mode

- Start with read-only inspection unless the user explicitly asks for a specific write operation and the risk is already clear.
- Explain what context is being gathered and what each command is expected to reveal.
- Before any write, destructive, privilege-escalated, service-impacting, network/firewall, database, certificate, or deployment operation, present the intended command or change and get explicit user confirmation.
- Before any deletion-like operation, always ask the user first and get explicit confirmation. This includes deleting files, removing users, uninstalling packages, clearing directories, truncating data, overwriting paths in a way that discards previous content, and any recursive remove command, even when broad server-management permission was granted.
- Prefer narrow commands over broad automation. Avoid shell one-liners that combine discovery, transformation, and mutation when separate steps are safer.
- Do not apply remote-server confirmation requirements to ordinary local read-only repo inspection.

## Read-Only First

Use harmless checks first, such as identity, hostname, working directory, OS version, listening ports, service status, logs, and config-test commands.

Avoid commands that change state during discovery, including package upgrades, service restarts, firewall edits, recursive deletes, database migrations, or permission changes.

## Change Procedure

For any server change:

1. Identify target host, user, working directory, service, config file, and intended effect.
2. Capture current state with read-only commands.
3. Show the exact write commands or patch plan before executing.
4. Create timestamped backups of config files before editing.
5. Apply the smallest possible change.
6. Run syntax checks or dry runs before reloads or restarts.
7. Prefer reload over restart when supported and tests pass.
8. Verify internally and externally after the change.
9. Communicate the rollback command/path.

## High-Risk Areas

Never proceed without explicit confirmation for deletion-like operations, destructive deletes, disk formatting, reboot/shutdown, stopping critical services, firewall/security-group changes, database mutations, broad package upgrades, broad permission changes, SSH lockout risks, disabling security controls, or exposing secrets.

Never ask the user to paste private keys, certificate private keys, passwords, API tokens, database URLs, or `.env` secrets into chat when a safer alternative exists.

When whole-server agent access is needed, prefer a dedicated `ops` account with only the agent machine's public key and a validated sudoers grant. Treat passwordless sudo as high trust, and keep deletion-like or security-sensitive revocation behind explicit confirmation.

For TLS/Nginx work, confirm domain, cert path, private key path, backend port, and current layout; use file paths and permission checks rather than printing key contents.

## Completion Standard

Do not claim a server change is complete unless there is evidence:

- config/service check passed
- service health or process/port status after the change
- successful external or local request when relevant
- backup/rollback path is known

If verification cannot be completed, state what was done, what remains unverified, and what the user should check next.
