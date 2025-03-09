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


build-windows:
	cmake -S . -B ./build/debug --preset=win-x64-debug && ninja -C ./build/debug


test-windows:
	cmake -S tests -B ./build/debug/tests --preset=win-x64-debug && ninja -C build/debug/tests
	build/debug/tests/cpptemplateTests



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


# TODO: turn this into cmake module
coverage: test
	mkdir -p build/gcov
	pushd ./build/debug/tests/_deps/cpptemplate-build/CMakeFiles/CPPTemplate.dir/source/cpptemplate/ > /dev/null && \
	find . -type f -name '*.cpp.*' -exec bash -c 'for file; do \
		new_file="$${file/.cpp/}"; \
		if [ "$${file}" != "$${new_file}" ]; then \
			mv "$${file}" "$${new_file}"; \
		fi; \
	done' bash {} + && \
	popd > /dev/null
	find ./build/debug/tests/_deps/cpptemplate-build/CMakeFiles/CPPTemplate.dir/source/cpptemplate/ -type f -name "*.gcda" -exec cp {} ./build/gcov \;
	find ./build/debug/tests/_deps/cpptemplate-build/CMakeFiles/CPPTemplate.dir/source/cpptemplate/ -type f -name "*.gcno" -exec cp {} ./build/gcov \;
	find ./source/ -type f -name "*.cpp" -exec cp {} ./build/gcov \;
	cp ./tests/source/main.cpp ./build/gcov
	cp ./build/debug/tests/CMakeFiles/cpptemplateTests.dir/source/main* ./build/gcov
	pushd build/gcov > /dev/null && \
		gcov -b -o . *.cpp && \
		lcov -c --ignore mismatch --directory . --output-file main_coverage.info && \
		lcov -r main_coverage.info "/usr*" --output-file main_coverage.info && \
		# lcov -r main_coverage.info "doctest/doctest.h" --output-file main_coverage.info && \
		# lcov -r main_coverage.info "Core/" --output-file main_coverage.info && \
		# lcov -r main_coverage.info "include/" --output-file main_coverage.info && \
		# lcov -r main_coverage.info "playground/" --output-file main_coverage.info && \
		genhtml main_coverage.info --output-directory .


flamechart:
	@echo "Running Performance Tests"
	@perf record -F 99 -g ./build/examples/${TARGET}
	@perf script > out.perf
	@if [ ! -d "Flamegraph" ]; then \
		git clone https://github.com/brendangregg/Flamegraph.git; \
	fi
	@./Flamegraph/stackcollapse-perf.pl out.perf > out.folded
	@./Flamegraph/flamegraph.pl out.folded > flamegraph.svg

view-flamechart:
	$(BROWSER) ./flamegraph.svg

# TODO: Add test-installed target
# test-installed: install

