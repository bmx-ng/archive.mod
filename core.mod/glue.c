/*
 Copyright (c) 2022 Bruce A Henderson
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
     * Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
     * Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ``AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include "archive.h"
#include "archive_entry.h"

#include "brl.mod/blitz.mod/blitz.h"

void * archive_core_TArchiveCallbackData__read(BBObject * data, BBInt64 * count);
void archive_core_TArchiveCallbackData__seek(BBObject * data, BBInt64 offset, int whence, BBInt64 * count);
void * archive_core_TArchiveCallbackData__write(BBObject * data, void * buffer, size_t length, BBInt64 * count);
int archive_core_TArchiveCallbackData__close(BBObject * data);
char * archive_core_TReadArchive__passphraseCallback(BBObject * data);

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++ */

__LA_SSIZE_T bmx_libarchive_read_cb(struct archive * arc, void *data, const void **_buffer) {
	BBInt64 count;
	*_buffer = archive_core_TArchiveCallbackData__read((BBObject*)data, &count);
	return count;
}

__LA_INT64_T bmx_libarchive_seek_cb(struct archive * arc, void *data, __LA_INT64_T offset, int whence) {
	__LA_INT64_T ret;
	archive_core_TArchiveCallbackData__seek((BBObject*)data, offset, whence, &ret);
	return ret;
}

__LA_SSIZE_T bmx_libarchive_write_cb(struct archive * arc, void *data, const void *_buffer, size_t length) {
	BBInt64 ret;
	archive_core_TArchiveCallbackData__write((BBObject*)data, _buffer, length, &ret);
	return ret;
}

int	bmx_libarchive_open_cb(struct archive * arc, void *data) {
	return ARCHIVE_OK;
}

int	bmx_libarchive_close_cb(struct archive * arc, void *data) {
	return archive_core_TArchiveCallbackData__close((BBObject*)data);
}

const char * bmx_libarchive_passphrase_cb(struct archive * arc, void * data) {
	return archive_core_TReadArchive__passphraseCallback((BBObject*)data);
}

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++ */


struct archive * bmx_libarchive_read_archive_new() {
	return archive_read_new();
}

int bmx_libarchive_archive_read_open_memory(struct archive * arc, void * buf, size_t size) {
	return archive_read_open_memory(arc, buf, size);
}

int bmx_libarchive_archive_read_next_header(struct archive * arc, struct archive_entry * entry) {
	return archive_read_next_header2(arc, entry);
}

int bmx_libarchive_archive_read_data_skip(struct archive * arc) {
	return archive_read_data_skip(arc);
}

int bmx_libarchive_archive_read_open(struct archive * arc, BBObject * data) {
	archive_read_set_callback_data(arc, data);
	archive_read_set_open_callback(arc, bmx_libarchive_open_cb);
	archive_read_set_read_callback(arc, bmx_libarchive_read_cb);
	archive_read_set_close_callback(arc, bmx_libarchive_close_cb);
	archive_read_set_seek_callback(arc, bmx_libarchive_seek_cb);
	return archive_read_open1(arc);
}

int bmx_libarchive_archive_read_set_read_callback(struct archive * arc) {
	return archive_read_set_read_callback(arc, bmx_libarchive_read_cb);
}

int bmx_libarchive_archive_read_set_seek_callback(struct archive * arc) {
	return archive_read_set_seek_callback(arc, bmx_libarchive_seek_cb);
}

int bmx_libarchive_archive_read_set_callback_data(struct archive * arc, BBObject * callbackData) {
	return archive_read_set_callback_data(arc, callbackData);
}

int bmx_libarchive_archive_read_data(struct archive * arc, void * buf, size_t size) {
	return archive_read_data(arc, buf, size);
}

int bmx_libarchive_archive_read_free(struct archive * arc) {
	return archive_read_free(arc);
}

int bmx_libarchive_archive_read_add_passphrase(struct archive * arc, BBString * passphrase) {
	char * p = bbStringToUTF8String(passphrase);
	int ret = archive_read_add_passphrase(arc, p);
	bbMemFree(p);
	return ret;
}

int bmx_libarchive_archive_read_has_encrypted_entries(struct archive * arc) {
	return archive_read_has_encrypted_entries(arc);
}

int bmx_libarchive_archive_read_set_filter_option(struct archive * arc, BBString * option, BBString * value, BBString * moduleName) {
	char * o = 0;
	char * v = 0;
	char * m = 0;

	if (option != &bbEmptyString) {
		o = bbStringToUTF8String(option);
	}

	if (value != &bbEmptyString) {
		v = bbStringToUTF8String(value);
	}

	if (moduleName != &bbEmptyString) {
		m = bbStringToUTF8String(moduleName);
	}

	int ret = archive_read_set_filter_option(arc, o, v, m);

	bbMemFree(m);
	bbMemFree(v);
	bbMemFree(o);

	return ret;
}

int bmx_libarchive_archive_read_set_format_option(struct archive * arc, BBString * option, BBString * value, BBString * moduleName) {
	char * o = 0;
	char * v = 0;
	char * m = 0;

	if (option != &bbEmptyString) {
		o = bbStringToUTF8String(option);
	}

	if (value != &bbEmptyString) {
		v = bbStringToUTF8String(value);
	}

	if (moduleName != &bbEmptyString) {
		m = bbStringToUTF8String(moduleName);
	}

	int ret = archive_read_set_format_option(arc, o, v, m);

	bbMemFree(m);
	bbMemFree(v);
	bbMemFree(o);

	return ret;
}

int bmx_libarchive_archive_read_set_passphrase_callback(struct archive * arc, BBObject * data) {
	return archive_read_set_passphrase_callback(arc, data, bmx_libarchive_passphrase_cb);
}

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++ */


struct archive * bmx_libarchive_write_archive_new() {
	return archive_write_new();
}

int bmx_libarchive_archive_write_open_memory(struct archive * arc, void * buf, int size, size_t * used) {
	return archive_write_open_memory(arc, buf, size, used);
}

int bmx_libarchive_archive_write_data(struct archive * arc, void * buf, size_t size) {
	return archive_write_data(arc, buf, size);
}

int bmx_libarchive_archive_write_header(struct archive * arc, struct archive_entry * entry) {
	return archive_write_header(arc, entry);
}

int bmx_libarchive_archive_write_close(struct archive * arc) {
	return archive_write_close(arc);
}

int bmx_libarchive_archive_write_free(struct archive * arc) {
	return archive_write_free(arc);
}

int bmx_libarchive_archive_write_finish_entry(struct archive * arc) {
	return archive_write_finish_entry(arc);
}

int bmx_libarchive_archive_write_set_passphrase(struct archive * arc, BBString * passphrase) {
	char * p = bbStringToUTF8String(passphrase);
	int ret = archive_write_set_passphrase(arc, p);
	bbMemFree(p);
	return ret;
}

int bmx_libarchive_archive_write_set_filter_option(struct archive * arc, BBString * option, BBString * value, BBString * moduleName) {
	char * o = 0;
	char * v = 0;
	char * m = 0;

	if (option != &bbEmptyString) {
		o = bbStringToUTF8String(option);
	}

	if (value != &bbEmptyString) {
		v = bbStringToUTF8String(value);
	}

	if (moduleName != &bbEmptyString) {
		m = bbStringToUTF8String(moduleName);
	}

	int ret = archive_write_set_filter_option(arc, o, v, m);

	bbMemFree(m);
	bbMemFree(v);
	bbMemFree(o);

	return ret;
}

int bmx_libarchive_archive_write_set_format_option(struct archive * arc, BBString * option, BBString * value, BBString * moduleName) {
	char * o = 0;
	char * v = 0;
	char * m = 0;

	if (option != &bbEmptyString) {
		o = bbStringToUTF8String(option);
	}

	if (value != &bbEmptyString) {
		v = bbStringToUTF8String(value);
	}

	if (moduleName != &bbEmptyString) {
		m = bbStringToUTF8String(moduleName);
	}

	int ret = archive_write_set_format_option(arc, m, o, v);

	bbMemFree(m);
	bbMemFree(v);
	bbMemFree(o);

	return ret;
}

int bmx_libarchive_archive_write_open(struct archive * arc, BBObject * data) {
	archive_write_set_bytes_in_last_block(arc, 1);
	return archive_write_open(arc, data, bmx_libarchive_open_cb, bmx_libarchive_write_cb, bmx_libarchive_close_cb);
}

int bmx_libarchive_archive_write_set_option(struct archive * arc, BBString * option, BBString * value, BBString * moduleName) {
	char * o = 0;
	char * v = 0;
	char * m = 0;

	if (option != &bbEmptyString) {
		o = bbStringToUTF8String(option);
	}

	if (value != &bbEmptyString) {
		v = bbStringToUTF8String(value);
	}

	if (moduleName != &bbEmptyString) {
		m = bbStringToUTF8String(moduleName);
	}

	int ret = archive_write_set_option(arc, m, o, v);

	bbMemFree(m);
	bbMemFree(v);
	bbMemFree(o);

	return ret;
}

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++ */

void bmx_libarchive_archive_clear_error(struct archive * arc) {
	archive_clear_error(arc);
}

int bmx_libarchive_archive_errno(struct archive * arc) {
	return archive_errno(arc);
}

BBString * bmx_libarchive_archive_error_string(struct archive * arc) {
	return bbStringFromCString(archive_error_string(arc));
}

int bmx_libarchive_archive_file_count(struct archive * arc) {
	return archive_file_count(arc);
}

int bmx_libarchive_archive_filter_code(struct archive * arc, int filter) {
	return archive_filter_code(arc, filter);
}

int bmx_libarchive_archive_filter_count(struct archive * arc) {
	return archive_filter_count(arc);
}

BBString * bmx_libarchive_archive_filter_name(struct archive * arc, int filter) {
	return bbStringFromCString(archive_filter_name(arc, filter));
}

int bmx_libarchive_archive_format(struct archive * arc) {
	return archive_format(arc);
}

BBString * bmx_libarchive_archive_format_name(struct archive * arc) {
	return bbStringFromCString(archive_format_name(arc));
}

void bmx_libarchive_archive_position(struct archive * arc, int filter, BBInt64 * v) {
	*v = archive_filter_bytes(arc, filter);
}


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++ */

struct archive_entry * bmx_libarchive_archive_entry_new() {
	return archive_entry_new();
}

void bmx_libarchive_archive_entry_free(struct archive_entry * entry) {
	archive_entry_free(entry);
}

struct archive_entry * bmx_libarchive_archive_entry_clear(struct archive_entry * entry) {
	return archive_entry_clear(entry);
}

struct archive_entry * bmx_libarchive_archive_entry_clone(struct archive_entry * entry) {
	return archive_entry_clone(entry);
}

BBString * bmx_libarchive_archive_entry_hardlink(struct archive_entry * entry) {
	return bbStringFromUTF8String(archive_entry_hardlink(entry));
}

BBString * bmx_libarchive_archive_entry_sourcepath(struct archive_entry * entry) {
	return bbStringFromUTF8String(archive_entry_sourcepath(entry));
}

BBString * bmx_libarchive_archive_entry_symlink(struct archive_entry * entry) {
	return bbStringFromUTF8String(archive_entry_symlink_utf8(entry));
}

BBString * bmx_libarchive_archive_entry_pathname(struct archive_entry * entry) {
	return bbStringFromUTF8String(archive_entry_pathname_utf8(entry));
}

void bmx_libarchive_archive_entry_set_link(struct archive_entry * entry, BBString * path) {
	char * n = bbStringToUTF8String(path);
	archive_entry_set_link(entry, n);
	bbMemFree(n);
}

void bmx_libarchive_archive_entry_set_pathname(struct archive_entry * entry, BBString * path) {
	char * n = bbStringToUTF8String(path);
	archive_entry_set_pathname_utf8(entry, n);
	archive_entry_set_pathname(entry, n);
	bbMemFree(n);
}

void bmx_libarchive_archive_entry_set_sourcepath(struct archive_entry * entry, BBString * path) {
	char * n = bbStringToUTF8String(path);
	archive_entry_copy_sourcepath(entry, n);
	bbMemFree(n);
}

void bmx_libarchive_archive_entry_set_symlink(struct archive_entry * entry, BBString * path) {
	char * n = bbStringToUTF8String(path);
	archive_entry_set_symlink(entry, n);
	bbMemFree(n);
}

void bmx_libarchive_archive_entry_set_size(struct archive_entry * entry, BBInt64 size) {
	archive_entry_set_size(entry, size);
}

void bmx_libarchive_archive_entry_unset_size(struct archive_entry * entry) {
	archive_entry_unset_size(entry);
}

void  bmx_libarchive_archive_entry_set_ctime(struct archive_entry * entry, time_t time, BBInt64 nanoseconds) {
	archive_entry_set_ctime(entry, time, nanoseconds);
}

void  bmx_libarchive_archive_entry_set_mtime(struct archive_entry * entry, time_t time, BBInt64 nanoseconds) {
	archive_entry_set_mtime(entry, time, nanoseconds);
}

void bmx_libarchive_archive_entry_set_filetype(struct archive_entry * entry, int filetype) {
	archive_entry_set_filetype(entry, filetype);
}

void bmx_libarchive_archive_entry_set_perm(struct archive_entry * entry, int perm) {
	archive_entry_set_perm(entry, perm);
}

int bmx_libarchive_archive_entry_is_data_encrypted(struct archive_entry * entry) {
	return archive_entry_is_data_encrypted(entry);
}

int bmx_libarchive_archive_entry_is_metadata_encrypted(struct archive_entry * entry) {
	return archive_entry_is_metadata_encrypted(entry);
}

int bmx_libarchive_archive_entry_is_encrypted(struct archive_entry * entry) {
	return archive_entry_is_encrypted(entry);
}

int bmx_libarchive_archive_entry_size_is_set(struct archive_entry * entry) {
	return archive_entry_size_is_set(entry);
}

BBInt64 bmx_libarchive_archive_entry_size(struct archive_entry * entry) {
	return archive_entry_size(entry);
}
