# Platform detection on first run
if (NOT WXBUILD_PLATFORM)

	if (WIN32)

		if (NOT MSVC)
			message(WARNING "No known compiler found, assuming msvc")
		endif ()

		# Native Windows (or Wine?)
		set(_plat "win32")

	elseif (APPLE)

		# OSX (Carbon, Cocoa, iThings)
		set(_plat "osx")

	else ()
		# All other POSIX (incl. Cygwin)
		set(_plat "unix")

	endif ()

	set(WXBUILD_PLATFORM ${_plat} CACHE STRING "Build platform (OS and compiler)")
	message("Using build platform '${WXBUILD_PLATFORM}'")

endif (NOT WXBUILD_PLATFORM)

# Platform-specific defines
if (${WXBUILD_PLATFORM} STREQUAL "win32")

	add_definitions(-DUNICODE -D_UNICODE)
	list(APPEND WXBUILD_PUBLIC_DEFINITIONS UNICODE _UNICODE)

elseif (${WXBUILD_PLATFORM} STREQUAL "unix")

	add_definitions(-D__UNIX__)
	list(APPEND WXBUILD_PUBLIC_DEFINITIONS __UNIX__)

	if (${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
		add_definitions(-D__LINUX__)
		list(APPEND WXBUILD_PUBLIC_DEFINITIONS __LINUX__)
	elseif (${CMAKE_SYSTEM_NAME} STREQUAL "FreeBSD")
		add_definitions(-D__BSD__)
		list(APPEND WXBUILD_PUBLIC_DEFINITIONS __BSD__)
	elseif (CYGWIN)
		add_definitions(-D__CYGWIN__)
		list(APPEND WXBUILD_PUBLIC_DEFINITIONS __CYGWIN__)
	endif ()
	find_package(X11 REQUIRED)

endif ()

# Compiler-specific defines

if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
	# Force Clang into C++11 mode, otherwise build errors because
	# it thinks <type_traits> is usable.  It can't tell the
	# difference between usable and available. C++11 mode
	# makes it usable.
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
endif()


if (MSVC)

	# Microsoft Visual C++
    if(MSVC OR MSVC_IDE)
        if(CMAKE_CL_64)
            set_target_properties(${the_target} PROPERTIES STATIC_LIBRARY_FLAGS "/machine:x64")
            add_definitions(-D_WIN64)
        endif()
      #TODO: add other toolsets, i.e. v110_xp
      if( MSVC_VERSION GREATER 1600 )
        option(WX_USE_XP_TOOLSET "Set ON to use XP toolset" OFF)
        if(WX_USE_XP_TOOLSET)
            set(CMAKE_GENERATOR_TOOLSET "v120_xp" CACHE STRING "Platform Toolset" FORCE)
            add_definitions(-D_USING_V120_SDK71_)
        endif()
      endif()
    endif()

	# __VISUALC__ is actually set directly from within the header files ... sigh, I wish I had seen that before
	# if (NOT WXBUILD_MSVC_COMPILER)
		# set(_comp_ver)
		# set(_comp_label)
		# set(_cmvalues 	MSVC60 	MSVC70 	MSVC71 	MSVC80 	MSVC90 	MSVC10 	MSVC11 	MSVC12)
		# set(_wxvalues 	1200	1300	1310	1400	1500	1600	1700	1800)
		# set(_labels		6		2002	2003	2005	2008	2010	2012	2013)
		# set(i 0)
		# foreach (cmv ${_cmvalues})
			# if (${cmv})
				# list(GET _wxvalues ${i} _comp_ver)
				# list(GET _labels ${i} _comp_label)
			# endif ()
			# math(EXPR i "${i}+1")
		# endforeach()
		# if (_comp_ver)
			# message("Using ${cmv} (VisualStudio ${_comp_label}, compiler version ${_comp_ver})")
		# else ()
			# set(_comp_ver 1800)
			# set(_comp_label "2013")
			# message("WARNING: could not find MSVC compiler version, assuming ${_comp_ver} (VisualStudio ${_comp_label})")
		# endif ()
		# set(WXBUILD_MSVC_COMPILER ${_comp_ver} CACHE STRING "Microsoft Visual C++ compiler version")
		# mark_as_advanced(WXBUILD_MSVC_COMPILER)
	# endif ()

	# add_definitions(-D__VISUALC__=${WXBUILD_MSVC_COMPILER})

endif ()
