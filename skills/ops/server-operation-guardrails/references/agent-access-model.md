# Agent Access Model

When the user wants to grant an agent permission to manage a whole server, prefer a dedicated operations account instead of root:

```bash
ops
```

Recommended setup:

- Use a dedicated user such as `ops` for server administration. Use `deploy` only when the account is limited to application deployment.
- Add only the agent machine's SSH public key to `/home/ops/.ssh/authorized_keys`. Public keys are acceptable to share; private keys are never acceptable to paste or print.
- Grant `ops` sudo through a separate sudoers file when broad server management is intended:

```bash
ops ALL=(ALL) NOPASSWD:ALL
```

- Validate sudoers syntax with `visudo -cf <file>` after creating or changing the sudoers file.
- Treat passwordless sudo as high trust: it allows normal installation, configuration, service management, and deployment work, but it does not waive the confirmation rules for deletion-like or high-risk operations.
- After access is created, verify with read-only commands first: `whoami`, `id`, `hostname`, `cat /etc/os-release`, `sudo -n true`, and relevant version/status checks.
- Do not log in as root for routine work once `ops` works. Use root or provider console only for bootstrapping or recovery.
- If access must be revoked, remove or disable the specific public key or sudoers grant only after explicit user confirmation, because revocation is a deletion-like/security-sensitive operation.
