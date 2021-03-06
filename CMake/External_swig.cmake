message(STATUS "Setup swig...")

set(proj SWIG)
SETUP_SUPERBUILD(PROJECT ${proj})

set(PythonInterp_FIND_VERSION 2.7)
find_package(PythonInterp)
if(PYTHONINTERP_FOUND)
  set(SWIG_SB_PYTHON_CONFIG "--with-python=${PYTHON_EXECUTABLE}")
else()
  set(SWIG_SB_PYTHON_CONFIG)
  message(WARNING "  No suitable python interpreter was found !")
endif()

# We don't need java for anaconda...
#find_package(Java)
#if(JAVA_FOUND)
#  set(SWIG_SB_JAVA_CONFIG "--with-java=${Java_JAVA_EXECUTABLE}")
#else()
#  set(SWIG_SB_JAVA_CONFIG)
#  message(WARNING "  No Java executable was found !")
#endif()

if(MSVC)
  # Use pre-built swig executable (no linking is required, no install done)
  ExternalProject_Add(${proj}
    PREFIX ${proj}
    URL "http://sourceforge.net/projects/swig/files/swigwin/swigwin-3.0.5/swigwin-3.0.5.zip/download"
    URL_MD5 fd2e050f29e2a00b2348f5f7d3476490
    INSTALL_DIR ${INSTALL_STAGING}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    DEPENDS ""
    )
else()
  ExternalProject_Add(${proj}
    PREFIX ${proj}
    URL "http://sourceforge.net/projects/swig/files/swig/swig-3.0.5/swig-3.0.5.tar.gz/download"
    URL_MD5 dcb9638324461b9baba8e044fe59031d
    BINARY_DIR ${SWIG_SB_BUILD_DIR}
    INSTALL_DIR ${INSTALL_STAGING}
    CONFIGURE_COMMAND
      ${SWIG_SB_BUILD_DIR}/configure
      --prefix=${CMAKE_INSTALL_PREFIX}
      ${SWIG_SB_PYTHON_CONFIG}
      ${SWIG_SB_JAVA_CONFIG}
      --with-pcre-prefix=${INSTALL_STAGING}
      --with-boost=${INSTALL_STAGING}
    BUILD_COMMAND $(MAKE)
    INSTALL_COMMAND $(MAKE) install
    DEPENDS "PCRE;BOOST"
    )
  
  ExternalProject_Add_Step(${proj} copy_source
    COMMAND ${CMAKE_COMMAND} -E copy_directory 
      ${SWIG_SB_SRC} ${SWIG_SB_BUILD_DIR}
    DEPENDEES patch update
    DEPENDERS configure
    )
endif()
