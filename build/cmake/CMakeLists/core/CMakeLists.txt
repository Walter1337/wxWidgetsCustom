set(LIB_NAME core)

if (NOT WXBUILD_SYSTEM_PNG)
	include_directories(${WX_SOURCE_DIR}/src/png)
else()
    include_directories(${PNG_INCLUDE_DIR})
    add_definitions(${PNG_DEFINITIONS})
endif ()

if (NOT WXBUILD_SYSTEM_JPEG)
	include_directories(${WX_SOURCE_DIR}/src/jpeg)
else()
    include_directories(${JPEG_INCLUDE_DIR})
endif ()

if (NOT WXBUILD_SYSTEM_TIFF)
	include_directories(${WX_SOURCE_DIR}/src/tiff/libtiff)
else()
    include_directories(${TIFF_INCLUDE_DIR})
endif ()

include_directories(${WXBUILD_PORT_INCLUDE_DIRS})

add_definitions(-DwxUSE_BASE=0)

if(WXBUILD_SHARED_LIBS)
  add_definitions(-DWXMAKINGDLL_CORE -DWXUSINGDLL)
endif()

set(LIB_SRC
	${WXFILES_BASE_AND_GUI_SRC}
	${WXFILES_CORE_SRC}
	${WXFILES_BASE_AND_GUI_PLATFORM_SRC}
	${WXFILES_CORE_PLATFORM_SRC}
)

set(LIB_HEADERS
	${WXFILES_ALL_GUI_HEADERS}
)

foreach (hdr ${LIB_HEADERS})
	# There are .cpp files in the headers. To exclude all of them from compilation,
	# we use this command unconditionally (it does no harm on .h files)
	set_source_files_properties(${hdr} PROPERTIES HEADER_FILE_ONLY TRUE)
endforeach ()

wx_set_pch(LIB_SRC ${WX_SOURCE_DIR}/src/common/dummy.cpp wx/wxprec.h "${WX_SOURCE_DIR}/include/wx/wxprec.h")

wx_set_source_groups()

add_library(${LIB_NAME} ${WXBUILD_SHARED_OR_STATIC}
	${LIB_SRC}
	${LIB_HEADERS}
	${PROJECT_BINARY_DIR}/include/wx/setup.h
)

set(_deps)

if (NOT WXBUILD_SYSTEM_PNG)
	list(APPEND _deps wxpng)
else ()
	list(APPEND _deps ${PNG_LIBRARIES})
endif ()
if (NOT WXBUILD_SYSTEM_JPEG)
	list(APPEND _deps wxjpeg)
else ()
	list(APPEND _deps ${JPEG_LIBRARIES})
endif ()
if (NOT WXBUILD_SYSTEM_TIFF)
	list(APPEND _deps wxtiff)
else ()
	list(APPEND _deps ${TIFF_LIBRARIES})
endif ()

list(APPEND _deps ${WXBUILD_PORT_LIBRARIES})

target_link_libraries(${LIB_NAME} base ${_deps})

if(NOT ${CMAKE_VERSION} VERSION_LESS 2.8.11)
	target_include_directories(${LIB_NAME}
		PUBLIC
		$<BUILD_INTERFACE:${WX_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:$<INSTALL_PREFIX>/${CMAKE_INSTALL_INCLUDEDIR}>)

	if(WXBUILD_SHARED_LIBS)
		target_compile_definitions(${LIB_NAME} PUBLIC WXUSINGDLL)
	endif()

	target_compile_definitions(${LIB_NAME}
		PUBLIC ${WXBUILD_PUBLIC_DEFINITIONS})
endif()

install(TARGETS ${LIB_NAME} DESTINATION ${CMAKE_INSTALL_LIBDIR}
	EXPORT wxWidgetsTargets)

wx_install_headers(LIB_HEADERS)
