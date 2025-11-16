#include <emscripten/bind.h>
#include <emscripten/val.h>
#include <variant>
#include <string>
#include <memory>
#include <optional>
#include "json_ui.hpp"

using namespace emscripten;

using Model = int32_t;

struct Increment {};

struct Decrement {};

struct PokePID0 {};

struct SystemUI {
    std::string eventType;
    std::string identifier;
};

using Msg = std::variant<Increment, Decrement, PokePID0, SystemUI>;

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
    
    if (std::holds_alternative<Increment>(msg)) {
        obj.set("type", "Increment");
    } else if (std::holds_alternative<Decrement>(msg)) {
        obj.set("type", "Decrement");
    } else if (std::holds_alternative<PokePID0>(msg)) {
        obj.set("type", "PokePID0");
    } else if (std::holds_alternative<SystemUI>(msg)) {
        auto& ui = std::get<SystemUI>(msg);
        obj.set("type", "system_ui");
        obj.set("eventType", ui.eventType);
        obj.set("identifier", ui.identifier);
    }
    
    return obj;
}

std::optional<Msg> msg_from_js(const val& msg_obj) {
    if (!msg_obj.hasOwnProperty("type")) {
        return std::nullopt;
    }
    
    std::string type = msg_obj["type"].as<std::string>();
    
    if (type == "Increment") {
        return Increment{};
    } else if (type == "Decrement") {
        return Decrement{};
    } else if (type == "PokePID0") {
        return PokePID0{};
    } else if (type == "system_ui") {
        if (msg_obj.hasOwnProperty("eventType") && msg_obj.hasOwnProperty("identifier")) {
            return SystemUI{
                msg_obj["eventType"].as<std::string>(),
                msg_obj["identifier"].as<std::string>()
            };
        }
    }
    
    return std::nullopt;
}

val cmd_to_js(const Cmd& cmd) {
    if (std::holds_alternative<CmdNone>(cmd)) {
        return val::null();
    } else if (std::holds_alternative<CmdSend>(cmd)) {
        auto& send = std::get<CmdSend>(cmd);
        val obj = val::object();
        obj.set("type", "Send");
        obj.set("destination_pid", send.destination_pid);
        obj.set("message", send.message);
        return obj;
    }
    val::global("console").call<void>("log", 
        std::string("[cpp_counter] Failed to convert Cmd to a JS value"));
    return val::null();
}

val output_to_js(const Output& output) {
    val obj = val::object();
    obj.set("model", output.model);
    obj.set("cmd", cmd_to_js(output.cmd));
    return obj;
}

std::pair<Model, Cmd> on_msg_impl(const Msg& msg, Model model) {
    if (std::holds_alternative<Increment>(msg)) {
        Model new_model = model + 1;
        return {new_model, CmdNone{}};
    } 
    else if (std::holds_alternative<Decrement>(msg)) {
        Model new_model = model - 1;
        return {new_model, CmdNone{}};
    }
    else if (std::holds_alternative<PokePID0>(msg)) {
        Cmd cmd = CmdSend{
            0,
            msg_to_js(Decrement{})
        };
        return {model, cmd};
    }
    else if (std::holds_alternative<SystemUI>(msg)) {
        auto& ui = std::get<SystemUI>(msg);
        if (ui.eventType == "click") {
            if (ui.identifier == "increment") {
                return on_msg_impl(Increment{}, model);
            } else if (ui.identifier == "decrement") {
                return on_msg_impl(Decrement{}, model);
            } else if (ui.identifier == "poke-pid-0") {
                return on_msg_impl(PokePID0{}, model);
            } else {
                val::global("console").call<void>("log", 
                    std::string("[cpp_counter] Unknown identifier: ") + ui.identifier);
            }
        }
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

val view(Model model) {
    auto ui = json_ui_column({
        json_ui_row_centered({
            json_ui_button("-", "decrement"),
            json_ui_text(std::to_string(model)),
            json_ui_button("+", "increment")
        }),
        json_ui_row_centered({
            json_ui_button("Poke PID 0", "poke-pid-0")
        })
    });
    
    val result = val::object();
    result.set("title", "C++ Counter");
    result.set("body", json_ui_to_js(ui));
    return result;
}

EMSCRIPTEN_BINDINGS(counter) {
    function("on_init", &on_init);
    function("on_msg", &on_msg);
    function("view", &view);
}

