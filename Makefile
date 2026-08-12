SHELL := /bin/bash
CXX = g++
CXXFLAGS = -g -std=c++14 -Wall -Werror=return-type -Werror=uninitialized -Wno-sign-compare
RM = rm -rf

SRCS = $(wildcard *.cpp)
HEADERS = $(wildcard *.hpp)
OBJECTS = $(SRCS:%.cpp=%.o)

CATCH = test/catch/catch.o
TESTS = test-1-node test-2-touch-mkdir test-3-cd-mv test-4-rm

all: main $(TESTS)

main: $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $@ $^

test-all: $(TESTS)

test/catch/catch.o: test/catch/catch.cpp
	$(CXX) $(CXXFLAGS) -o $@ -c $<

%.o: %.cpp $(HEADERS)
	$(CXX) $(CXXFLAGS) -o $@ -c $<

test-1-node: test/test-1-node.o node.o $(CATCH)
	$(CXX) $(CXXFLAGS) -o $@ $^
	./$@ --success

test-2-touch-mkdir: test/test-2-touch-mkdir.o filesystem.o node.o $(CATCH)
	$(CXX) $(CXXFLAGS) -o $@ $^
	./$@ --success

test-3-cd-mv: test/test-3-cd-mv.o filesystem.o node.o $(CATCH)
	$(CXX) $(CXXFLAGS) -o $@ $^
	./$@ --success

test-4-rm: test/test-4-rm.o filesystem.o node.o $(CATCH)
	$(CXX) $(CXXFLAGS) -o $@ $^
	./$@ --success

test-run: main
	echo -e "ls\ntouch foo\nmkdir bar\ntouch foo\ncd bar\ntouch baz\ncd ..\nls\nexit\n" | ./main

test-mem1: test-1-node
	valgrind --error-exitcode=1 --leak-check=full ./test-1-node

test-mem2: test-2-touch-mkdir
	valgrind --error-exitcode=1 --leak-check=full ./test-2-touch-mkdir

test-mem: test-mem1 test-mem2

clean:
	$(RM) *.o *.gc* test/*.o test/*.gc* *.dSYM $(TESTS) main $(CATCH)

.PHONY: all main test-all test-run test-mem1 test-mem2 test-mem clean test-1-node test-2-touch-mkdir test-3-cd-mv test-4-rm
