/* Float text without libc (runtime/rt/floattext.resid) matches glibc
 * exactly: snprintf %.<P>g / %.<P>f and strtod (values, and where parsing
 * stops) on random and edge-case inputs. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <math.h>
double resid_ft_strtod(const char* s, char** e);
int resid_ft_strfromd(char* b, int64_t n, const char* f, double v);
static uint64_t rs = 0x9E3779B97F4A7C15ULL;
static uint64_t xr(void) { rs ^= rs << 13; rs ^= rs >> 7; rs ^= rs << 17; return rs; }
static long bad = 0;
static void chkfmt(const char* f, double v) {
    char a[2100], b[2100];
    int na = snprintf(a, sizeof a, f, v);
    int nb = resid_ft_strfromd(b, sizeof b, f, v);
    if (na != nb || strcmp(a, b) != 0) { if (bad < 15) printf("fmt %s %a: glibc '%s' ours '%s'\n", f, v, a, b); bad++; }
}
static void chkparse(const char* s) {
    char *ea, *eb;
    double a = strtod(s, &ea), b = resid_ft_strtod(s, &eb);
    uint64_t x, y; memcpy(&x, &a, 8); memcpy(&y, &b, 8);
    if (x != y || ea != eb) { if (bad < 15) printf("parse '%s': glibc %a (+%ld) ours %a (+%ld)\n", s, a, (long)(ea - s), b, (long)(eb - s)); bad++; }
}
int main(int argc, char** argv) {
    long n = argc > 1 ? atol(argv[1]) : 30000;
    const char* fmts[] = {"%.17g", "%.0f", "%.3f", "%.1g", "%.6g", "%.20f"};
    double edge[] = {0.0, -0.0, 1.0, 0.5, 1.5, 2.5, -2.5, 0.125, 1e300, 1e-300, 5e-324, 2.2250738585072014e-308, 1.7976931348623157e308, 0.1, 0.2, 0.3, 1e21, 1e22, 1e23, 123456789012345678.0, 9.999999999999999e22, 0.0005, 0.0015, 0.00049999, 999.9995, INFINITY, -INFINITY, NAN, -NAN, 1e-5, 1e-4, 1e16, 1e17};
    for (unsigned i = 0; i < sizeof edge / sizeof edge[0]; i++) for (int f = 0; f < 6; f++) chkfmt(fmts[f], edge[i]);
    for (long i = 0; i < n; i++) {
        uint64_t b = xr(); double v; memcpy(&v, &b, 8);
        chkfmt("%.17g", v);
        if ((i & 7) == 0) { chkfmt("%.3f", v); chkfmt("%.0f", v); }
        double w = (double)(int64_t)(xr() % 2000000) / 1000.0 - 1000.0;
        chkfmt("%.3f", w); chkfmt("%.0f", w); chkfmt("%.17g", w);
        char s[64]; snprintf(s, sizeof s, "%.17g", v); chkparse(s);
        snprintf(s, sizeof s, "%.15g", v); chkparse(s);
    }
    /* random decimal strings */
    for (long i = 0; i < n; i++) {
        char s[128]; int k = 0;
        if (xr() & 1) s[k++] = '-';
        int nd = 1 + xr() % 30;
        for (int j = 0; j < nd; j++) s[k++] = '0' + xr() % 10;
        if (xr() & 1) { s[k++] = '.'; int nf = xr() % 25; for (int j = 0; j < nf; j++) s[k++] = '0' + xr() % 10; }
        if (xr() & 1) { s[k++] = 'e'; if (xr() & 1) s[k++] = '-'; k += sprintf(s + k, "%d", (int)(xr() % 340)); }
        s[k] = 0; chkparse(s);
    }
    const char* ss[] = {"  12.5", "\t-3", "inf", "-Infinity", "nan", "NaN(abc)", "nan(", "0x1.8p3", "0X.8P-2", "0x", "1e", "1e+", ".5", "5.", ".", "-", "", "1e400", "1e-400", "2.4703282292062327e-324", "2.4703282292062328e-324", "0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000024703282292062327208828439643411068618252990130716238221279284125033775363510437593264991818081799618989828234772285886546332835517796989819938739800539093906315035659515570226392290858392449105184435931802849936536152500319370457678249219365623669863658480757001585769269903706311928279558551332927834338409351978015531246597263579574622766465272827220056374006485499977096599470454020828166226237857393450736339007967761930577506740176324673600968951340535537458516661134223766678604162159680461914467291840300530057530849048765391711386591646239524912623653881879636239373280423891018672348497668235089863388587925628302755995657524455507255189313690836254779186948667994968324049705821028513185451396213837722826145437693412532098591327667236328125e-300", "123456789012345678901234567890123456789012345678901234567890e-10", "0.1e1", "00001", "1_000"};
    for (unsigned i = 0; i < sizeof ss / sizeof ss[0]; i++) chkparse(ss[i]);
    printf("float_text: %ld mismatches\n", bad);
    return bad != 0;
}
