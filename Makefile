.PHONY: docs

TARGET = cpptemplate

build-run:
	mkdir -p build
	cd build && cmake  .. --preset=debug -DCMAKE_INSTALL_PREFIX=/usr && make -C debug
	./build/debug/$(TARGET)

run: build
	./build/debug/$(TARGET)

clean:
	rm -rf build

build:
	mkdir -p build
	cd build && cmake  .. --preset=debug && make -C debug

build-release:
	mkdir -p build
	cd build && cmake  .. --preset=release && make -C release

install: build-release
	cd build/release && make install

archlinux-build-release:
	mkdir -p build
	cd build && cmake  .. --preset=release -DCMAKE_INSTALL_PREFIX=/usr && make -C release

archlinux-install: archlinux-build-release
	cd build/release && make install

test:
	cd build && cmake ../tests -B ./debug/tests --preset=debug && make -C debug/tests
	./build/debug/tests/cpptemplateTests

docs:
	cd build && cmake -S ../docs -B debug/docs --preset=debug && cmake --build debug/docs --target GenerateDocs

# TODO: Add test-installed target
# test-installed: install

