export function* childProcess(pid, onInit, onMsg, view) {
    const log = (message) => {
        console.log(`[PID ${pid}] ${message}`);
    };

    const output = onInit();
    log(`onInit() --> ${JSON.stringify(output)}`)
    let model = output.model;
    let modelView = view(model);
    log(`view(model) --> ${JSON.stringify(modelView)}`)
    let message = yield {cmd: output.cmd, view: modelView};
    // TODO add a way to kill the process
    while (true) {
        log(`got message: ${JSON.stringify(message)}`)
        const output = onMsg(message, model);
        log(`onMsg() --> ${JSON.stringify(output)}`)
        model = output.model;
        modelView = view(model);
        log(`view(model) --> ${JSON.stringify(modelView)}`)
        message = yield {cmd: output.cmd, view: modelView};
    }
}