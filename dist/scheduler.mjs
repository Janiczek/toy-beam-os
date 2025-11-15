import { childProcess } from "./child_process.mjs";

const log = (message) => {
    console.log(`[scheduler] ${message}`);
};

// Scheduler state
let nextUnusedPid = 0;
const processes = new Map();

export const send = (destinationPid, message) => {
    log(`sending to ${destinationPid}: ${JSON.stringify(message)}`);
    const generator = processes.get(destinationPid);
    runCmd(generator.next(message).value);
};

export const spawn = async (onInit, onMsg) => {
    const pid = nextUnusedPid++;
    const processGenerator = childProcess(pid, onInit, onMsg);
    runCmd(processGenerator.next().value);
    processes.set(pid, processGenerator);
    return pid;
};

/*
type Cmd
    = { type: "None" }
    | { type: "Send", destination_pid: number, message: object }
*/
function runCmd(cmd) {
    if (cmd === undefined) return;
    switch (cmd.type) {
        case "None":
            log("ignoring Cmd.none");
            return;
        case "Send":
            send(cmd.destination_pid, cmd.message);
            return;
        default:
            log(`unknown cmd: ${cmd.type}`);
            return;
    }
}