TARGET = SimpleProject

clean:
	rm -rf build

build:
	mkdir -p build
	cd build && cmake .. && make

run: build
	./build/$(TARGET)

