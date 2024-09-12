# Communication Package

This package provides a simple way to communicate with a microcontroller over a WebSocket connection. It includes heartbeat functionality.

## Setup

To use the package you must install its dependencies (found in [`./package.lock`](./package.lock)).

```bash
jag pkg install
```

## Testing

Optionally, you can also install [WebSocket cat](https://github.com/websockets/wscat) (`wscat`) to test the WebSocket connection. (Note, this requires you to have [Node.js](https://nodejs.org/en/) installed.)

```bash
npm install --global wscat
```

Then, to test the WebSocket connection, run:

```bash
wscat --connect ws://IP:PORT
# You can now interactively send messages to the microcontroller
```

Here is how you might send repeated messages to the microcontroller:

```bash
# Version using bash
for i in $(seq 1 10); do echo "$i" && sleep 0.9; done | wscat --connect ws://172.28.125.50:55270
```

```fish
# Version using fish
for i in (seq 1 10); echo "$i"; and sleep 0.9; end | wscat --connect ws://172.28.125.50:55270
```
