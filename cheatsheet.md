---
title: Useful commands and snippets cheatsheet
---

## common terminal tasks

- Find files: `find $root-path -name "$file-pattern"`
- Find dirs: `find $root-path -name "$file-pattern" -type d`
- Follow logs: `tail -f $logfile`
- Cmd info (detailed): `man $command`
- Cmd info (summary): `tldr $command`

## dbus interaction

- Inspect notifications: `dbus-monitor interface='org.freedesktop.Notifications'`
- Inspect notifications: `dbus-monitor interface='org.gtk.Notifications'`

## downloads from terminal

- Common: `aria2c $url`
- Magnet: `aria2c $magnet-uri`
- Torrent: `aria2c $torrent-file`

## fish

- Create cmd alias: `alias $name "$command"`
- Save function: `funcsave $function`

## gnome extensions

- Reload: `gnome-shell-extension-tool -r $extension-uuid`
- Enable: `gnome-shell-extension-tool -e $extension-uuid`
- Disable:  `gnome-shell-extension-tool -d $extension-uuid`
- Paths:
    - System: `/usr/share/gnome-shell/extensions/`
    - User: `$HOME/.local/share/gnome-shell/extensions/`

## mariadb / mysql

- Connect: `mysql -D $db-name -u $db-user -p`
- Dump: `mysqldump -u $db-user $db-name > $file`

## systemd

- Follow logs: `journalctl -f -n0`
