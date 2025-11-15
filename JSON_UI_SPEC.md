# JSON UI Spec

This document describes the JSON format for representing a virtual DOM tree in a
native layout-focused UI library, for use in the Toy BEAM OS.

Under the hood this is a thin wrapper on top of HTML+CSS.

## 1. Node Structure

Each node is a JSON object with at least a `"type"` field, which also determines which other fields are present.

```json
{
  "type": "node-type",
  "attributes": { ... },
  "children": [ ... ],
  "content": "...",
  "events": [ ... ]
}
```

- `type`: (string) The type of UI node. Examples: `"row"`, `"column"`, `"text"`, `"button"`, `"input"`.
- `attributes`: (object) Key-value pairs representing properties and layout, modeled on CSS where possible.
- `children`: (array) Child nodes; only valid for container types.
- `content`: (string) Used for leaf nodes like text.
- `events`: (array) List of event-handler mappings.

## 2. Standard Node Types

| Type   | Description                    | Notes                                            | attributes | children | content | events |
|--------|--------------------------------|--------------------------------------------------|:----------:|:--------:|:-------:|:------:|
| row    | Flex row container             | Like CSS `display: flex; flex-direction: row`    |   ✅       |   ✅     |   ❌     |  ✅    |
| column | Flex column container          | Like CSS `display: flex; flex-direction: column` |   ✅       |   ✅     |   ❌     |  ✅    |
| box    | Generic block/div              |                                                  |   ✅       |   ✅     |   ❌     |  ✅    |
| text   | Text leaf node                 | Uses `"content"`                                 |   ✅       |   ❌     |   ✅     |  ❌    |
| button | Interactive button             | `"children"` for label                           |   ✅       |   ✅     |   ✅     |  ✅    |
| input  | Interactive input              | `value`, `placeholder`                           |   ✅       |   ❌     |   ❌     |  ✅    |

## 3. Attributes

### CSS attributes

Attribute names should match CSS property names, e.g.:
  - `color`, `background-color`, `font-size`, `font-weight`
  - `padding`, `margin`, `gap`
  - `align-items`, `justify-content`
  - `width`, `height`, `min-width`, `max-width`, etc.

Use CSS units for values: `"px"`, `"em"`, `"%"`, etc.

### Non-CSS attributes

- `value`: Controlled string value (inputs).
- `placeholder`: Placeholder text for inputs.

## 4. Containers

### Flex Containers

**Row:**
```json
{
  "type": "row",
  "attributes": {
    "align-items": "center",
    "justify-content": "start",
    "gap": "8px"
  },
  "children": [...]
}
```

**Column:**
```json
{
  "type": "column",
  "attributes": {
    "align-items": "stretch",
    "gap": "4px"
  },
  "children": [...]
}
```

## 5. Events

- The `"events"` array attaches one or more handlers to a node.
- Each event is an object:
  - Key: Event type (e.g. `"click"`, `"change"`)
  - Value: String identifier
- The whole event will be sent to the process owning the view as a message.

Example:
```json
"events": [
  {"click": "button-pressed"},
]
```

Clicking the button will send the following JSON to the process' `on_msg(msg,model)` function:

```json
{"system": "view", data: {"click": "button-pressed"}}
```

## 6. Example

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