/*
 * Copyright © 2015, 2019 Guillem Jover <guillem@hadrons.org>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef LIBMD_LOCAL_LINK_H
#define LIBMD_LOCAL_LINK_H

#define libmd_link_warning(symbol, msg) \
	static const char libmd_emit_link_warning_##symbol[] \
		__attribute__((__used__,__section__(".gnu.warning." #symbol))) = msg;

/*
 * On Windows we cannot use proper aliases, and using the /EXPORT linker flag
 * is too cumbersome, as it does not work when static linking, and when
 * dynamic linking it does not make the aliases visible within the DLL itself.
 *
 * Instead we use normal function wrapper in those cases, which are way more
 * maintainable.
 */
#if !defined(_MSC_VER) && !defined(__APPLE__)
#define libmd_alias(alias, symbol) \
	extern __typeof(symbol) alias __attribute__((__alias__(#symbol)))
#endif

#ifdef __ELF__
#define libmd_symver_default(alias, symbol, version) \
	__asm__(".symver " #symbol "," #alias "@@" #version)

#define libmd_symver_variant(alias, symbol, version) \
	__asm__(".symver " #symbol "," #alias "@" #version)
#else
#define libmd_symver_default(alias, symbol, version) \
	extern __typeof(symbol) alias __attribute__((__alias__(#symbol)))

#define libmd_symver_variant(alias, symbol, version)
#endif

#endif
