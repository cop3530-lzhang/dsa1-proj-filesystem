SHELL=/bin/bash
CXX = g++
CXXFLAGS = -g -std=c++14 -Wall -Wall -Werror=return-type  \
			-Werror=uninitialized -Wno-sign-compare

SRCS = $(wildcard *.cpp)
HEADERS = $(wildcard *.hpp)
OBJECTS = $(SRCS:%.cpp=%.o)

CATCH = test/catch/catch.o
TEST_SRCS = $(wildcard test/*.cpp)
TESTS = $(TEST_SRCS:test/%.cpp=%)

main: $(OBJECTS)
	$(CXX) -o $@ $^

clean:
	$(RM) *.o *.gc* test/*.o test/*.gc* *.dSYM $(TESTS) main $(CATCH)

test-all: $(TESTS)

%.o: %.cpp $(HEADERS)
	$(CXX) $(CXXFLAGS) -o $@ -c $<

test-1-node: test/test-1-node.o node.o
test-2-touch-mkdir: test/test-2-touch-mkdir.o filesystem.o node.o
test-3-cd-mv: test/test-3-cd-mv.o filesystem.o node.o
test-4-rm: test/test-4-rm.o filesystem.o node.o

$(TESTS): $(CATCH)
	$(CXX) $(CXXFLAGS) -o $@ $^
	./$@ --success

test-run: main
	echo -e "ls\ntouch foo\nmkdir bar\ntouch foo\ncd bar\ntouch baz\ncd ..\nls\nexit\n" | ./main

test-mem1: test-1-node
	valgrind --error-exitcode=1 --leak-check=full ./test-1-node

test-mem2: test-2-touch-mkdir
	valgrind --error-exitcode=1 --leak-check=full ./test-2-touch-mkdir
