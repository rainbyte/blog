---
title: ¿Es la moneda digital China la mejor opción para el mundo?
geometry: a4paper,margin=2.1cm
author: rainbyte
published: 2020-05-12 20:03:00
updated: 2020-05-12 21:20:00
tags: cryptocurrency, nanocurrency, xrb 
language: es
commentsIssue: 4
---

## Introducción

Según [*China Daily*][news-chinadaily]
la nueva moneda de dicho país llevaría el nombre *E-RMB*,
e informa que ya se realizaron pruebas de uso en las ciudades de Shenzhen,
Suzhou, Chengdu y Xiong'an. Aunque todavía se desconocen detalles de su
implementación final, se sabe que las operaciones ya no se realizarán sobre
servidores de empresas o bancos sin supervision directa.

Con estas noticias recientes sobre este desarrollo de China, aparecen ciertos
interrogantes que nos hacen pensar: ¿Provee alguna ventaja? ¿Cuáles son sus
costos asociados? ¿Qué cambios causaría?

En el contexto actual conviven distintos sistemas que interactúan entre si:

- Billetes de papel emitidos por bancos centrales
- Cuentas en bancos tradicionales
- Pago electrónico (Alipay, MercadoPago, Ualá, WeChat Pay)
- Cajeros automáticos (Banelco, Link)
- Saldo virtual en sitios web específicos.

Algunos de estos sistemas son digitales, entonces ¿cuál es la diferencia entre
esta moneda digital y los sistemas existentes?

## Marco teórico de análisis

Para evaluar un sistema de dinero digital, precisamos revisar un conjunto de
cualidades que nos permiten conocer su naturaleza desde ciertas perspectivas:

- Velocidad de confirmación: cantidad de tiempo requerido para propagar una
  transacción y confirmarla de manera segura.
- Escalabilidad: cantidad de transacciones que la infraestructura de la red
  puede procesar por segundo, fundamental en momentos de uso elevado.
- Comisiones: dinero que cobra el propio sistema por procesar una transacción,
  cubriendo costos operativos, consumo energético e impacto ambiental.
- Consenso: hablamos de una red *descentralizada* cuando las decisiones se toman
  por acuerdo entre sus participantes, caso contrario es una red *centralizada*,
  donde un número limitado de entes poseen un alto grado de control.
- Inmutabilidad: posibilidad de modificar transacciones ya realizadas, ya sea
  cambiar su monto, destinatario, o incluso cancelarlas.
- Privacidad: nivel de protección de los datos específicos sobre una transacción,
  como su monto, los usuarios implicados, la fecha exacta, etc.
- Emisión y distribución: ¿Se generan más unidades monetarias? ¿Bajo qué
  condiciones? ¿Cómo llega ese dinero a los usuarios?
- Contratos inteligentes: posibilidad de programar contratos que son verificados
  y aplicados por el propio sistema, con poca o nula intervención humana.
- Auditabilidad: cuando el código de la implementación está disponible, las
  instituciones, empresas y particulares pueden inspeccionarlo para entender
  y verificar su correcto funcionamiento, lo cual también es util para crear
  sistemas independientes que se integran formando un ecosistema.

## La propuesta de China

A pesar de que China ya posee sistemas digitales como ya mencionamos, su manejo
es realizado por empresas y bancos privados, por lo que el país muestra interés
en un sistema catalogado como CBDC (monedas digitales de los bancos centrales),
el cual le permitiría un mayor control sobre el flujo de transacciones.

Incluso aunque China incursionó en la investigación sobre `blockchain`, un tipo
de sistema descentralizado, ello no implica que el diseño de su moneda también
lo sea, por el contrario demostró rechazo al espíritu de esa solución. Por ello
se estima que el país busca reservar cierto control sobre la emisión y las
cuentas, lo cual señala elevada centralización, contraria al enfoque inicial.

No se hicieron comunicados sobre la disponibilidad de la moneda a nivel global,
pero son evidentes planes de utilizar la nueva moneda como único medio para
liquidar grandes transacciones provenientes de empresas e instituciones en el
exterior, lo cual coincide con los rumores de que el país se esta deshaciendo
de sus reservas en dólares.

Se desconoce si la moneda dará soporte para alguna clase de contrato inteligente,
pero los sistemas centralizados son inadecuados para contratos confiables, y se
asume que no proveerá opciones de completa privacidad, ya que el gobierno planea
un monto elevado de monitorización de las transacciones en tiempo real.

## Conclusión

Se puede notar cierto nivel de hermetismo en torno al proyecto de la moneda
China E-RMB, lo cual indica que a pesar de cubrir el apartado de escalabilidad
en las pruebas, es posible que el sistema oculte un alto grado de centralización
y no provea garantías de auditabilidad, para la población en general, ni para
empresas y bancos que conforman el sistema actual.

Esta moneda no muestra ventajas claras, busca reemplazar el dinero de papel por
un formato electrónico más restrictivo y reducir la influencia de entidades
privadas, causando un costo social elevado, por lo tanto se recomienda el uso
de alternativas más equitativas que ya funcionan a escala global.

Existen sistemas descentralizados, que actúan por consenso de todos sus
integrantes. Aunque muchos usan la tecnología `blockchain`, aparecieron
tecnologías más eficientes, como [`block-lattice`][refs-block-lattice],
que permiten mejoras importantes de escalabilidad y los hacen más
atractivos.

Cualquier persona, con acceso a un dispositivo conectado a internet, puede
participar en estas redes a nivel mundial y con alto grado de seguridad. Los
gobiernos, siguiendo las mismas reglas, pueden integrarlas en su flujo local.
Imprimir un [`código QR`][wiki-qrcode] en papel permite recibir pagos sin
internet.

A modo informativo describimos algunos ejemplos y sus características:

- [Bitcoin][site-bitcoin] (2008 `blockchain`): el sistema más popular de este
  tipo, pero ha
  mostrado limitaciones de escalabilidad y un alto consumo energético. Una
  transacción toma tiempos mayores a 20 minutos y la comisión ronda 3 USD
  (Mayo 2020). Emite 12.5 monedas cada 10 minutos, hasta 21 millones.
  Sitio web, [https://bitcoin.org][site-bitcoin]
- [Ethereum][site-ethereum] (2015 `blockchain`): mediante contratos inteligentes
  permite crear
  aplicaciones autónomas que interactúan con los usuarios. Una transacción tarda
  unos 6 minutos y la comisión rondan 0.11 USD (Mayo 2020), emite 2 monedas cada
  15 segundos, sin limite.
  Sitio web, [https://ethereum.org][site-ethereum]
- [Nano XRB][site-nano] (2015 `block-lattice`): puede realizar transacciones
  inmutables en
  tiempo menor a 0.2 segundos, es libre de comisiones, ya que la red prioriza
  la eficiencia y minimiza los costos de consumo eléctrico. Existen solo 133
  millones de monedas, la emisión y distribución finalizó.
  Sitio web, [https://nano.org][site-nano]

En todos los casos el código de las implementaciones está disponible para su
análisis en los respectivos sitios, lo cual permite estudiarlas e integrarlas
con sistemas existentes.

[news-chinadaily]: https://www.chinadaily.com.cn/a/202004/24/WS5ea28240a310a8b2411516bf.html
[news-theguardan.com]: https://www.theguardian.com/world/2020/apr/28/china-starts-major-trial-of-state-run-digital-currency
[refs-nakamoto-coefficient]: https://news.earn.com/quantifying-decentralization-e39db233c28e
[refs-block-lattice]: https://tokens-economy.gitbook.io/consensus/chain-based-dag/block-lattice-directed-acyclic-graphs-dags
[site-bitcoin]: https://bitcoin.org
[site-ethereum]: https://ethereum.org
[site-nano]: https://nano.org
[site-nano-docs]: https://docs.nano.org
[wiki-bitcoin]: https://en.wikipedia.org/wiki/Bitcoin
[wiki-ethereum]: https://en.wikipedia.org/wiki/Ethereum
[wiki-gini-coefficient]: https://en.wikipedia.org/wiki/Gini_coefficient
[wiki-nano]: https://en.wikipedia.org/wiki/Nano_(cryptocurrency)
[wiki-qrcode]: https://en.wikipedia.org/wiki/QR_code
