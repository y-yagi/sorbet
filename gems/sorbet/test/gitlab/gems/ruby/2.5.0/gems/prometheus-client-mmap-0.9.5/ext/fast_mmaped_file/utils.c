#include <errno.h>
#include <ruby.h>

#include "utils.h"

static void rb_save_exception(VALUE exception, VALUE message) {
    VALUE current_thread = rb_thread_current();

    rb_thread_local_aset(current_thread, rb_intern("prometheus_last_exception"), exception);
    rb_thread_local_aset(current_thread, rb_intern("prometheus_last_exception_message"), message);
}
/* @deprecated - use with_exception ignoring return value */
void save_exception(VALUE exception, const char *fmt, ...) {
    va_list args;

    va_start(args, fmt);
    VALUE message = rb_vsprintf(fmt, args);

    rb_save_exception(exception, message);
    va_end(args);
}

int with_exception(VALUE exception, const char *fmt, ...) {
    va_list args;

    va_start(args, fmt);
    VALUE message = rb_vsprintf(fmt, args);

    rb_save_exception(exception, message);
    va_end(args);

    return FAILURE;
}

int with_exception_errno(VALUE exception, const char *fmt, ...) {
    va_list args;

    va_start(args, fmt);
    VALUE message = rb_vsprintf(fmt, args);
    rb_str_catf(message, " (%s)", strerror(errno));

    rb_save_exception(exception, message);
    va_end(args);

    return FAILURE;
}

NORETURN(void raise_last_exception()) {
    VALUE current_thread = rb_thread_current();
    VALUE exception = rb_thread_local_aref(current_thread, rb_intern("prometheus_last_exception"));
    VALUE message = rb_thread_local_aref(current_thread, rb_intern("prometheus_last_exception_message"));
    if (exception != Qnil) {
        rb_raise(exception, "%s", StringValueCStr(message));
    } else {
        rb_raise(rb_eRuntimeError, "no exception found in thread local");
    }
}
