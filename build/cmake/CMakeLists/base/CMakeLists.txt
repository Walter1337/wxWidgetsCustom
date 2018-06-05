set(LIB_NAME base)

if (NOT WXBUILD_SYSTEM_ZLIB)
	include_directories(${WX_SOURCE_DIR}/src/zlib)
else()
    include_directories(${ZLIB_INCLUDE_DIRS})
endif ()

if (WXSETUP_wxUSE_REGEX)
	include_directories(${WX_SOURCE_DIR}/src/regex)
endif()

add_definitions(-DwxUSE_BASE=1 -DwxUSE_GUI=0)

if(WXBUILD_SHARED_LIBS)
  add_definitions(-DWXMAKINGDLL_BASE)
endif()

set(LIB_SRC
	${WXFILES_BASE_SRC}
	${WXFILES_BASE_AND_GUI_SRC}
	${WXFILES_BASE_PLATFORM_SRC}
	${WXFILES_BASE_AND_GUI_PLATFORM_SRC}
)

set(LIB_HEADERS
	${WXFILES_BASE_CMN_HDR}
	${WXFILES_BASE_PLATFORM_HDR}
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

if (NOT WXBUILD_SYSTEM_ZLIB)
	target_link_libraries(${LIB_NAME} wxzlib)
else()
	target_link_libraries(${LIB_NAME} ${ZLIB_LIBRARIES})
endif()

if (WXSETUP_wxUSE_REGEX)
	target_link_libraries(${LIB_NAME} wxregex)
endif()

if (${WXBUILD_PLATFORM} STREQUAL "win32")
	target_link_libraries(${LIB_NAME} ws2_32)
endif ()

if (${WXBUILD_PLATFORM} STREQUAL "unix")
	set_property(TARGET ${LIB_NAME} PROPERTY COMPILE_OPTIONS "-pthread")
	set_property(TARGET ${LIB_NAME} PROPERTY INTERFACE_COMPILE_OPTIONS "-pthread")
	target_link_libraries(${LIB_NAME} pthread)
endif()

if (${WXBUILD_PLATFORM} STREQUAL "unix")
	target_link_libraries(${LIB_NAME} ${CMAKE_DL_LIBS})
endif()

if(NOT ${CMAKE_VERSION} VERSION_LESS 2.8.11)
	target_include_directories(${LIB_NAME}
		PUBLIC
		$<BUILD_INTERFACE:${WX_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:$<INSTALL_PREFIX>/${CMAKE_INSTALL_INCLUDEDIR}>)

	if(WXBUILD_SHARED_LIBS)
		target_compile_definitions(${LIB_NAME} INTERFACE WXUSINGDLL)
	endif()

	target_compile_definitions(${LIB_NAME}
		PUBLIC ${WXBUILD_PUBLIC_DEFINITIONS})
endif()

install(TARGETS ${LIB_NAME} DESTINATION ${CMAKE_INSTALL_LIBDIR}
	EXPORT wxWidgetsTargets)

wx_install_headers(LIB_HEADERS)