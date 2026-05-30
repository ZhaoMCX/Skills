# Change Procedure

For any server change:

1. Identify the target host, user, working directory, service, config file, and intended effect.
2. Capture current state with read-only commands.
3. Show the user the exact write commands or patch plan before executing them.
4. Create timestamped backups of config files before editing.
5. Apply the smallest possible change.
6. Run syntax checks or dry runs before reloads or restarts.
7. Prefer reload over restart when the service supports it and the config test passes.
8. Verify externally and internally after the change.
9. Keep and communicate a rollback command/path.

Example backup pattern:

```bash
sudo cp /etc/nginx/sites-available/app.conf /etc/nginx/sites-available/app.conf.bak-$(date +%Y%m%d-%H%M%S)
```

Example safe Nginx flow:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

Only run `reload` after `nginx -t` succeeds.
