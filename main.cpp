#include <cpptemplate/cpptemplate.hpp>
#include <iostream>

int main() {
  std::cout << "Hello, Worldzzz!" << std::endl;
  cpptemplate::say_hello();
  std::cout << "1 + 68 = " << cpptemplate::add_one(68) << std::endl;
  return 0;
}
