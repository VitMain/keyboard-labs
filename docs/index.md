# Keyboard Labs

Build guides and shared notes for the PCBs in [rgoulter/keyboard-labs](https://github.com/rgoulter/keyboard-labs).

Use the nav for the board you are building.

The Pico42 build guide assembles shared fragments from `docs/includes/` via pymdownx.snippets,
so its soldering-tools and RP2040-flashing sections share one source of truth with the Notes/Flashing pages.
GitHub blob views do not expand these includes; read that guide on this site.

## Local preview

```bash
just docs::serve
```

Binds `0.0.0.0:8000`.
Open `http://<this-host>:8000/`.
