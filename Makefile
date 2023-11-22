CC := gcc
DRIVER_FLAGS := -O3 -march=native
CC_FLAGS := -O3 -Wall -Werror -fPIC -shared
LIBINCLUDE := -Iinclude/
DRIVERINCLUDE := -Itest/
TEST_FLAGS := -O0 -fPIC -shared

DRIVERSRC := $(wildcard *.c)
DRIVEROBJ := $(patsubst %.c, %.o, $(DRIVERSRC))
DRIVER := driver

LIB := $(wildcard lib/*.c)
LIBOBJ := $(patsubst %.c, %.o, $(LIB))
LIB := libframe.so

TEST := $(wildcard test/*.c)
TESTOBJ := $(patsubst %.c, %.o, $(TEST))
TESTLIB := libtestfunc.so

.PHONE: all clean

all: $(DRIVER)

$(DRIVER): $(LIB) $(TESTLIB) $(DRIVEROBJ)
	$(CC) $(DRIVER_FLAGS) $(LIBINCLUDE) $(DRIVERINCLUDE) -o $@ $^ -L. -ltestfunc -lframe

$(DRIVEROBJ): %.o:%.c
	$(CC) $(DRIVER_FLAGS) $(LIBINCLUDE) $(DRIVERINCLUDE) -c $< -o $@

$(LIB): $(LIBOBJ)
	$(CC) $(CC_FLAGS) $(LIBINCLUDE) -o $@ $^

$(LIBOBJ): %.o:%.c
	$(CC) $(CC_FLAGS) $(LIBINCLUDE) -c $< -o $@

$(TESTLIB): $(TESTOBJ)
	$(CC) $(TEST_FLAGS) -o $@ $^

$(TESTOBJ): %.o:%.c
	$(CC) $(TEST_FLAGS) -c $< -o $@

clean: 
	rm -rf $(DRIVER)
	rm -rf $(DRIVEROBJ)
	rm -rf $(LIB)
	rm -rf $(LIBOBJ)
	rm -rf $(TESTLIB)
	rm -rf $(TESTOBJ)