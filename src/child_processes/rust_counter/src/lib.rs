use gloo_utils::format::JsValueSerdeExt;
use serde::{Deserialize, Serialize};
use wasm_bindgen::prelude::*;
use web_sys::console;

pub type Model = i32;

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "type")]
pub enum Msg {
    IncrementBy { value: i32 },
    Decrement,
    MultiplyBy10,
}

#[derive(Debug, Clone)]
pub enum Cmd {
    None,
    Send { destination_pid: i32, message: JsValue },
}

pub struct Output {
    pub model: Model,
    pub cmd: Cmd,
}

#[wasm_bindgen(start)]
pub fn start() {
    workflow_panic_hook::set_once(workflow_panic_hook::Type::Console);
    wasm_log::init(wasm_log::Config::default());
}

#[wasm_bindgen]
pub fn on_init() -> JsValue {
    to_output(0, Cmd::None)
}

#[wasm_bindgen]
pub fn on_msg(msg_obj: JsValue, model: Model) -> JsValue {
    match msg_from_js(&msg_obj) {
        Ok(msg) => {
            let (new_model, cmd) = on_msg_impl(msg, model);
            to_output(new_model, cmd)
        }
        Err(_) => {
            console::log_1(&"on_msg: Failed to parse message".into());
            to_output(model, Cmd::None)
        }
    }
}

fn on_msg_impl(msg: Msg, model: Model) -> (Model, Cmd) {
    match msg {
        Msg::IncrementBy { value } => {
            let new_model: Model = model + value;
            (new_model, Cmd::None)
        }
        Msg::Decrement => {
            let new_model: Model = model - 1;
            let cmd = Cmd::Send {
                destination_pid: 0,
                message: msg_to_js(&Msg::MultiplyBy10),
            };
            (new_model, cmd)
        }
        Msg::MultiplyBy10 => {
            let new_model: Model = model * 10;
            (new_model, Cmd::None)
        }
    }
}

fn msg_to_js(msg: &Msg) -> JsValue {
    JsValue::from_serde(msg).unwrap()
}

fn msg_from_js(msg_obj: &JsValue) -> Result<Msg, serde_json::Error> {
    msg_obj.into_serde()
}

fn cmd_to_js(cmd: &Cmd) -> JsValue {
    match cmd {
        Cmd::None => {
            let obj = js_sys::Object::new();
            js_sys::Reflect::set(&obj, &"type".into(), &"None".into()).unwrap();
            obj.into()
        }
        Cmd::Send { destination_pid, message } => {
            let obj = js_sys::Object::new();
            js_sys::Reflect::set(&obj, &"type".into(), &"Send".into()).unwrap();
            js_sys::Reflect::set(&obj, &"destination_pid".into(), &(*destination_pid).into()).unwrap();
            js_sys::Reflect::set(&obj, &"message".into(), message).unwrap();
            obj.into()
        }
    }
}

fn to_output(model: Model, cmd: Cmd) -> JsValue {
    let obj = js_sys::Object::new();
    js_sys::Reflect::set(&obj, &"model".into(), &model.into()).unwrap();
    js_sys::Reflect::set(&obj, &"cmd".into(), &cmd_to_js(&cmd)).unwrap();
    obj.into()
}