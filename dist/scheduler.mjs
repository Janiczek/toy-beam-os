import { childProcess } from "./child_process.mjs";

const log = (message) => {
    console.log(`[scheduler] ${message}`);
};

// Scheduler state
let nextUnusedPid = 0;
const processes = new Map();

export const send = (destinationPid, message, sendViewToElm) => {
    log(`sending to ${destinationPid}: ${JSON.stringify(message)}`);
    const $process = processes.get(destinationPid);
    const output = $process.next(message).value;
    sendViewToElm(output.view);
    runCmd(output.cmd);
};

export const spawn = async (onInit, onMsg, view, sendViewToElm) => {
    const pid = nextUnusedPid++;
    const $process = childProcess(pid, onInit, onMsg, view);
    const output = $process.next().value;
    sendViewToElm(output.view);
    runCmd(output.cmd, sendViewToElm);
    processes.set(pid, $process);
    return pid;
};

/*
type Cmd
    = { type: "None" }
    | { type: "Send", destination_pid: number, message: object }
*/
function runCmd(cmd, sendViewToElm) {
    if (cmd === null) return;
    switch (cmd.type) {
        case "Send":
            send(cmd.destination_pid, cmd.message, sendViewToElm);
            return;
        default:
            log(`unknown cmd: ${cmd.type}`);
            return;
    }
}