#ifndef UNUSED_H
#define UNUSED_H

#ifdef UNUSED
#elif defined(__GNUC__)
#define UNUSED(x) UNUSED_##x __attribute__((unused))
#elif defined(__LCLINT__)
#define UNUSED(x) /*@unused@*/ x
#else
#define UNUSED(x) x
#endif

#define SUCCESS 1
#define FAILURE 0

NORETURN(void raise_last_exception());
void save_exception(VALUE exception, const char *fmt, ...);
int with_exception(VALUE exception, const char *fmt, ...);
int with_exception_errno(VALUE exception, const char *fmt, ...);

#endif
