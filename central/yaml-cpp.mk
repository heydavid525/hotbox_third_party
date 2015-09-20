# Makefile for yaml-cpp-0.5.1. Why use cmake?
# NOTE: requires two parameters: 1) BOOST_PREFIX, 2) TARGET (some .so)
# Author: Xun Zheng (xunzheng@cs.cmu.edu)

CXX = g++
CXXFLAGS = -O2 -Wextra -fPIC
INCFLAGS = -I ./include -I $(BOOST_PREFIX)/include

SRC = $(shell find src/ -type f -name *.cpp)
OBJ = $(SRC:.cpp=.cpp.o)

$(TARGET): $(OBJ)
	$(CXX) $(CXXFLAGS) -shared -o $@ $^
#ar csrv $@ $^

$(OBJ): %.cpp.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INCFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(TARGET)
