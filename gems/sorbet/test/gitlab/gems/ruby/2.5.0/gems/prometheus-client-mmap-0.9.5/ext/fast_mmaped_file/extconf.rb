require 'mkmf'
require 'fileutils'

$CFLAGS << ' -std=c99 -D_POSIX_C_SOURCE=200809L -Wall -Wextra'

if enable_config('fail-on-warning')
  $CFLAGS << ' -Werrno'
end

if enable_config('debug')
  $CFLAGS << ' -O0 -g'
end

if enable_config('address-sanitizer')
  $CFLAGS << ' -O -fsanitize=address -fno-omit-frame-pointer -g'
end

CONFIG['warnflags'].slice!(/ -Wdeclaration-after-statement/)

cwd = File.expand_path(File.dirname(__FILE__))
vendor_dir = File.join(cwd, '../../vendor/c')
src_dir = File.join(cwd, '../../ext/fast_mmaped_file')

src_files = %W[#{vendor_dir}/jsmn/jsmn.c #{vendor_dir}/hashmap/src/hashmap.c]
FileUtils.cp(src_files, src_dir)

$INCFLAGS << " -I#{vendor_dir}/jsmn -I#{vendor_dir}/hashmap/src"

dir_config('fast_mmaped_file')
create_makefile('fast_mmaped_file')
