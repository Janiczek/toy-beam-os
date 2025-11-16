import { childProcess } from "./child_process.mjs";

const log = (message) => {
    console.log(`[scheduler] ${message}`);
};

// Scheduler state
let nextUnusedPid = 0;
const processes = new Map();

export const kill = (pid) => {
    const $process = processes.get(pid);
    if ($process === undefined) {
        log(`tried to kill non-existent process ${pid}`);
    } else {
        $process.return();
        processes.delete(pid);
    }
};

export const send = (destinationPid, message, sendViewToElm) => {
    const $process = processes.get(destinationPid);
    const output = $process.next(message).value;
    sendViewToElm(destinationPid, output.view);
    runCmd(output.cmd, sendViewToElm);
};

export const spawn = (onInit, onMsg, view, sendViewToElm) => {
    const pid = nextUnusedPid++;
    const $process = childProcess(pid, onInit, onMsg, view);
    const output = $process.next().value;
    sendViewToElm(pid, output.view);
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