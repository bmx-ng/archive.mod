SuperStrict

Rem
bbdoc: Miscellaneous/ZLib compression
End Rem
Module Archive.ZLib

ModuleInfo "Version: 1.08"
ModuleInfo "Author: Jean-loup Gailly, Mark Adler"
ModuleInfo "License: zlib/libpng"
ModuleInfo "Modserver: BRL"
ModuleInfo "Credit: Adapted for BlitzMax by Mark Sibly"

ModuleInfo "History: 1.08"
ModuleInfo "History: Moved to archive.zlib"
ModuleInfo "History: Updated zlib to 1.2.13"
ModuleInfo "History: 1.07"
ModuleInfo "History: Updated zlib to 1.2.12.1.5752b17"
ModuleInfo "History: 1.06"
ModuleInfo "History: Updated zlib to 1.2.12"
ModuleInfo "History: 1.05"
ModuleInfo "History: Updated zlib to 1.2.11"
ModuleInfo "History: 1.04"
ModuleInfo "History: Updated zlib to 1.2.10"
ModuleInfo "History: 1.03"
ModuleInfo "History: Updated zlib to 1.2.8"
ModuleInfo "History: 1.02"
ModuleInfo "History: Updated zlib to 1.2.3"

?macos
ModuleInfo "CC_OPTS: -DHAVE_UNISTD_H"
?

Import "zlib/*.h"
Import "zlib/adler32.c"
Import "zlib/compress.c"
Import "zlib/crc32.c"
Import "zlib/deflate.c"
Import "zlib/gzclose.c"
Import "zlib/gzlib.c"
Import "zlib/gzread.c"
Import "zlib/gzwrite.c"
Import "zlib/infback.c"
Import "zlib/inffast.c"
Import "zlib/inflate.c"
Import "zlib/inftrees.c"
Import "zlib/trees.c"
Import "zlib/uncompr.c"
Import "zlib/zutil.c"

'
' Build notes:
'  gzguts.h
'    Added unistd.h include for emscripten target
'

Extern

Rem
bbdoc: Compress a block of data at default compression level
End Rem
?win32 Or ptr32
Function compress:Int( dest:Byte Ptr,dest_len:UInt Var,source:Byte Ptr,source_len:UInt )="int compress(void *, unsigned long *, const void *, unsigned long)"
?ptr64 And Not win32
Function compress:Int( dest:Byte Ptr,dest_len:ULong Var,source:Byte Ptr,source_len:ULong )="int compress(void *, unsigned long *, const void *, unsigned long)"
?

Rem
bbdoc: Compress a block of data at specified compression level
end rem
?win32 Or ptr32
Function compress2:Int( dest:Byte Ptr,dest_len:UInt Var,source:Byte Ptr,source_len:UInt,level:Int )="int compress2(void *, unsigned long *, const void *, unsigned long , int)"
?ptr64 And Not win32
Function compress2:Int( dest:Byte Ptr,dest_len:ULong Var,source:Byte Ptr,source_len:ULong,level:Int )="int compress2(void *, unsigned long *, const void *, unsigned long , int)"
?

Rem
bbdoc: Uncompress a block of data
end rem
?win32 Or ptr32
Function uncompress:Int( dest:Byte Ptr,dest_len:UInt Var,source:Byte Ptr,source_len:UInt )="int uncompress(void *, unsigned long *, const void *, unsigned long)"
?ptr64 And Not win32
Function uncompress:Int( dest:Byte Ptr,dest_len:ULong Var,source:Byte Ptr,source_len:ULong )="int uncompress(void *, unsigned long *, const void *, unsigned long)"
?

End Extern
