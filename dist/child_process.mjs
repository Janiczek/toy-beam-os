export function* childProcess(pid, onInit, onMsg) {
    const log = (message) => {
        console.log(`[PID ${pid}] ${message}`);
    };

    const output = onInit();
    log(`onInit() --> ${JSON.stringify(output)}`)
    let model = output.model;
    let message = yield output.cmd;
    // TODO add a way to kill the process
    while (true) {
        log(`got message: ${JSON.stringify(message)}`)
        const output = onMsg(message, model);
        log(`onMsg() --> ${JSON.stringify(output)}`)
        model = output.model;
        message = yield output.cmd;
    }
}