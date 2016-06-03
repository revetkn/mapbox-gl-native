export BUILDTYPE ?= Debug

ifeq ($(shell uname -s), Darwin)
  HOST_PLATFORM = osx
  export JOBS ?= $(shell sysctl -n hw.ncpu)
else ifeq ($(shell uname -s), Linux)
  HOST_PLATFORM = linux
  export JOBS ?= $(shell grep --count processor /proc/cpuinfo)
else
  $(error Cannot determine host platform)
endif

default:

.PHONY: xproj
xproj: OSX_WORK_PATH = platform/osx/osx.xcworkspace
xproj: OSX_USER_DATA_PATH = $(OSX_WORK_PATH)/xcuserdata/$(USER).xcuserdatad
xproj:
	@mkdir -p "$(OSX_USER_DATA_PATH)"
	@cp platform/osx/WorkspaceSettings.xcsettings "$(OSX_USER_DATA_PATH)/WorkspaceSettings.xcsettings"
	@mkdir -p platform/osx/cmake
	@(cd platform/osx/cmake && cmake -G Xcode ../../..)
	@open platform/osx/osx.xcworkspace

.PHONY: clean
clean:
	rm -rf platform/osx/cmake
