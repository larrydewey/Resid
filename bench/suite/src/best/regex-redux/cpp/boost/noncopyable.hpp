// Minimal stand-in for boost/noncopyable.hpp (Boost headers are not installed
// on the benchmark host). Provides the single class the program uses, with the
// same semantics: derived classes cannot be copied or copy-assigned.
#ifndef BENCH_SHIM_BOOST_NONCOPYABLE_HPP
#define BENCH_SHIM_BOOST_NONCOPYABLE_HPP
namespace boost {
class noncopyable {
  protected:
    noncopyable() = default;
    ~noncopyable() = default;
    noncopyable(const noncopyable &) = delete;
    noncopyable &operator=(const noncopyable &) = delete;
};
} // namespace boost
#endif
