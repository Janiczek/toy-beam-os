elm_renderer:
	elm make src/Main.elm --output dist/elm-renderer.js

elm_book:
	cd book && elm make src/Book.elm --output ../dist/elm-book.js && cd -

hot:
	elm-watch hot

processes: rust_counter cpp_counter

rust_counter:
	cd src/child_processes/rust_counter && wasm-pack build --target web --out-dir ../../../dist/child_processes/rust_counter && cd -

cpp_counter:
	cd src/child_processes/cpp_counter && make && cd -

.PHONY: elm_renderer elm_book hot processes rust_counter cpp_counter