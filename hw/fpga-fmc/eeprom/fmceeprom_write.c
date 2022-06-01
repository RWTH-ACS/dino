#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <linux/i2c-dev.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>

#define I2C_ADDRESS 0x50

#define I2C_BUS_DEV "/dev/i2c-15"

#define EEPROM_SIZE 256
#define EEPROM_PAGESIZE 16
#define EEPROM_PAGES (EEPROM_SIZE / EEPROM_PAGESIZE)

int main(int argc, const char *argv[])
{
	int addr = 0x00;
	unsigned char *buf;
	struct stat filestat;
	size_t rw_cnt = 0;
	size_t rw_ret = 0;
	char *page_msg;
	int fd_i2c, fd_file;

	if (argc != 2) {
		fprintf(stderr, "wrong number of args. usage: %s [filename]\n", argv[0]);
		return 1;
	}

	if (stat(argv[1], &filestat) != 0) {
		fprintf(stderr, "cannot stat %s\n", argv[1]);
		return 1;
	}

	if (filestat.st_size > EEPROM_SIZE) {
		fprintf(stderr, "file to large for eeprom\n");
		return 1;
	}

	printf("writing file %s (size: %ld) to eeprom connect to %s at %x\n", argv[1], filestat.st_size, I2C_BUS_DEV, I2C_ADDRESS);

	if ((fd_i2c = open(I2C_BUS_DEV, O_RDWR)) < 0) {
		fprintf(stderr, "failed to open %s\n", I2C_BUS_DEV);
		return 1;
	}

	if ((fd_file = open(argv[1], O_RDONLY)) < 0) {
		fprintf(stderr, "failed to open %s\n", argv[1]);
		close(fd_i2c);
		return 1;
	}

	if (ioctl(fd_i2c, I2C_SLAVE, I2C_ADDRESS) < 0) {
		fprintf(stderr, "ioctl error\n");
		close(fd_i2c);
		close(fd_file);
		return 1;
	}

	//Reserve memory for eeprom + address bytes
	if ((buf = calloc (EEPROM_SIZE+EEPROM_PAGES,1)) == NULL) {
		fprintf(stderr, "malloc failed\n");
		close(fd_i2c);
		close(fd_file);
		return 1;
	}

	for (size_t i=0; i < EEPROM_PAGES; ++i) {
		page_msg = buf+i*(EEPROM_PAGESIZE+1);
		//address byte
		page_msg[0] = i*EEPROM_PAGESIZE;

		if (rw_cnt < filestat.st_size) {
			if ((rw_ret = read(fd_file, page_msg+1, EEPROM_PAGESIZE)) < 0) {
				fprintf(stderr, "error reading from file\n");
				close(fd_i2c);
				close(fd_file);
				return 1;
			} else if (rw_ret != EEPROM_PAGESIZE) {
				memset(page_msg+1+rw_ret, 0x00, EEPROM_PAGESIZE-rw_ret);
			}
			rw_cnt += rw_ret;
		} else {
			memset(page_msg+1, 0x00, EEPROM_PAGESIZE);
		} 
	}

	close(fd_file);

	for (int i = 0; i < EEPROM_SIZE+EEPROM_PAGES; ++i) {
		printf("%02x ", buf[i]);
		if (i % (EEPROM_PAGESIZE+1) == EEPROM_PAGESIZE) printf("\n");
	}
	printf("\n");

	printf("writing to eeprom...\n");
	rw_cnt = 0;

	for (size_t i=0; i < EEPROM_PAGES; ++i) {
		page_msg = buf+i*(EEPROM_PAGESIZE+1);
		if ((rw_ret = write(fd_i2c, page_msg, EEPROM_PAGESIZE+1)) != EEPROM_PAGESIZE+1) {
			printf("Failed to write buffer: %ld\n", rw_ret);
			close(fd_i2c);
			return 1;
		}
		for (int i = 0; i < EEPROM_PAGESIZE+1; ++i) {
			printf("%02x ", page_msg[i]);
		} printf("\n");

		// Pause 10 milliseconds, give the EEPROM some time to complete the write cycle
		usleep(10000);
	}

	// Write memory address again
	write(fd_i2c, buf, 1);

	// Read 128 bytes
	if ((rw_cnt = read(fd_i2c, buf, EEPROM_SIZE)) != EEPROM_SIZE) {
		fprintf(stderr, "error reading back eeprom\n");
		return 1;
	} else {
		printf("read back %zd bytes:\n", rw_cnt);
	}
	// Close I2C communication
	close(fd_i2c);

	for (int i = 0; i < EEPROM_SIZE; ++i) {
		printf("%02x ", buf[i]);
		if (i % (EEPROM_PAGESIZE) == EEPROM_PAGESIZE-1) printf("\n");
	}
	printf("\n");

}


