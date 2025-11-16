#ifndef JSON_UI_H
#define JSON_UI_H

#include <emscripten/val.h>
#include <variant>
#include <string>
#include <memory>
#include <vector>
#include <map>

using namespace emscripten;

// JsonUI types
struct JsonUI;

using JsonUIPtr = std::shared_ptr<JsonUI>;
using Attributes = std::map<std::string, std::string>;
using Events = std::vector<std::map<std::string, std::string>>;

struct JsonUIRow {
    Attributes attributes;
    std::vector<JsonUIPtr> children;
    Events events;
};

struct JsonUIColumn {
    Attributes attributes;
    std::vector<JsonUIPtr> children;
    Events events;
};

struct JsonUIText {
    Attributes attributes;
    std::string content;
};

struct JsonUIButton {
    Attributes attributes;
    std::string content;
    std::vector<JsonUIPtr> children;
    Events events;
};

using JsonUIVariant = std::variant<JsonUIRow, JsonUIColumn, JsonUIText, JsonUIButton>;

struct JsonUI {
    JsonUIVariant data;
    
    explicit JsonUI(JsonUIVariant d) : data(std::move(d)) {}
};

// JsonUI helper functions
JsonUIPtr json_ui_row(std::vector<JsonUIPtr> children) {
    return std::make_shared<JsonUI>(JsonUIRow{
        Attributes{
            {"gap", "8px"}
        },
        std::move(children),
        Events{}
    });
}

JsonUIPtr json_ui_row_centered(std::vector<JsonUIPtr> children) {
    return std::make_shared<JsonUI>(JsonUIRow{
        Attributes{
            {"justify-content", "center"},
            {"align-items", "center"},
            {"gap", "8px"}
        },
        std::move(children),
        Events{}
    });
}

JsonUIPtr json_ui_column(std::vector<JsonUIPtr> children) {
    return std::make_shared<JsonUI>(JsonUIColumn{
        Attributes{
            {"gap", "8px"}
        },
        std::move(children),
        Events{}
    });
}

JsonUIPtr json_ui_text(std::string content) {
    return std::make_shared<JsonUI>(JsonUIText{
        Attributes{},
        std::move(content)
    });
}

JsonUIPtr json_ui_button(std::string content, std::string click_event_id) {
    Events events;
    std::map<std::string, std::string> event_map;
    event_map["click"] = std::move(click_event_id);
    events.push_back(std::move(event_map));
    
    return std::make_shared<JsonUI>(JsonUIButton{
        Attributes{},
        std::move(content),
        std::vector<JsonUIPtr>{},
        std::move(events)
    });
}

// Convert JsonUI to JavaScript value
val json_ui_to_js(const JsonUIPtr& ui);

val json_ui_to_js_impl(const JsonUIVariant& variant) {
    val obj = val::object();
    
    if (std::holds_alternative<JsonUIRow>(variant)) {
        auto& row = std::get<JsonUIRow>(variant);
        obj.set("type", "row");
        
        if (!row.attributes.empty()) {
            val attrs = val::object();
            for (const auto& [key, value] : row.attributes) {
                attrs.set(key, value);
            }
            obj.set("attributes", attrs);
        }
        
        if (!row.children.empty()) {
            val children = val::array();
            for (size_t i = 0; i < row.children.size(); ++i) {
                children.set(i, json_ui_to_js(row.children[i]));
            }
            obj.set("children", children);
        }
        
        if (!row.events.empty()) {
            val events = val::array();
            for (size_t i = 0; i < row.events.size(); ++i) {
                val event = val::object();
                for (const auto& [key, value] : row.events[i]) {
                    event.set(key, value);
                }
                events.set(i, event);
            }
            obj.set("events", events);
        }
    }
    else if (std::holds_alternative<JsonUIColumn>(variant)) {
        auto& col = std::get<JsonUIColumn>(variant);
        obj.set("type", "column");
        
        if (!col.attributes.empty()) {
            val attrs = val::object();
            for (const auto& [key, value] : col.attributes) {
                attrs.set(key, value);
            }
            obj.set("attributes", attrs);
        }
        
        if (!col.children.empty()) {
            val children = val::array();
            for (size_t i = 0; i < col.children.size(); ++i) {
                children.set(i, json_ui_to_js(col.children[i]));
            }
            obj.set("children", children);
        }
        
        if (!col.events.empty()) {
            val events = val::array();
            for (size_t i = 0; i < col.events.size(); ++i) {
                val event = val::object();
                for (const auto& [key, value] : col.events[i]) {
                    event.set(key, value);
                }
                events.set(i, event);
            }
            obj.set("events", events);
        }
    }
    else if (std::holds_alternative<JsonUIText>(variant)) {
        auto& text = std::get<JsonUIText>(variant);
        obj.set("type", "text");
        
        if (!text.attributes.empty()) {
            val attrs = val::object();
            for (const auto& [key, value] : text.attributes) {
                attrs.set(key, value);
            }
            obj.set("attributes", attrs);
        }
        
        obj.set("content", text.content);
    }
    else if (std::holds_alternative<JsonUIButton>(variant)) {
        auto& button = std::get<JsonUIButton>(variant);
        obj.set("type", "button");
        
        if (!button.attributes.empty()) {
            val attrs = val::object();
            for (const auto& [key, value] : button.attributes) {
                attrs.set(key, value);
            }
            obj.set("attributes", attrs);
        }
        
        if (!button.content.empty()) {
            obj.set("content", button.content);
        }
        
        if (!button.children.empty()) {
            val children = val::array();
            for (size_t i = 0; i < button.children.size(); ++i) {
                children.set(i, json_ui_to_js(button.children[i]));
            }
            obj.set("children", children);
        }
        
        if (!button.events.empty()) {
            val events = val::array();
            for (size_t i = 0; i < button.events.size(); ++i) {
                val event = val::object();
                for (const auto& [key, value] : button.events[i]) {
                    event.set(key, value);
                }
                events.set(i, event);
            }
            obj.set("events", events);
        }
    }
    
    return obj;
}

val json_ui_to_js(const JsonUIPtr& ui) {
    return json_ui_to_js_impl(ui->data);
}

#endif // JSON_UI_H

