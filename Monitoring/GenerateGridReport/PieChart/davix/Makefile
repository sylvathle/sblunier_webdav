
ROOTCFLAGS=$(shell root-config --cflags)
ROOTLIBS=$(shell root-config --libs) #-ldavix
ROOTGLIBS=$(shell root-config --glibs)

CXX=g++
CXXFLAGS=-I$(ROOTSYS)/include -O -Wall -fPIC
LD= g++
LDFLAGS=-g
SOFLAGS=-shared

CXXFLAGS+=$(ROOTCFLAGS)
LIBS=$(ROOTLIBS)
GLIBS=$(ROOTGLIBS)

#TARGET_SOURCES = main.C
#TEST_SOURCE = test.C
#TARGET_OBJECTS = $(TARGET_SOURCES:.C=.o)
#TEST_OBJECTS = $(TEST_SOURCES:.C=.o)
#EXECUTABLE = main
#TEST_EXECUTABLE = test


#.PHONY: all target tests

#all: target tests

OBJS = main.o

main: $(OBJS)
	$(CXX) -o $@ $(OBJS) $(CXXFLAGS) $(LIBS)

# suffix rule
.cc.o:
	$(CXX) -c $(CXXFLAGS) $(GDBFLAGS) $<

# clean
clean:
	rm -f *~ *.o *.o~ core main
