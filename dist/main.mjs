import {spawn, send, kill} from "./scheduler.mjs";
import cppCounterInit from "./child_processes/cpp_counter/counter.js";
import * as rustCounter from "./child_processes/rust_counter/rust_counter.js";

const log = (message) => { console.log(`[main] ${message}`); };

const renderer = window.Elm.Main.init({ node: document.getElementById("elm") });

const sendViewToElm = (pid, view) => {
    renderer.ports.setProcessView.send({pid: pid, view: view});
};

renderer.ports.userClosedWindow.subscribe((pid) => {
    kill(pid);
});

renderer.ports.jsonUiEvent.subscribe(({pid, eventType, identifier}) => {
    send(pid, {type: "system_ui", eventType, identifier}, sendViewToElm);
});


log('spawning rust_counter.wasm');
await rustCounter.default();
const rustCounterPid = spawn(rustCounter.on_init, rustCounter.on_msg, rustCounter.view, sendViewToElm);
log(`got PID: ${rustCounterPid}`);

log('spawning cpp_counter.wasm');
const cppCounter = await cppCounterInit();
const cppCounterPid = spawn(cppCounter.on_init, cppCounter.on_msg, cppCounter.view, sendViewToElm);
log(`got PID: ${cppCounterPid}`);