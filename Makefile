.POSIX:
.SUFFIXES:

FC      = gfortran
FFLAGS  = -O3 -ffast-math
AR      = ar
ARFLAGS = rcs
TARGET  = liblucifer.a
OBJ     = a2hex.o cipher.o compress.o expand.o hex2a.o lucifer.o
TEST    = luctest

.PHONY: all clean test

all: $(TARGET)
test: $(TEST)

$(TARGET):
	$(FC) $(FFLAGS) -c src/a2hex.f src/cipher.f src/compress.f src/expand.f src/hex2a.f src/lucifer.f
	$(AR) $(ARFLAGS) $(TARGET) $(OBJ)

$(TEST): $(TARGET)
	$(FC) $(FFLAGS) -o $(TEST) test/luctest.f $(TARGET)

clean:
	if [ `ls -1 *.o 2>/dev/null | wc -l` -gt 0 ]; then rm *.o; fi
	if [ -e $(TARGET) ]; then rm $(TARGET); fi
	if [ -e $(TEST) ]; then rm $(TEST); fi
