export function* childProcess(pid, onInit, onMsg, view) {
    const log = (message) => {
        console.log(`[PID ${pid}] ${message}`);
    };

    try {
        const output = onInit();
        let model = output.model;
        let modelView = view(model);
        let message = yield {cmd: output.cmd, view: modelView};
        while (true) {
            log(`got message: ${JSON.stringify(message)}`)
            const output = onMsg(message, model);
            model = output.model;
            modelView = view(model);
            message = yield {cmd: output.cmd, view: modelView};
        }
    } finally {
        log(`Cleanup inside process ${pid} (currently doing nothing)`);
    }
}