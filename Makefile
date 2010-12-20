OUTPUT := dinobones.swf

ifdef DEBUG
DEBUG_FLAG := true
else
DEBUG_FLAG := false
endif

all: BoneGraphics.as
	fcsh-wrap -optimize=true -output $(OUTPUT) -use-network -static-link-runtime-shared-libraries=true -compatibility-version=3.0.0 --target-player=10.0.0 -compiler.debug=$(DEBUG_FLAG) Preloader.as -frames.frame mainframe Main

BoneGraphics.as: images/bones images/bones/bonus images/mkbones.sh
	cd images && sh mkbones.sh > ../BoneGraphics.as

clean:
	rm -f *~ $(OUTPUT) .FW.*

.PHONY: all clean


