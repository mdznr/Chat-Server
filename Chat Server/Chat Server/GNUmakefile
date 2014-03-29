GNUSTEP_MAKEFILES=/usr/share/GNUstep/Makefiles

include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME = chatserver
chatserver_OBJC_PRECOMPILED_HEADERS = Chat\ Server-Prefix.pch 
chatserver_OBJC_FILES = main.m ArrayHelper.m CommandLineArguments.m CSUser.m CSUserUniverse.m Options.m RequestHandling.m

include $(GNUSTEP_MAKEFILES)/tool.make

ADDITIONAL_OBJCFLAGS += -include Chat\ Server-Prefix.pch -Winvalid-pch
ADDITIONAL_FLAGS += -Wno-unknown-pragmas -std=c99
