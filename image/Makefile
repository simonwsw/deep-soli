CC=c++

# c flags
CFLAGS=-c -Wall -std=c++11 -O3
CFLAGS_BOOST=-DBOOST_SYSTEM_NO_DEPRECATED
CFLAGS_CV=`pkg-config --cflags opencv`
CFLAGS_H5=-I/usr/include -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE \
-D_BSD_SOURCE -D_FORTIFY_SOURCE=2 -g -fstack-protector \
--param=ssp-buffer-size=4 -Wformat -Werror=format-security

# linking flags
LDFLAGS_BOOST=-lboost_system -lboost_program_options
LDFLAGS_H5=-lhdf5 -lhdf5_cpp
LDFLAGS_CV=-L/usr/local/cuda-7.5/lib64 `pkg-config --libs opencv`

BIN=bin
SOURCES=$(wildcard *.cpp)
OBJECTS=$(patsubst %.cpp, %.o, $(SOURCES))
EXECUTABLE=$(BIN)/image

all: $(SOURCES) $(EXECUTABLE)

$(BIN)/image: $(BIN)/main.o $(BIN)/h5Data.o $(BIN)/seq.o
	$(CC) $(BIN)/main.o $(BIN)/h5Data.o $(BIN)/seq.o \
	$(LDFLAGS_BOOST) $(LDFLAGS_H5) $(LDFLAGS_CV) -o $@

$(BIN)/main.o: main.cpp
	$(CC) $(CFLAGS) $(CFLAGS_BOOST) $< -o $@

$(BIN)/h5Data.o: h5Data.cpp
	$(CC) $(CFLAGS) $(CFLAGS_H5) $< -o $@

$(BIN)/seq.o: seq.cpp
	$(CC) $(CFLAGS) $(CFLAGS_CV) $< -o $@

clean:
	rm -r -f $(BIN)/*
