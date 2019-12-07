---
title: Plantillas de Gnome
author: rainbyte
published: 2019-12-07 02:51:00
tags: gnome
language: es
commentsIssue: 3
---

## Plantillas de Gnome

Gnome posee una carpeta `~/Plantillas` en la cual es posible agregar archivos como base para crear nuevos documentos de forma automática.

Muchas veces se da el caso de crear documentos con cierto contenido que se repite en cada uno de ellos, por ejemplo los archivos .desktop:

```desktop
[Desktop Entry]

Type=Application
Name=Firefox
Exec=/usr/bin/firefox
```

Como puede verse, estos documentos siempre tienen la misma cabecera y algunas opciones que deben estar allí siempre (ej. `Type` y `Name`).

Como solución podríamos crear un archivo `~/Plantillas/Nuevo Desktop Entry.desktop`, para evitar tipear esas cosas, algo asi:

```desktop
[Desktop Entry]

Type=Application
Name=${nombre}
Exec=${comando}
```

Luego desde Nautilus podemos hacer click derecho e ir al menú `Nuevo documento...` y allí ver nuestra plantilla.

Finalmente es cuestión de cambiar el nombre y rellenar los campos (ej. `${nombre}` y `${comando}`).
