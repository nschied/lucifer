.POSIX:
.SUFFIXES:
FC      = gfortran
FFLAGS  = -O3 -ffast-math
AR      = ar
ARFLAGS = rcs
TARGET  = liblucifer.a
SRC	= src/a2hex.f src/cipher.f src/compress.f src/expand.f src/hex2a.f src/lucifer.f
OBJ     = a2hex.o cipher.o compress.o expand.o hex2a.o lucifer.o
TEST    = ./test/luctest.exe
LIBPY   = ./libpy
LIBF    = ./libf77

.PHONY: all clean test

all:	$(TARGET) $(TEST) py
#all: $(TARGET)
#test: $(TEST)

$(TARGET):
	$(FC) $(FFLAGS) -c $(SRC)
	$(AR) $(ARFLAGS) $(TARGET) $(OBJ)
	if [ -e $(LIBF) ]; then rm -rf $(LIBF); mkdir $(LIBF); mv $(TARGET) $(LIBF); fi 
	rm -f *.o
	
$(TEST): $(TARGET)
	$(FC) $(FFLAGS) -o $(TEST) test/luctest.f $(LIBF)/$(TARGET)

py:
	f2py -c $(SRC) -m lucipy
	if [ -e $(LIBPY) ]; then rm -rf $(LIBPY); mkdir $(LIBPY); mv lucipy*.so $(LIBPY); fi	 	

clean: 
	if [ `ls -1 *.o 2>/dev/null | wc -l` -gt 0 ]; then rm *.o; fi

cleanall:
	if [ `ls -1 *.o 2>/dev/null | wc -l` -gt 0 ]; then rm *.o; fi
	if [ -e $(TARGET) ]; then rm $(TARGET); fi
	if [ -e $(TEST) ]; then rm $(TEST); fi
	if [ -e *.so ]; then rm *.so; fi	
