#include <emscripten/bind.h>
#include <emscripten/val.h>
#include <variant>
#include <string>
#include <memory>
#include <optional>

using namespace emscripten;

using Model = int32_t;

struct IncrementBy {
    int32_t value;
};

struct Decrement {};

struct MultiplyBy10 {};

using Msg = std::variant<IncrementBy, Decrement, MultiplyBy10>;

struct CmdNone {};

struct CmdSend {
    int32_t destination_pid;
    val message;
};

using Cmd = std::variant<CmdNone, CmdSend>;

struct Output {
    Model model;
    Cmd cmd;
};

val msg_to_js(const Msg& msg) {
    val obj = val::object();
    
    if (std::holds_alternative<IncrementBy>(msg)) {
        auto& inc = std::get<IncrementBy>(msg);
        obj.set("type", "IncrementBy");
        obj.set("value", inc.value);
    } else if (std::holds_alternative<Decrement>(msg)) {
        obj.set("type", "Decrement");
    } else if (std::holds_alternative<MultiplyBy10>(msg)) {
        obj.set("type", "MultiplyBy10");
    }
    
    return obj;
}

std::optional<Msg> msg_from_js(const val& msg_obj) {
    if (!msg_obj.hasOwnProperty("type")) {
        return std::nullopt;
    }
    
    std::string type = msg_obj["type"].as<std::string>();
    
    if (type == "IncrementBy") {
        if (msg_obj.hasOwnProperty("value")) {
            return IncrementBy{msg_obj["value"].as<int32_t>()};
        }
    } else if (type == "Decrement") {
        return Decrement{};
    } else if (type == "MultiplyBy10") {
        return MultiplyBy10{};
    }
    
    return std::nullopt;
}

val cmd_to_js(const Cmd& cmd) {
    val obj = val::object();
    
    if (std::holds_alternative<CmdNone>(cmd)) {
        obj.set("type", "None");
    } else if (std::holds_alternative<CmdSend>(cmd)) {
        auto& send = std::get<CmdSend>(cmd);
        obj.set("type", "Send");
        obj.set("destination_pid", send.destination_pid);
        obj.set("message", send.message);
    }
    
    return obj;
}

val output_to_js(const Output& output) {
    val obj = val::object();
    obj.set("model", output.model);
    obj.set("cmd", cmd_to_js(output.cmd));
    return obj;
}

std::pair<Model, Cmd> on_msg_impl(const Msg& msg, Model model) {
    if (std::holds_alternative<IncrementBy>(msg)) {
        auto& inc = std::get<IncrementBy>(msg);
        Model new_model = model + inc.value;
        return {new_model, CmdNone{}};
    } 
    else if (std::holds_alternative<Decrement>(msg)) {
        Model new_model = model - 1;
        Cmd cmd = CmdSend{
            0,
            msg_to_js(MultiplyBy10{})
        };
        return {new_model, cmd};
    }
    else if (std::holds_alternative<MultiplyBy10>(msg)) {
        Model new_model = model * 10;
        return {new_model, CmdNone{}};
    }
    
    return {model, CmdNone{}};
}

// Exported functions
val on_init() {
    Output output{0, CmdNone{}};
    return output_to_js(output);
}

val on_msg(const val& msg_obj, Model model) {
    auto msg_opt = msg_from_js(msg_obj);
    
    if (!msg_opt.has_value()) {
        val::global("console").call<void>("log", 
            std::string("[cpp_counter] Failed to parse message"));
        return output_to_js(Output{model, CmdNone{}});
    }
    
    auto [new_model, cmd] = on_msg_impl(msg_opt.value(), model);
    return output_to_js(Output{new_model, cmd});
}

EMSCRIPTEN_BINDINGS(counter) {
    function("on_init", &on_init);
    function("on_msg", &on_msg);
}

