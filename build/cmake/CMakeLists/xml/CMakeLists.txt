set(LIB_NAME xml)

add_definitions(-DwxUSE_BASE=0)

if(WXBUILD_SHARED_LIBS)
  add_definitions(-DWXMAKINGDLL_XML -DWXUSINGDLL)
endif()

if (NOT WXBUILD_SYSTEM_EXPAT)
    include_directories(${WXBUILD_PORT_INCLUDE_DIRS} ${WX_SOURCE_DIR}/src/expat/lib)
else ()
    include_directories(${WXBUILD_PORT_INCLUDE_DIRS} ${EXPAT_INCLUDE_DIRS})
endif ()

set(LIB_SRC
	${WXFILES_XML_SRC}
)

set(LIB_HEADERS
	${WXFILES_XML_HDR}
)

wx_set_pch(LIB_SRC ${WX_SOURCE_DIR}/src/common/dummy.cpp wx/wxprec.h "${WX_SOURCE_DIR}/include/wx/wxprec.h")

wx_set_source_groups()

add_library(${LIB_NAME} ${WXBUILD_SHARED_OR_STATIC}
	${LIB_SRC}
	${LIB_HEADERS}
	${PROJECT_BINARY_DIR}/include/wx/setup.h
)

set(_deps)
list(APPEND _deps ${WXBUILD_PORT_LIBRARIES})
if (NOT WXBUILD_SYSTEM_EXPAT)
	list(APPEND _deps expat)
else ()
	# TODO: Remove once Hunter's Expat has a package config file.
	# That file should export this definition only if Expat is compiled
	# statically.  For now, we are just assuming that it is.
	target_compile_definitions(${LIB_NAME} PRIVATE XML_STATIC)
	list(APPEND _deps ${EXPAT_LIBRARIES})
endif ()

target_link_libraries(${LIB_NAME} core ${_deps})

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