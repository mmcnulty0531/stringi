# autoconf/configure script for stringi
# Copyright (C) 2013-2015, M. Gagolewski
# http://stringi.rexamine.com

##### INIT ####################################################################

AC_INIT(stringi, 0.5, stringi@rexamine.com)

ICU_VERSION_NEEDED="50" # minimal version of ICU4C required to build stringi

##### OPTIONS #################################################################

# shell variables/arguments accepted:
# R_HOME - R's home dir
AC_ARG_VAR(R_HOME, [Override the default directory with R installation,
   e.g., /usr/lib64/R, where /usr/lib64 is in the search path.
   Note that $R_HOME/bin/R should point to the R executable.])

AC_ARG_VAR(ICUDT_DIR, [Optional directory from which an already downloaded ICU
   data archive (icudt*.zip) may be copied; either an absolute path or
   a path relative to <package source dir>/src; defaults to icu55/data.])

AC_ARG_VAR(PKG_CONFIG_PATH, [An optional list of directories to search for
   pkg-config's .pc files.])

AC_ARG_VAR([CAT], [The 'cat' command used for generating the list
   of source files to compile.])

AC_ARG_VAR([CC], [Purposedly ignored.])

AC_ARG_VAR([CFLAGS], [Purposedly ignored.])

AC_ARG_VAR([LDFLAGS], [Purposedly ignored.])

AC_ARG_VAR([LIBS], [Purposedly ignored.])

AC_ARG_VAR([CPPFLAGS], [Purposedly ignored.])

AC_ARG_VAR([CXX], [Purposedly ignored.])

AC_ARG_VAR([CXXFLAGS], [Purposedly ignored.])

AC_ARG_VAR([CXXCPP], [Purposedly ignored.])

AC_ARG_ENABLE([cxx11],
    AS_HELP_STRING([--disable-cxx11],
      [Disable use of C++11; if you build ICU4C from sources, make sure your C++ compiler supports the long long type.]))
if test "x$enable_cxx11" != "xno"; then
   enable_cxx11="yes"
else
   enable_cxx11="no"
fi

AC_ARG_ENABLE([icu_bundle],
    AS_HELP_STRING([--disable-icu-bundle],
      [Force the use of the system ICU.]))
if test "x$enable_icu_bundle" != "xno"; then
   enable_icu_bundle="yes"
else
   enable_icu_bundle="no"
fi

AC_ARG_ENABLE([pkg_config],
    AS_HELP_STRING([--disable-pkg-config],
      [Disable pkg-config usage for finding ICU4C-devel; in such a case ICU4C will be compiled from sources.]))
if test "x$enable_pkg_config" != "xno"; then
   enable_pkg_config="yes"
else
   enable_pkg_config="no"
fi

AC_ARG_ENABLE([gcc_debug],
    AS_HELP_STRING([--enable-gcc-debug],
      [Enable -UNDEBUG when compiling stringi (for stringi developers)]))
if test "x$enable_gcc_debug" == "xyes"; then
   enable_gcc_debug="yes"
else
   enable_gcc_debug="no"
fi

AC_ARG_ENABLE([gcc_pedantic],
    AS_HELP_STRING([--enable-gcc-pedantic],
      [Enable -Wall -Wextra -ansi -pedantic when compiling stringi with gcc/clang (for stringi developers)]))
if test "x$enable_gcc_pedantic" == "xyes"; then
   enable_gcc_pedantic="yes"
else
   enable_gcc_pedantic="no"
fi

AC_ARG_WITH([extra_cflags],
    AS_HELP_STRING([--with-extra-cflags=FLAGS],
      [Additional C compiler flags]))

AC_ARG_WITH([extra_cppflags],
    AS_HELP_STRING([--with-extra-cppflags=FLAGS],
      [Additional C/C++ preprocessor flags]))

AC_ARG_WITH([extra_cxxflags],
    AS_HELP_STRING([--with-extra-cxxflags=FLAGS],
      [Additional C++ compiler flags]))

AC_ARG_WITH([extra_ldflags],
    AS_HELP_STRING([--with-extra-ldflags=FLAGS],
      [Additional linker flags]))

AC_ARG_WITH([extra_libs],
    AS_HELP_STRING([--with-extra-libs=FLAGS],
      [Additional libraries to link against]))

##### CHECK FOR R #############################################################

# set ICUDT_DIR
AC_MSG_CHECKING(for local ICUDT_DIR)
if test -z "${ICUDT_DIR}"; then
# Remember also to update the configure.win file
   ICUDT_DIR=icu55/data
fi
AC_MSG_RESULT($ICUDT_DIR)

# this is inspired by the "Writing R Extensions" manual:
# determine R_HOME directory...
AC_MSG_CHECKING(for R_HOME)
if test -z "${R_HOME}"; then
   R_HOME=`R RHOME` # set R_HOME if it has not been set already
fi
if test -z "${R_HOME}"; then
   AC_MSG_RESULT(no)
   echo "*** Could not determine R_HOME. Did you install R properly?"
   exit 1
fi
AC_MSG_RESULT($R_HOME)
AC_SUBST(R_HOME)


# ...and then R_PATH
AC_MSG_CHECKING(for R)
R_PATH="${R_HOME}/bin/R" # see "Writing R Extensions"
if test ! -e "${R_PATH}"; then
   # if it was determined by calling `R RHOME`, then this is likely a bug
   AC_MSG_RESULT(no)
   echo "*** Could not find R at R_HOME/bin/R, i.e. ${R_HOME}/bin/R"
   exit 1
fi
AC_MSG_RESULT($R_PATH)

AC_MSG_CHECKING(for R >= 3.1.0)
R_GE_31=`"${R_PATH}" --vanilla --slave -e 'cat(if (getRversion() >= numeric_version("3.1.0")) "yes" else "no")'`
if test "x$R_GE_31" == "xyes"; then
   AC_MSG_RESULT([yes])
else
   AC_MSG_RESULT([no])
   if test "x$enable_cxx11" == "xyes"; then
      echo "*** disabling C++11 use"
      enable_cxx11="no"
   fi
fi

##### CHECK FOR CAT ############################################################

# Check for 'cat' and get full path.
AC_PATH_PROG([CAT],[cat],[])
if test "x$CAT" = "x"; then
   AC_MSG_NOTICE([==> cat command not found!])
   AC_MSG_NOTICE([==> Set CAT variable if present in non-standard path])
fi


###### SETUP COMPILER FLAGS FOR TESTING ######################################

if test "x$enable_gcc_debug" == "xyes"; then
   #  -fsanitize=address -fno-omit-frame-pointer
   with_extra_cppflags="${with_extra_cppflags} -DDEBUG -UNDEBUG"
else
   with_extra_cppflags="${with_extra_cppflags} -UDEBUG -DNDEBUG"
fi

if test "x$enable_gcc_pedantic" == "xyes"; then
   with_extra_cflags="${with_extra_cflags} -Wall -Wextra -ansi -pedantic -std=c99"
   with_extra_cxxflags="${with_extra_cxxflags} -Wall -Wextra -ansi -pedantic -std=c++98 -Wlong-long"
fi

CC=`"${R_PATH}" CMD config CC`
CPP=`"${R_PATH}" CMD config CXXCPP`
LD=`"${R_PATH}" CMD config SHLIB_CXXLD`
CFLAGS=`"${R_PATH}" CMD config CFLAGS`
CPPFLAGS=`"${R_PATH}" CMD config CPPFLAGS`
LIBS=
LDFLAGS=

if test "x$enable_cxx11" == "xyes"; then
   CXX="`\"${R_PATH}\" CMD config CXX1X` `\"${R_PATH}\" CMD config CXX1XSTD`"
   CXXFLAGS=`"${R_PATH}" CMD config CXX1XFLAGS`
   STRINGI_CXXSTD="CXX_STD=CXX11"
else
   CXX=`"${R_PATH}" CMD config CXX`
   CXXFLAGS=`"${R_PATH}" CMD config CXXFLAGS`
   STRINGI_CXXSTD=""
fi

CFLAGS="${CFLAGS} ${with_extra_cflags}"
CXXFLAGS="${CXXFLAGS} ${with_extra_cxxflags}"
CPPFLAGS="${CPPFLAGS} ${with_extra_cppflags}"
LDFLAGS="${LDFLAGS} ${with_extra_ldflags}"
LIBS="${LIBS} ${with_extra_libs}"

AC_LANG(C)
AC_PROG_CC

AC_CHECK_HEADER([elf.h],
       [
            with_extra_cppflags="${with_extra_cppflags} -DU_HAVE_ELF_H"
       ])

AC_LANG(C++)
AC_PROG_CXX

##### Checking whether the C++ compiler supports the long long type and STL ####


check_cpp() {
   AC_LANG(C++)
   AC_MSG_CHECKING(whether the C++ compiler supports the long long type)
   AC_LINK_IFELSE([AC_LANG_SOURCE([
         #include <iostream>
         using namespace std;

         int main() {
           long long x = 1;
           cout << x << endl;

           cout << 1LL << 1ULL << endl;
           cout << 9223372036854775807LL << 18446744073709551615ULL << endl;

           return 0;
         }])
      ],
      [
         AC_MSG_RESULT([yes])
      ],[
         AC_MSG_RESULT([no])
         return 1
      ])

   AC_CXX_HAVE_STL
   if test "$ac_cv_cxx_have_stl" = not; then
      return 1
   fi

   AC_MSG_CHECKING(whether std::map is available)
   AC_LINK_IFELSE([AC_LANG_SOURCE([
         #include <iostream>
         #include <map>
         #include <vector>
         #include <utility>

         int main() {
            std::map< int, std::vector< int > > curmap;
            std::vector<int> v1(10);
            curmap.insert(std::pair< int, std::vector< int > >(100, v1));
            std::cout << curmap.size() << std::endl;
           return 0;
         }])
      ],
      [
         AC_MSG_RESULT([yes])
      ],[
         AC_MSG_RESULT([no])
         return 1
      ])


   CPP_OK=1
   return 0
}

CPP_OK=0
check_cpp

if test $CPP_OK = 0; then
   if test "x$enable_cxx11" == "xyes"; then
      echo "*** trying with disabled C++11 compiler"
      CXX=`"${R_PATH}" CMD config CXX`
      CXXFLAGS=`"${R_PATH}" CMD config CXXFLAGS`
      STRINGI_CXXSTD=""
      CXXFLAGS="${CXXFLAGS} ${with_extra_cxxflags}"

      # unset cached C++ compiler features:
      unset ac_cv_cxx_compiler_gnu
      unset ac_cv_prog_cxx_g
      unset ac_cv_cxx_namespaces
      unset ac_cv_cxx_have_stl

      # re-run tests:
      check_cpp
   fi

   if test $CPP_OK = 0; then
      echo "*** verify your C++ compiler's abilities (long long, STL, etc. support)"
      exit 1
   fi
fi

##### CHECK FOR ICU4C ##########################################################



##### 1. Get settings from pkg-config
# Note that according to http://userguide.icu-project.org/howtouseicu,
# icu-config is supported, but no longer recommended for production use.


detect_icu_with_pkg_config() {
   if test $enable_pkg_config = "no"; then
      # Use of pkg-config disabled, nothing to do
      return 1
   fi

   # Retrieve pkg-config's path
   AC_PATH_PROG(PKG_CONFIG, pkg-config, no,
         [$PATH:/usr/local/bin:/bin:/usr/bin:ext/bin:ext:/sw/bin:/opt/bin]) # auto-detect

   if test ! -f "${PKG_CONFIG}"; then
      echo "*** The pkg-config script could not be found"
      echo "*** Make sure it is installed if you want to use system ICU4C-devel installation"
      return 1 # go back immediately
   fi

   # check if pkg-config knows about icu-i18n
   AC_MSG_CHECKING(with pkg-config for ICU4C installed)
   if ! `"${PKG_CONFIG}" --exists icu-i18n  icu-uc`; then
      # pkg config doesn't know about icu-i18n
      AC_MSG_RESULT(no)
      echo "*** The pkg-config script did not detect ICU4C-devel libraries installed"
      echo "*** We will build ICU4C from sources"
      return 1 # nothing more to do
   fi

   # check which version of ICU4C is installed
   ICU_VERSION=`"${PKG_CONFIG}" --modversion icu-i18n`
   AC_MSG_RESULT($ICU_VERSION)

   # check for a suitable version
   AC_MSG_CHECKING(for ICU4C >= $ICU_VERSION_NEEDED)
   #VERSION_CHECK=`expr $ICU_VERSION ">=" $ICU_VERSION_NEEDED`
   #if test "$VERSION_CHECK" != "1" ; then
   if ! `"${PKG_CONFIG}" --atleast-version=${ICU_VERSION_NEEDED} icu-i18n  icu-uc`; then
      AC_MSG_RESULT(no)
      echo "*** ICU4C ${ICU_VERSION} has been detected"
      echo "*** Minimal requirements, i.e. ICU4C >= ${ICU_VERSION_NEEDED}, are not met"
      echo "*** We will build ICU4C from sources"
      return 1 # you may quit querying pkg-config here
   fi
   AC_MSG_RESULT(yes) # detected version of ICU4C is sufficient

   export PKG_CONFIG_ALLOW_SYSTEM_LIBS=1 # always provide system -L
   AC_MSG_CHECKING([for proper CPPFLAGS, LDFLAGS, and LIBS])
   ICU_CPPFLAGS=`"${PKG_CONFIG}" --cflags icu-uc icu-i18n`
   ICU_LDFLAGS=`"${PKG_CONFIG}" --libs-only-L icu-uc icu-i18n`
   ICU_LIBS=`"${PKG_CONFIG}" --libs-only-l icu-uc icu-i18n`
   AC_MSG_RESULT(done)

   # It has been indicated that icu-config may return 32bit libs
   # when 64bit libs are not available, even if we compile a 64bit version.
   # Thus, let us check if everything works
   CPPFLAGS="${CPPFLAGS} ${ICU_CPPFLAGS}"
   LDFLAGS="${LDFLAGS} ${ICU_LDFLAGS}"
   LIBS="${LIBS} ${ICU_LIBS}"

   AC_LANG(C++)

   AC_MSG_CHECKING([whether we may build an ICU-based project])
   AC_LINK_IFELSE([AC_LANG_SOURCE([
      #include <unicode/unistr.h>
      #include <unicode/uvernum.h>
      #include <unicode/ptypes.h>
      #include <unicode/uchar.h>
      #include <unicode/utypes.h>
      #include <stdio.h>
      using namespace icu;

      int main() {
        // base tests
        UnicodeString x("abc");
        x = x+x;
        printf(U_ICU_VERSION);

        return 0;
      }])
   ],
   [
      AC_MSG_RESULT([yes])
   ],[
      AC_MSG_RESULT([no])
      echo "*** ICU4C will be built from sources"
      return 1
   ])

   AC_MSG_CHECKING([for available ICU data library (ucnv, uloc, utrans)])
   AC_LINK_IFELSE([AC_LANG_SOURCE([
      #include <unicode/unistr.h>
      #include <unicode/uvernum.h>
      #include <unicode/ptypes.h>
      #include <unicode/uchar.h>
      #include <unicode/utypes.h>
      #include <unicode/ucnv.h>
      #include <unicode/ustring.h>
      #include <unicode/stringpiece.h>
      #include <unicode/utf8.h>
      #include <unicode/utf16.h>
      #include <unicode/normalizer2.h>
      #include <unicode/locid.h>
      #include <unicode/uloc.h>
      #include <unicode/regex.h>
      #include <unicode/brkiter.h>
      #include <unicode/coll.h>
      #include <unicode/ucol.h>
      #include <unicode/ucsdet.h>
      #include <unicode/stsearch.h>
      #include <unicode/ulocdata.h>
      #include <unicode/usearch.h>
      #include <unicode/uniset.h>
      #include <stdio.h>
      #include <unicode/translit.h>
      #include <unicode/uclean.h>
      using namespace icu;

      int main() {
         UErrorCode status = U_ZERO_ERROR;
         u_init(&status);
         if (U_FAILURE(status)) {
            printf("ICU init failed: %s", u_errorName(status));
            return 10;
         }

        // check if we have some converters installed (icudt)
        int c = ucnv_countAvailable();
        if (c <= 0)
          return 11;

        // check if we have some locales defined (icudt)
        c = uloc_countAvailable();
        if (c <= 0)
          return 12;

        status = U_ZERO_ERROR;
        StringEnumeration* trans_enum = Transliterator::getAvailableIDs(status);
        if (!U_SUCCESS(status)) return 13;

        trans_enum->reset(status);
        if (!U_SUCCESS(status)) return 14;

        c = trans_enum->count(status);
        if (!U_SUCCESS(status)) return 15;
        if (c <= 0) return 16;

        delete trans_enum;
        return 0;
      }])
   ],
   [
      AC_MSG_RESULT([yes])
   ],[
      AC_MSG_RESULT([no])
      echo "*** ICU4C will be built from sources"
      return 1
   ])

   AC_MSG_CHECKING([for available ICU data library (ucol)])
   AC_LINK_IFELSE([AC_LANG_SOURCE([
      #include <unicode/unistr.h>
      #include <unicode/uvernum.h>
      #include <unicode/ptypes.h>
      #include <unicode/uchar.h>
      #include <unicode/utypes.h>
      #include <unicode/ucnv.h>
      #include <unicode/ustring.h>
      #include <unicode/stringpiece.h>
      #include <unicode/utf8.h>
      #include <unicode/utf16.h>
      #include <unicode/normalizer2.h>
      #include <unicode/locid.h>
      #include <unicode/uloc.h>
      #include <unicode/regex.h>
      #include <unicode/brkiter.h>
      #include <unicode/coll.h>
      #include <unicode/ucol.h>
      #include <unicode/ucsdet.h>
      #include <unicode/stsearch.h>
      #include <unicode/ulocdata.h>
      #include <unicode/usearch.h>
      #include <unicode/uniset.h>
      #include <stdio.h>
      using namespace icu;

      int main() {
        UnicodeString a = UnicodeString::fromUTF8("hladny");
        UnicodeString b = UnicodeString::fromUTF8("chladny");

        UErrorCode status = U_ZERO_ERROR;
        Locale l = Locale::createFromName("sk_SK");
        Collator* c = Collator::createInstance(l, status);
        if (!U_SUCCESS(status)) return 1;

        status = U_ZERO_ERROR;
        if (UCOL_GREATER != c->compare(a, b, status))
           return 2;
        if (!U_SUCCESS(status)) return 3;

        delete c;
        return 0;
      }])
   ],
   [
      AC_MSG_RESULT([yes])
   ],[
      AC_MSG_RESULT([no])
      echo "*** ICU4C will be built from sources"
      return 1
   ])

   ICU_FOUND=1 # DONE
   return 0
}

ICU_FOUND=0

if test $ICU_FOUND = 0; then
   OLD_CPPFLAGS=$CPPFLAGS
   OLD_LDFLAGS=$LDFLAGS
   OLD_LIBS=$LIBS
   detect_icu_with_pkg_config
   CPPFLAGS=$OLD_CPPFLAGS
   LDFLAGS=$OLD_LDFLAGS
   LIBS=$OLD_LIBS
fi


check_flags_icu_bundle() {
   CPPFLAGS="${CPPFLAGS} -Isrc/ -Isrc/icu55 -Isrc/icu55/unicode \
      -Isrc/icu55/common -Isrc/icu55/i18n -DU_STATIC_IMPLEMENTATION \
      -DU_COMMON_IMPLEMENTATION -DU_I18N_IMPLEMENTATION -D_REENTRANT" # don't use uconfig_local yet

# one way for dealing with the *Compiler or options invalid for pre-UNIX 03
# X/Open applications and pre-2001 POSIX applications* error on Solaris
# is to file a patch for sys/feature_tests.h. Unfortunately, the original
# file is copyrighted, so we have to cope with this error in another way:
# addind -D_XPG6 flag conditionally.

   AC_LANG(C)
   AC_MSG_CHECKING([whether we may compile src/icu55/common/umapfile.c])
   AC_COMPILE_IFELSE([
      AC_LANG_SOURCE([`${CAT} src/icu55/common/umapfile.c`])
   ],
   [
      AC_MSG_RESULT([yes])
   ],[
      AC_MSG_RESULT([no])
      with_extra_cflags="${with_extra_cflags} -D_XPG6"
      CFLAGS="${CFLAGS} -D_XPG6"
      AC_MSG_CHECKING([whether we may compile src/icu55/common/umapfile.c with -D_XPG6])
      AC_COMPILE_IFELSE([
         AC_LANG_SOURCE([`${CAT} src/icu55/common/umapfile.c`])
      ],
      [
         AC_MSG_RESULT([yes])
      ],[
         AC_MSG_RESULT([no])
         echo "*** The ICU bundle cannot be build. Upgrade your compiler flags."
         exit 1
      ])
   ])

   AC_LANG(C++)
   AC_MSG_CHECKING([whether we may compile src/icu55/common/putil.cpp])
   AC_COMPILE_IFELSE([
      AC_LANG_SOURCE([`${CAT} src/icu55/common/putil.cpp`])
   ],
   [
      AC_MSG_RESULT([yes])
   ],[
      AC_MSG_RESULT([no])
      with_extra_cxxflags="${with_extra_cXXflags} -D_XPG6"
      CXXFLAGS="${CXXFLAGS} -D_XPG6"
      AC_MSG_CHECKING([whether we may compile src/icu55/common/putil.cpp with -D_XPG6])
      AC_COMPILE_IFELSE([
         AC_LANG_SOURCE([`${CAT} src/icu55/common/putil.cpp`])
      ],
      [
         AC_MSG_RESULT([yes])
      ],[
         AC_MSG_RESULT([no])
         echo "*** The ICU bundle cannot be build. Upgrade your compiler flags."
         exit 1
      ])
   ])

   return 0
}

if test $ICU_FOUND = 0; then
   OLD_CFLAGS=$CFLAGS
   OLD_CXXFLAGS=$CXXFLAGS
   OLD_CPPFLAGS=$CPPFLAGS
   OLD_LIBS=$LIBS
   check_flags_icu_bundle
   CFLAGS=$OLD_CFLAGS
   CXXFLAGS=$OLD_CXXFLAGS
   CPPFLAGS=$OLD_CPPFLAGS
fi

##### PREPARE LIST OF SOURCE FILES #############################################

STRINGI_SOURCES_CPP=`${CAT} src/stri_cpp.txt`
AC_SUBST(STRINGI_SOURCES_CPP)

STRINGI_ICU_COMMON_SOURCES_CPP=`${CAT} src/icu55_common_cpp.txt`
AC_SUBST(STRINGI_ICU_COMMON_SOURCES_CPP)

STRINGI_ICU_COMMON_SOURCES_C=`${CAT} src/icu55_common_c.txt`
AC_SUBST(STRINGI_ICU_COMMON_SOURCES_C)

STRINGI_ICU_I18N_SOURCES_CPP=`${CAT} src/icu55_i18n_cpp.txt`
AC_SUBST(STRINGI_ICU_I18N_SOURCES_CPP)

STRINGI_ICU_I18N_SOURCES_C=`${CAT} src/icu55_i18n_c.txt`
AC_SUBST(STRINGI_ICU_I18N_SOURCES_C)

STRINGI_ICU_STUBDATA_SOURCES_CPP=`${CAT} src/icu55_stubdata_cpp.txt`
AC_SUBST(STRINGI_ICU_STUBDATA_SOURCES_CPP)

STRINGI_ICU_STUBDATA_SOURCES_C=`${CAT} src/icu55_stubdata_c.txt`
AC_SUBST(STRINGI_ICU_STUBDATA_SOURCES_C)


##### SETUP COMPILER 2 ###########################################################

if test $ICU_FOUND = 0; then
   if test $enable_icu_bundle = "no"; then
      echo "*** Failed to configure package build with forced system ICU usage"
      echo "*** Make sure that libicu-dev is properly installed"
      exit 1
   fi

   # build ICU4C from sources
   STRINGI_OBJECTS="\$(STRI_OBJECTS) \$(ICU_COMMON_OBJECTS) \$(ICU_I18N_OBJECTS) \$(ICU_STUBDATA_OBJECTS)"
   STRINGI_CFLAGS=""
   STRINGI_CPPFLAGS="-I. -Iicu55 -Iicu55/unicode -Iicu55/common -Iicu55/i18n -DU_STATIC_IMPLEMENTATION \
-DU_COMMON_IMPLEMENTATION -DU_I18N_IMPLEMENTATION -DUCONFIG_USE_LOCAL"
        #-DU_HIDE_DRAFT_API -DU_HIDE_DEPRECATED_API"
   STRINGI_CXXFLAGS=""
   STRINGI_LDFLAGS=""
   STRINGI_LIBS=""
else
   # use system ICU4C
   STRINGI_OBJECTS="\$(STRI_OBJECTS)"
   STRINGI_CFLAGS=""
   STRINGI_CPPFLAGS="-I. ${ICU_CPPFLAGS}"
   STRINGI_CXXFLAGS=""
   STRINGI_LDFLAGS="${ICU_LDFLAGS}"
   STRINGI_LIBS="${ICU_LIBS}"
fi

STRINGI_CFLAGS="${STRINGI_CFLAGS} ${with_extra_cflags}"
STRINGI_CPPFLAGS="${STRINGI_CPPFLAGS} ${with_extra_cppflags}"
STRINGI_CXXFLAGS="${STRINGI_CXXFLAGS} ${with_extra_cxxflags}"
STRINGI_LDFLAGS="${STRINGI_LDFLAGS} ${with_extra_ldflags}"
STRINGI_LIBS="${STRINGI_LIBS} ${with_extra_libs}"

AC_SUBST(STRINGI_OBJECTS)
AC_SUBST(STRINGI_CXXSTD)
AC_SUBST(STRINGI_CXXFLAGS)
AC_SUBST(STRINGI_CPPFLAGS)
AC_SUBST(STRINGI_CFLAGS)
AC_SUBST(STRINGI_LDFLAGS)
AC_SUBST(STRINGI_LIBS)
AC_SUBST(ICU_FOUND)
AC_SUBST(ICUDT_DIR)

# Remember also to update the configure.win file
AC_CONFIG_FILES([src/Makevars])
AC_CONFIG_FILES([src/uconfig_local.h])
AC_CONFIG_FILES([src/install.libs.R])

AC_OUTPUT

echo ""
echo "*** stringi configure summary:"
echo "    ICU_FOUND=${ICU_FOUND}"
echo "    ICUDT_DIR=${ICUDT_DIR}"
echo "    STRINGI_CXXSTD=${STRINGI_CXXSTD}"
echo "    STRINGI_CFLAGS=${STRINGI_CFLAGS}"
echo "    STRINGI_CPPFLAGS=${STRINGI_CPPFLAGS}"
echo "    STRINGI_CXXFLAGS=${STRINGI_CXXFLAGS}"
echo "    STRINGI_LDFLAGS=${STRINGI_LDFLAGS}"
echo "    STRINGI_LIBS=${STRINGI_LIBS}"
echo ""
echo "*** compiler settings used:"
echo "    CC=${CC}"
echo "    CPP=${CPP}"
echo "    LD=${LD}"
echo "    CFLAGS=${CFLAGS}"
echo "    CPPFLAGS=${CPPFLAGS}"
echo "    CXX=${CXX}"
echo "    CXXFLAGS=${CXXFLAGS}"
echo "    LDFLAGS=${LDFLAGS}"
echo "    LIBS=${LIBS}"
echo ""
