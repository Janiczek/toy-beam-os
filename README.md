# toy-beam-os

## TODO

### UI

- [ ] status bar should overflow-ellipsis instead of forcing the window to be wider or wrapping the text inside the status bar
- [ ] resizing a window
- [ ] vertical scrollbar
- [ ] horizontal scrollbar + both scrollbars at once
- [ ] top statusbar?

### Language

- [ ] BEAM bytecode interpreter? Or my own, or a parser/interpreter for some other language, or something that can run WASM?

### Scheduler

- [ ] Single-threaded in Elm for now
- [ ] WASM child processes
  - [ ] send(from: PID, to: PID, msg: String)
    - [ ] something other than String?
  - [ ] as direct running of WASM modules as possible at first
    - [ ] WebWorkers (multi-threading) later?