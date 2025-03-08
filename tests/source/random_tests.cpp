#include <doctest/doctest.h>

#include <cpptemplate/cpptemplate.hpp>

TEST_CASE("One is One") {
  CHECK_EQ(1, 1);
}

TEST_CASE("One plus One is Two") {
  CHECK_EQ(cpptemplate::add_one(1), 2);
}

