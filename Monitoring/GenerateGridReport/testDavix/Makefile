#the compiler to use
CC=g++ -lTree

#option I will pass to the compiler
CFLAGS=-c #-W -Wall -Wextra -pedantic

#libraries
LIBS=

#LDFLAGS ??????
LDFLAGS=`root-config --cflags --glibs`
#LDFLAGS=`root-config --cflags --glibs -L$(ROOTSYS)/lib -lTree`

#sources used
SOURCES=main.C 

#definition of the objects
OBJECTS=$(SOURCES:.C=.o)

#nameof executable
EXEC=main


all: $(SOURCES) $(EXEC)
	
$(EXEC): $(OBJECTS)
	$(CC)  $(OBJECTS) -o $(EXEC)  $(LDFLAGS)

.C.o:
	$(CC) $(CFLAGS) $(LDFLAGS) $< -o  $@

clean:
	rm -rf *.o *.so *.d main

