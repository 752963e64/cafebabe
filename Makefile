#
# While following https://github.com/littleosbook/littleosbook/
#

CC = gcc
AS = nasm
ASFLAGS = -f elf32 -Wall
LDFLAGS = -T link.ld -melf_i386 -z noexecstack -s
CFLAGS = -v -m32 -Os -march=i486 -std=c89 -nostdlib -nostdinc -fno-builtin -fno-stack-protector \
		 -nostartfiles -nodefaultlibs -Wall -Wextra -Werror -fomit-frame-pointer \
		 -Wno-unused-function -s -c

OBJECTS = loader.o sum.o


all: minux


%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@


%.o: %.c
	$(CC) $(CFLAGS) $< -o $@


minux: $(OBJECTS)
	ld $(LDFLAGS) $(OBJECTS) -o iso/boot/minux


iso: iso/boot/minux
	genisoimage							\
		-R                              \
        -b boot/grub/stage2_eltorito    \
		-no-emul-boot                   \
		-boot-load-size 4               \
		-A os                           \
		-input-charset utf8             \
		-quiet                          \
		-boot-info-table                \
		-o minux.iso                    \
		iso


clean:
	rm -rf *.o minux.iso iso/boot/minux

