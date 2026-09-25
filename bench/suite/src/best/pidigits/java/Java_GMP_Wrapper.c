/*
 * JNI glue for the Benchmarks Game pidigits Java #3 program (class
 * Java_GMP_Wrapper). The original Include/java C source is not published, so
 * this is a minimal re-implementation: each native method forwards directly to
 * the GMP function of the same name, with mpz_t pointers carried as jlong.
 */
#include <jni.h>
#include <stdint.h>
#include <stdlib.h>
#include <gmp.h>

#define P(x) ((mpz_ptr)(intptr_t)(x))

JNIEXPORT jlong JNICALL Java_Java_1GMP_1Wrapper_allocate_1mpz_1t(JNIEnv *e, jclass c) {
    return (jlong)(intptr_t)malloc(sizeof(__mpz_struct));
}
JNIEXPORT void JNICALL Java_Java_1GMP_1Wrapper_mpz_1add(JNIEnv *e, jclass c, jlong r, jlong a, jlong b) {
    mpz_add(P(r), P(a), P(b));
}
JNIEXPORT void JNICALL Java_Java_1GMP_1Wrapper_mpz_1addmul_1ui(JNIEnv *e, jclass c, jlong r, jlong a, jlong b) {
    mpz_addmul_ui(P(r), P(a), (unsigned long)b);
}
JNIEXPORT jint JNICALL Java_Java_1GMP_1Wrapper_mpz_1cmp(JNIEnv *e, jclass c, jlong a, jlong b) {
    return mpz_cmp(P(a), P(b));
}
JNIEXPORT jlong JNICALL Java_Java_1GMP_1Wrapper_mpz_1get_1ui(JNIEnv *e, jclass c, jlong a) {
    return (jlong)mpz_get_ui(P(a));
}
JNIEXPORT void JNICALL Java_Java_1GMP_1Wrapper_mpz_1init_1set_1ui(JNIEnv *e, jclass c, jlong r, jlong v) {
    mpz_init_set_ui(P(r), (unsigned long)v);
}
JNIEXPORT void JNICALL Java_Java_1GMP_1Wrapper_mpz_1mul_1ui(JNIEnv *e, jclass c, jlong r, jlong a, jlong b) {
    mpz_mul_ui(P(r), P(a), (unsigned long)b);
}
JNIEXPORT void JNICALL Java_Java_1GMP_1Wrapper_mpz_1submul_1ui(JNIEnv *e, jclass c, jlong r, jlong a, jlong b) {
    mpz_submul_ui(P(r), P(a), (unsigned long)b);
}
JNIEXPORT void JNICALL Java_Java_1GMP_1Wrapper_mpz_1tdiv_1q(JNIEnv *e, jclass c, jlong q, jlong n, jlong d) {
    mpz_tdiv_q(P(q), P(n), P(d));
}
