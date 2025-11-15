// Both Rust wasm-bindgen and C++ Emscripten do generate their own JS ESM modules,
// but it's possible AssemblyScript or some other language would just provide the .wasm file.
// At that point this function would be useful.
export const initRawWasmChildProcess = async (wasmModuleUrl) => {
    let response = undefined;

    if (WebAssembly.instantiateStreaming) {
        // Streaming
        response = await WebAssembly.instantiateStreaming(fetch(wasmModuleUrl));
    } else {
        // Fallback: fetch fully before instantiating
        const fetchAndInstantiateTask = async () => {
            const wasmArrayBuffer = await fetch(wasmModuleUrl).then(response => response.arrayBuffer());
            return WebAssembly.instantiate(wasmArrayBuffer);
        };
        response = await fetchAndInstantiateTask();
    }

    const {onInit, onMsg} = response.instance.exports;
    return await initWasmChildProcess(onInit, onMsg);

};
