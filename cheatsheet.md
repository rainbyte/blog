---
title: Useful commands and snippets cheatsheet
---

## awk

- AndroidSdk installed pkgs: `sdkmanager --list | awk '/Installed/{flag=1; next} /Available/{flag=0} flag'`

## common terminal tasks

- Backup via ssh: `rsync -auv -e 'ssh -p $port' $hostname:'"/orig/"' '/dest/'`
- Cmd info (detailed): `man $command`
- Cmd info (summary): `tldr $command`
- Find files: `find $root-path -name "$file-pattern"`
- Find dirs: `find $root-path -name "$file-pattern" -type d`
- Follow logs: `tail -f $logfile`
- Process json: `curl $url | jq $json-query`
- Sed delete line: `sed -i "${line-number}d" $file`
- Sed replace str: `sed -i "s/$before/$after/g" $file`

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
- Youtube video: `youtube-dl -k -x --prefer-free-formats --all-subs -f bestvideo[height<=720]+bestaudio/best --rm-cache $url`
`

## fish

- Create cmd shortcut: `alias -s $name "$command"`
- Save function: `funcsave $function`

## flatpak

- App info (installed): `flatpak info $app`
- App info (remote): `flatpak remote-info $repo --app $app`
- Custom list: `flatpak list --columns=name,application,version,runtime,size,origin`
- Expose folder to app: `flatpak --filesystem=$folder:ro $app`
- Expose envvar to app: `flatpak --env=$envvar=$value $app`
- Remove unneeded deps: `flatpak remove --unused`
- Show running apps: `flatpak ps`

## git

- List previous states for recovery: `git reflog show`

## haskell stack

- Custom cache: `stack --work-dir $cache $cmd`
- Docs build: `stack haddock`
- Docs open: `stack haddock --open $package`
- Profiling build: `stack build --profile`
- Profiling exec: `stack exec --profile -- $executable +RTS $options`

## image processing

- Get img size: `identify -format "%wx%h" $img-file`
- Resize img: `convert $img-orig -resize $wx$h $img-dest`

## javascript

- Parse number before a dot: `content.split('.', 1)[0]`

## gnome extensions

- Reload: `gnome-shell-extension-tool -r $extension-uuid`
- Enable: `gnome-extensions enable $extension-uuid`
- Disable:  `gnome-extensions disable $extension-uuid`
- Paths:
  - System: `/usr/share/gnome-shell/extensions/`
  - User: `$HOME/.local/share/gnome-shell/extensions/`

## mariadb / mysql

- Connect: `mysql -D $db-name -u $db-user -p`
- Dump: `mysqldump -u $db-user $db-name > $file`

## package management (arch)

- Gen checksums: `makepkg -g`
- Gen .SRCINFO: `makepkg --printsrcinfo > .SRCINFO`

## python

- Avoid Conda autostart: `conda config --set auto_activate_base False`

## systemd

- Follow logs: `journalctl -f -n0`
