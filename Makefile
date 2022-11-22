CC = cc
AR = ar
RANLIB = ranlib
RM = rm -rf
CP = cp -p

SRCDIR = ./src
INCDIR = ./inc
BINDIR = ./bin

LIB=libtemplate

STATIC = $(LIB).a
SHARED = $(LIB).so.1.2.3
SONAME = $(LIB).so.1
SOFILE = $(LIB).so

OBJS = $(BINDIR)/src_interface.o \
       $(BINDIR)/src1.o          \
       $(BINDIR)/src2.o

CFLAGS_OPTIMIZATION = -g
#CFLAGS_OPTIMIZATION = -O3
CFLAGS_VERSION = -std=c11
CFLAGS_WARNINGS = -Wall -Wextra -Wno-unused-parameter -Wno-unused-but-set-parameter -Wno-unused-result
CFLAGS_DEFINES = -D_XOPEN_SOURCE=700 -D_POSIX_C_SOURCE=200809L -D_POSIX_SOURCE=1 -D_DEFAULT_SOURCE=1 -D_GNU_SOURCE=1
CFLAGS = $(CFLAGS_OPTIMIZATION) $(CFLAGS_VERSION) $(CFLAGS_WARNINGS) $(CFLAGS_DEFINES) -fPIC
LDFLAGS += -shared -Wl,-soname,$(SONAME)

all: clean BUILD_OBJS BUILD_STATIC BUILD_SHARED clean_objs
	@echo "=== Copying lib header ==="
	-$(CP) $(INCDIR)/libtemplate_interface.h $(BINDIR)

BUILD_OBJS:
	@echo "=== Building object files ==="
	$(CC) -c -o$(BINDIR)/src_interface.o $(SRCDIR)/src_interface.c -I$(INCDIR) $(CFLAGS)
	$(CC) -c -o$(BINDIR)/src1.o $(SRCDIR)/src1.c -I$(INCDIR) $(CFLAGS)
	$(CC) -c -o$(BINDIR)/src2.o $(SRCDIR)/src2.c -I$(INCDIR) $(CFLAGS)

BUILD_STATIC:
	@echo "=== Building STATIC lib  ==="
	$(AR) rc $(BINDIR)/$(STATIC) $(OBJS)
	$(RANLIB) $(BINDIR)/$(STATIC)

BUILD_SHARED:
	@echo "=== Building SHARED lib ==="
	$(CC) $(LDFLAGS) -o $(BINDIR)/$(SHARED) $(OBJS)
	ln -sf $(SHARED) $(BINDIR)/$(SOFILE)
	ln -sf $(SHARED) $(BINDIR)/$(SONAME)

clean:
	@echo "=== clean ==="
	-$(RM) $(BINDIR)/$(STATIC) $(BINDIR)/$(SHARED) $(BINDIR)/$(SONAME) $(BINDIR)/$(SOFILE) $(BINDIR)/libtemplate_interface.h $(OBJS)

clean_objs:
	@echo "=== clean object files ==="
	-$(RM) $(OBJS)
