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

screencast.gif: screencast.mp4
	ffmpeg -i screencast.mp4 -vf "fps=10,scale=iw/2:ih/2:flags=lanczos,palettegen=max_colors=256" -y palette.png && ffmpeg -i screencast.mp4 -i palette.png -filter_complex "fps=10,scale=iw/2:ih/2:flags=lanczos[x];[x][1:v]paletteuse" -y screencast.gif && rm palette.png


.PHONY: elm_renderer elm_book hot processes rust_counter cpp_counter screencast.gif