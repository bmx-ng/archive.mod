#ifndef MZ_CONFIG_H
#define MZ_CONFIG_H

/* BlitzMax builds minizip-ng directly, without CMake's configure step. */
#define HAVE_INTTYPES_H 1
#define HAVE_STDINT_H 1

#if defined(_WIN32)
#  define HAVE_DIRENT_H 0
#  define HAVE_SYS_DIRENT_H 0
#  define HAVE_PDIR 0
#  define HAVE_FSEEKO 0
#  define HAVE_SYMLINK 0
#  define HAVE_READLINK 0
#else
#  define HAVE_DIRENT_H 1
#  define HAVE_SYS_DIRENT_H 0
#  define HAVE_PDIR 1
#  define HAVE_FSEEKO 1
#  define HAVE_SYMLINK 1
#  define HAVE_READLINK 1
#endif

#endif
