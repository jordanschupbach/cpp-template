TARGET = cpptemplate

build-run:
	mkdir -p build
	cd build && cmake  .. --preset=debug && make -C debug
	./build/debug/$(TARGET)

run: build
	./build/debug/$(TARGET)

clean:
	rm -rf build

build:
	mkdir -p build
	cd build && cmake  .. --preset=debug && make -C debug


