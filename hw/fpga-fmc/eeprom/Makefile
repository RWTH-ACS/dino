PREFIX ?= /usr

DESTDIR=$(PREFIX)

BIN=fmceeprom_write
FRU_GEN=fru-generator.py

CFLAGS+= -std=gnu99 -O2 

.PHONY: all clean install

ALL:
	$(CC) $(CFLAGS) $(BUILD_FLAGS) fmceeprom_write.c -o ${BIN}

install:
	install -d $(DESTDIR)/bin
	install -m 0755 ./${BIN} $(DESTDIR)/bin/
	install -m 0755 ./${FRU_GEN} $(DESTDIR)/bin/fmc

clean:
	rm -f ${BIN} *.o
