# Risky Operations

Do not run these unless the user explicitly confirms the exact intent after seeing the risk:

- `rm -rf`, broad recursive deletion, or deletion from computed paths
- any deletion-like operation, including `rm`, `rmdir`, `unlink`, `userdel`, package removal/uninstall commands, truncation, cleanup of logs/data/artifacts, or replacing a directory/file in a way that discards existing content
- `mkfs`, `fdisk`, partitioning, disk formatting, or volume removal
- `reboot`, `shutdown`, or stopping critical services
- firewall/security-group changes such as `ufw`, `iptables`, `nft`, cloud ACL edits
- database schema/data changes, migrations, truncation, restore, or import
- package upgrades that can change many dependencies, especially `dist-upgrade`
- permission or ownership changes over broad paths such as `/`, `/etc`, `/var`, `/home`
- replacing SSH configuration or authorized keys in a way that could lock out access
- disabling security controls, SELinux/AppArmor, TLS verification, or authentication
- exposing secrets, private keys, tokens, environment files, or database dumps
