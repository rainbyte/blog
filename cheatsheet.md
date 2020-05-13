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
- Show $BUS_NAME PID (1): `dbus-send --session --print-reply --dest=org.freedesktop.DBus / org.freedesktop.DBus.GetConnectionUnixProcessID string:$BUS_NAME`
- Show $BUS_NAME PID (2): `gdbus call --session --dest org.freedesktop.DBus --object-path / --method org.freedesktop.DBus.GetConnectionUnixProcessID $BUS_NAME`

## downloads from terminal

- Common: `aria2c $url`
- Magnet: `aria2c $magnet-uri`
- Torrent: `aria2c $torrent-file`
- Site (spider copy): `httrack $url --path $folder`
- Site (single page): `httrack $url --path $folder --near --robots=0 --depth=1`

## fish

- Create cmd shortcut: `alias -s $name "$command"`
- Save function: `funcsave $function`

## flatpak

- App info (installed): `flatpak info $app`
- App info (remote): `flatpak remote-info $repo --app $app`
- Expose folder to app: `flatpak --filesystem=$folder:ro $app`
- Expose envvar to app: `flatpak --env=$envvar=$value $app`
- Remove unneeded deps: `flatpak remove --unused`
- Show running apps: `flatpak ps`

## haskell stack

- Custom cache: `stack --work-dir $cache $cmd`
- Profiling build: `stack build --profile`
- Profiling exec: `stack exec --profile -- $executable +RTS $options`

## javascript

- Parse number before a dot: `content.split('.', 1)[0]`

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

## python

- Avoid Conda autostart: `conda config --set auto_activate_base False`

## systemd

- Follow logs: `journalctl -f -n0`
