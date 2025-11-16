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
        return;
    }
    $process.return();
    processes.delete(pid);
};

export const send = (destinationPid, message, sendViewToElm) => {
    const $process = processes.get(destinationPid);
    if ($process === undefined) {
        log(`tried to send to non-existent process ${destinationPid}`);
        return;
    }
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
    = null
    | { type: "send", destination_pid: number, message: object }
*/
function runCmd(cmd, sendViewToElm) {
    if (cmd === null) return;
    switch (cmd.type) {
        case "send":
            send(cmd.destination_pid, cmd.message, sendViewToElm);
            return;
        default:
            log(`unknown cmd: ${cmd.type}`);
            return;
    }
}
