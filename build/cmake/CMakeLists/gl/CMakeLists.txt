set(LIB_NAME gl)

find_package(OpenGL)
#find_package(OpenGL COMPONENTS GLU REQUIRED)

add_definitions(-DwxUSE_BASE=0)

if(WXBUILD_SHARED_LIBS)
  add_definitions(-DWXMAKINGDLL_GL -DWXUSINGDLL)
endif()

include_directories(${WXBUILD_PORT_INCLUDE_DIRS} ${OPENGL_INCLUDE_DIR})

set(LIB_SRC
	${WXFILES_OPENGL_SRC}
)

set(LIB_HEADERS
	${WXFILES_OPENGL_HDR}
)

wx_set_pch(LIB_SRC ${WX_SOURCE_DIR}/src/common/dummy.cpp wx/wxprec.h "${WX_SOURCE_DIR}/include/wx/wxprec.h")

wx_set_source_groups()

add_library(${LIB_NAME} ${WXBUILD_SHARED_OR_STATIC}
	${LIB_SRC}
	${LIB_HEADERS}
	${PROJECT_BINARY_DIR}/include/wx/setup.h
)

target_link_libraries(${LIB_NAME} core ${OPENGL_LIBRARIES} ${WXBUILD_PORT_LIBRARIES})

target_include_directories(${LIB_NAME}
	PUBLIC
	$<BUILD_INTERFACE:${WX_SOURCE_DIR}/include>
	$<INSTALL_INTERFACE:$<INSTALL_PREFIX>/${CMAKE_INSTALL_INCLUDEDIR}>)

if(WXBUILD_SHARED_LIBS)
	target_compile_definitions(${LIB_NAME} PUBLIC WXUSINGDLL)
endif()

target_compile_definitions(${LIB_NAME}
	PUBLIC ${WXBUILD_PUBLIC_DEFINITIONS})

install(TARGETS ${LIB_NAME} DESTINATION ${CMAKE_INSTALL_LIBDIR}
	EXPORT wxWidgetsTargets)

wx_install_headers(LIB_HEADERS)