# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.5

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /opt/local/bin/cmake

# The command to remove a file.
RM = /opt/local/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/dani11/Dropbox/prog/progC/Cpp/LibSRM-master/libsrm

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/dani11/Dropbox/prog/progC/Cpp/LibSRM-master/libsrm

# Include any dependencies generated for this target.
include CMakeFiles/srm_test.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/srm_test.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/srm_test.dir/flags.make

CMakeFiles/srm_test.dir/srm_test.cpp.o: CMakeFiles/srm_test.dir/flags.make
CMakeFiles/srm_test.dir/srm_test.cpp.o: srm_test.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/dani11/Dropbox/prog/progC/Cpp/LibSRM-master/libsrm/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/srm_test.dir/srm_test.cpp.o"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/srm_test.dir/srm_test.cpp.o -c /Users/dani11/Dropbox/prog/progC/Cpp/LibSRM-master/libsrm/srm_test.cpp

CMakeFiles/srm_test.dir/srm_test.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/srm_test.dir/srm_test.cpp.i"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/dani11/Dropbox/prog/progC/Cpp/LibSRM-master/libsrm/srm_test.cpp > CMakeFiles/srm_test.dir/srm_test.cpp.i

CMakeFiles/srm_test.dir/srm_test.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/srm_test.dir/srm_test.cpp.s"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/dani11/Dropbox/prog/progC/Cpp/LibSRM-master/libsrm/srm_test.cpp -o CMakeFiles/srm_test.dir/srm_test.cpp.s

CMakeFiles/srm_test.dir/srm_test.cpp.o.requires:

.PHONY : CMakeFiles/srm_test.dir/srm_test.cpp.o.requires

CMakeFiles/srm_test.dir/srm_test.cpp.o.provides: CMakeFiles/srm_test.dir/srm_test.cpp.o.requires
	$(MAKE) -f CMakeFiles/srm_test.dir/build.make CMakeFiles/srm_test.dir/srm_test.cpp.o.provides.build
.PHONY : CMakeFiles/srm_test.dir/srm_test.cpp.o.provides

CMakeFiles/srm_test.dir/srm_test.cpp.o.provides.build: CMakeFiles/srm_test.dir/srm_test.cpp.o


# Object files for target srm_test
srm_test_OBJECTS = \
"CMakeFiles/srm_test.dir/srm_test.cpp.o"

# External object files for target srm_test
srm_test_EXTERNAL_OBJECTS =

srm_test: CMakeFiles/srm_test.dir/srm_test.cpp.o
srm_test: CMakeFiles/srm_test.dir/build.make
srm_test: libsrm.dylib
srm_test: CMakeFiles/srm_test.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/dani11/Dropbox/prog/progC/Cpp/LibSRM-master/libsrm/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable srm_test"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/srm_test.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/srm_test.dir/build: srm_test

.PHONY : CMakeFiles/srm_test.dir/build

CMakeFiles/srm_test.dir/requires: CMakeFiles/srm_test.dir/srm_test.cpp.o.requires

.PHONY : CMakeFiles/srm_test.dir/requires

CMakeFiles/srm_test.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/srm_test.dir/cmake_clean.cmake
.PHONY : CMakeFiles/srm_test.dir/clean

CMakeFiles/srm_test.dir/depend:
	cd /Users/dani11/Dropbox/prog/progC/Cpp/LibSRM-master/libsrm && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/dani11/Dropbox/prog/progC/Cpp/LibSRM-master/libsrm /Users/dani11/Dropbox/prog/progC/Cpp/LibSRM-master/libsrm /Users/dani11/Dropbox/prog/progC/Cpp/LibSRM-master/libsrm /Users/dani11/Dropbox/prog/progC/Cpp/LibSRM-master/libsrm /Users/dani11/Dropbox/prog/progC/Cpp/LibSRM-master/libsrm/CMakeFiles/srm_test.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/srm_test.dir/depend
