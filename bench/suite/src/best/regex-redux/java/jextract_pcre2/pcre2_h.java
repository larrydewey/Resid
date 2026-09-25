// Minimal hand-written stand-in for the jextract-generated PCRE2 bindings the
// Benchmarks Game regexredux Java #2 program is compiled against (the generated
// Include/java sources are not published). Only the symbols that program uses
// are provided, bound with the java.lang.foreign (FFM) API to libpcre2-8.
package jextract_pcre2;

import java.lang.foreign.Arena;
import java.lang.foreign.FunctionDescriptor;
import java.lang.foreign.Linker;
import java.lang.foreign.MemorySegment;
import java.lang.foreign.SymbolLookup;
import java.lang.foreign.ValueLayout;
import java.lang.invoke.MethodHandle;

import static java.lang.foreign.ValueLayout.ADDRESS;
import static java.lang.foreign.ValueLayout.JAVA_INT;
import static java.lang.foreign.ValueLayout.JAVA_LONG;

public final class pcre2_h {
    private pcre2_h() {}

    public static final ValueLayout.OfLong int64_t = JAVA_LONG;

    private static final Linker LINKER = Linker.nativeLinker();
    private static final SymbolLookup LIB = SymbolLookup.libraryLookup("libpcre2-8.so.0", Arena.global());

    private static MethodHandle h(String name, FunctionDescriptor fd) {
        return LINKER.downcallHandle(LIB.find(name).orElseThrow(), fd);
    }

    private static final MethodHandle COMPILE = h("pcre2_compile_8",
            FunctionDescriptor.of(ADDRESS, ADDRESS, JAVA_LONG, JAVA_INT, ADDRESS, ADDRESS, ADDRESS));
    private static final MethodHandle JIT_COMPILE = h("pcre2_jit_compile_8",
            FunctionDescriptor.of(JAVA_INT, ADDRESS, JAVA_INT));
    private static final MethodHandle JIT_MATCH = h("pcre2_jit_match_8",
            FunctionDescriptor.of(JAVA_INT, ADDRESS, ADDRESS, JAVA_LONG, JAVA_LONG, JAVA_INT, ADDRESS, ADDRESS));
    private static final MethodHandle MATCH_DATA_CREATE = h("pcre2_match_data_create_8",
            FunctionDescriptor.of(ADDRESS, JAVA_INT, ADDRESS));
    private static final MethodHandle GET_OVECTOR_POINTER = h("pcre2_get_ovector_pointer_8",
            FunctionDescriptor.of(ADDRESS, ADDRESS));
    private static final MethodHandle SUBSTITUTE = h("pcre2_substitute_8",
            FunctionDescriptor.of(JAVA_INT, ADDRESS, ADDRESS, JAVA_LONG, JAVA_LONG, JAVA_INT, ADDRESS, ADDRESS,
                    ADDRESS, JAVA_LONG, ADDRESS, ADDRESS));
    private static final MethodHandle GET_ERROR_MESSAGE = h("pcre2_get_error_message_8",
            FunctionDescriptor.of(JAVA_INT, JAVA_INT, ADDRESS, JAVA_LONG));

    public static MemorySegment NULL() { return MemorySegment.NULL; }
    public static int PCRE2_ERROR_NOMATCH() { return -1; }
    public static int PCRE2_SUBSTITUTE_GLOBAL() { return 0x00000100; }
    public static int PCRE2_NO_UTF_CHECK() { return 0x40000000; }
    public static int PCRE2_JIT_COMPLETE() { return 0x00000001; }

    private static RuntimeException fail(Throwable t) {
        return t instanceof RuntimeException r ? r : new RuntimeException(t);
    }

    public static MemorySegment pcre2_compile_8(MemorySegment pattern, long length, int options,
            MemorySegment errorCode, MemorySegment errorOffset, MemorySegment ccontext) {
        try { return (MemorySegment) COMPILE.invokeExact(pattern, length, options, errorCode, errorOffset, ccontext); }
        catch (Throwable t) { throw fail(t); }
    }

    public static int pcre2_jit_compile_8(MemorySegment code, int options) {
        try { return (int) JIT_COMPILE.invokeExact(code, options); }
        catch (Throwable t) { throw fail(t); }
    }

    public static int pcre2_jit_match_8(MemorySegment code, MemorySegment subject, long length,
            long startOffset, int options, MemorySegment matchData, MemorySegment mcontext) {
        try { return (int) JIT_MATCH.invokeExact(code, subject, length, startOffset, options, matchData, mcontext); }
        catch (Throwable t) { throw fail(t); }
    }

    public static MemorySegment pcre2_match_data_create_8(int ovecsize, MemorySegment gcontext) {
        try { return (MemorySegment) MATCH_DATA_CREATE.invokeExact(ovecsize, gcontext); }
        catch (Throwable t) { throw fail(t); }
    }

    public static MemorySegment pcre2_get_ovector_pointer_8(MemorySegment matchData) {
        try { return (MemorySegment) GET_OVECTOR_POINTER.invokeExact(matchData); }
        catch (Throwable t) { throw fail(t); }
    }

    public static int pcre2_substitute_8(MemorySegment code, MemorySegment subject, long length,
            long startOffset, int options, MemorySegment matchData, MemorySegment mcontext,
            MemorySegment replacement, long rlength, MemorySegment outputBuffer, MemorySegment outLengthPtr) {
        try {
            return (int) SUBSTITUTE.invokeExact(code, subject, length, startOffset, options, matchData, mcontext,
                    replacement, rlength, outputBuffer, outLengthPtr);
        } catch (Throwable t) { throw fail(t); }
    }

    public static int pcre2_get_error_message_8(int errorCode, MemorySegment buffer, long bufflen) {
        try { return (int) GET_ERROR_MESSAGE.invokeExact(errorCode, buffer, bufflen); }
        catch (Throwable t) { throw fail(t); }
    }
}
