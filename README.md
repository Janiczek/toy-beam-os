# toy-beam-os

## Architecture

- Scheduler written in JS, using JS Generators for child processes
- Renderer (screen manager) written in Elm and rendered via HTML+CSS (divs, flexbox).
- Child processes are WASM modules (written in any language you want) adhering to a common interface

## Child process interface

Modeled after the Elm architecture:

- export: `init() -> {model: Model, cmd: Cmd}`
- export: `update(msg: Msg, model: Model) -> {model: Model, cmd: Cmd}`
- export: `view(model: Model) -> {title: String, body: JsonUI}`

Your child process doesn't hold its own state (`Model`), the scheduler does that
behind the scenes and threads that to the `update` and `view` function calls.

All the exposed functions are meant to be pure, but that's not enforceable from
outside the WASM module.

`Model` can be any JS value you want.

`Msg` can be anything you want, but it's usually going to be a JS object with
`{"type": "some string", ...}`.

Specifically, user interaction (JsonUI events) will be of the form:
```json
{
  "type": "system_ui",
  "eventType": "click",
  "identifier": "something you provide"
}
```

### Cmd

There are two `Cmd`s currently available:

- no-op: `null`
- send a message: `{"type": "send", "destination_pid": 123, "message": JsValue}`

### JsonUI

JsonUI is a virtual DOM representation of the window for the process displayed in the OS.

See also [JSON_UI_SPEC.md](./JSON_UI_SPEC.md).

It is a JS object, eg.

```json
{
  "type": "row",
  "attributes": { "align-items": "center", "gap": "8px" },
  "children": [
    {
      "type": "button",
      "content": "-",
      "events": [
        { "click": "Decrement" }
      ]
    },
    {
      "type": "text",
      "attributes": { "font-size": "16px", "font-weight": "600" },
      "content": "12"
    },
    {
      "type": "button",
      "content": "+", 
      "events": [
        { "click": "Increment" }
      ]
    }
  ]
}
```

It is internally rendered as flexbox divs and HTML+CSS.

Events (eg. `{"click": "Decrement"}`) are passed to the user as the following `Msg`:
```json
{
  "type": "system_ui",
  "eventType": "click",
  "identifier": "Decrement"
}
```

## TODO

### Scheduler

- [ ] instrument the WASM files with yield points (to allow for scheduler reduction budget)
- [ ] monitors/links between processes
- [ ] catch child process crashes, cleanup, notify monitoring/linked processes and the OS

### OS (Elm app)

- [ ] allow spawning the Rust and C++ counters from the OS menu bar

### JsonUI

- [ ] inputs (value, placeholder), params in UI events

### UI

- [ ] menu bar + menus
- [ ] status bar should overflow-ellipsis instead of forcing the window to be wider or wrapping the text inside the status bar
- [ ] resizing a window
- [ ] vertical scrollbar
- [ ] horizontal scrollbar + both scrollbars at once
- [ ] top statusbar?
