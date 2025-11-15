#![allow(dead_code)]

use serde::Serialize;
use std::collections::HashMap;

#[derive(Debug, Clone, Serialize)]
#[serde(tag = "type", rename_all = "lowercase")]
pub enum JsonUI {
    Row {
        #[serde(skip_serializing_if = "HashMap::is_empty")]
        attributes: HashMap<String, String>,
        #[serde(skip_serializing_if = "Vec::is_empty")]
        children: Vec<JsonUI>,
        #[serde(skip_serializing_if = "Vec::is_empty")]
        events: Vec<HashMap<String, String>>,
    },
    Column {
        #[serde(skip_serializing_if = "HashMap::is_empty")]
        attributes: HashMap<String, String>,
        #[serde(skip_serializing_if = "Vec::is_empty")]
        children: Vec<JsonUI>,
        #[serde(skip_serializing_if = "Vec::is_empty")]
        events: Vec<HashMap<String, String>>,
    },
    Text {
        #[serde(skip_serializing_if = "HashMap::is_empty")]
        attributes: HashMap<String, String>,
        content: String,
    },
    Button {
        #[serde(skip_serializing_if = "HashMap::is_empty")]
        attributes: HashMap<String, String>,
        #[serde(skip_serializing_if = "String::is_empty")]
        content: String,
        #[serde(skip_serializing_if = "Vec::is_empty")]
        children: Vec<JsonUI>,
        #[serde(skip_serializing_if = "Vec::is_empty")]
        events: Vec<HashMap<String, String>>,
    },
}

impl JsonUI {
    pub fn row(children: Vec<JsonUI>) -> Self {
        JsonUI::Row {
            attributes: HashMap::new(),
            children,
            events: Vec::new(),
        }
    }

    pub fn text(content: String) -> Self {
        JsonUI::Text {
            attributes: HashMap::new(),
            content,
        }
    }

    pub fn button(content: String, click_event_id: String) -> Self {
        let mut event_map = HashMap::new();
        event_map.insert("click".to_string(), click_event_id);
        
        JsonUI::Button {
            attributes: HashMap::new(),
            content,
            children: Vec::new(),
            events: vec![event_map],
        }
    }
}

