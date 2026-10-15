import resource, subprocess, sys, time
t = time.time()
r = subprocess.run(['systemd-run', '--user', '--scope', '-q', '-p', 'MemoryMax=4G', '-p', 'MemorySwapMax=0', '-p', 'CPUQuota=100%', 'nice', '-n', '19'] + sys.argv[1:], capture_output=True, text=True, timeout=900)
ru = resource.getrusage(resource.RUSAGE_CHILDREN)
print(f'rc={r.returncode} seconds={time.time()-t:.0f} peak_rss_mb={ru.ru_maxrss//1024}')
print(r.stdout[:600]); print(r.stderr[:300])
