import {spawn, send} from "./scheduler.mjs";
import cppCounterInit from "./child_processes/cpp_counter/counter.js";
import * as rustCounterModule from "./child_processes/rust_counter/rust_counter.js";

const log = (message) => {
    console.log(`[main] ${message}`);
};

const renderer = window.Elm.Main.init({ node: document.getElementById("elm") });
renderer.ports.userClosedWindow.subscribe((pid) => {
    log(`TODO handle: User closed window: ${pid}. We should probably kill the process.`);
});

const sendViewToElm = (view) => {
    renderer.ports.setProcessView.send({pid: pid, view: view});
};

log('CPP');
const cppCounter = await cppCounterInit();
const cppCounterPid = await spawn(cppCounter.on_init, cppCounter.on_msg, cppCounter.view, sendViewToElm);
log(`CPP PID: ${cppCounterPid}`);
send(cppCounterPid, {type: "IncrementBy", value: 1});
send(cppCounterPid, {type: "IncrementBy", value: 2});
send(cppCounterPid, {type: "Decrement"});


log('RUST');
await rustCounterModule.default();
const rustCounterPid = await spawn(rustCounterModule.on_init, rustCounterModule.on_msg, rustCounterModule.view, sendViewToElm);
log(`RUST PID: ${rustCounterPid}`);
send(rustCounterPid, {type: "IncrementBy", value: 1});
send(rustCounterPid, {type: "IncrementBy", value: 2});
send(rustCounterPid, {type: "Decrement"});