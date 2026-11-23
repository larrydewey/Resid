// ring.c — the C baseline for runtime/rt/ringbench.resid (see run.sh).
// -DRMW reads the ring with an atomic add of zero, as the Resid version must.
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <sched.h>
#include <time.h>
#include <stdatomic.h>
#include <sys/mman.h>
#include <sys/eventfd.h>
#include <sys/wait.h>
typedef struct { _Atomic int64_t req; char p[56]; _Atomic int64_t ack; char p2[56]; int64_t sum; char p3[3960]; int64_t buf[131072]; } sh_t;
static int64_t now(){struct timespec t;clock_gettime(CLOCK_MONOTONIC,&t);return t.tv_sec*1000000000LL+t.tv_nsec;}
static void pin(int c){cpu_set_t s;CPU_ZERO(&s);CPU_SET(c,&s);sched_setaffinity(0,sizeof s,&s);}
static int encode(int64_t*b,int64_t cap,int n){for(int64_t j=0;j<n;j++){int64_t o=j*64;if(o<0||o+64>cap)return -1;int64_t*p=b+j*8;p[0]=j&255;p[1]=j;p[2]=j+1;p[3]=j+2;p[4]=j*3;p[5]=7;p[6]=j^85;p[7]=j+j;}return 0;}
#ifdef RMW
#undef atomic_load
#define atomic_load(p) atomic_fetch_add(p,0)
#endif
int main(){
  sh_t*s=mmap(0,sizeof*s,PROT_READ|PROT_WRITE,MAP_SHARED|MAP_ANONYMOUS,-1,0); int n=1000000;
  pid_t p=fork();
  if(!p){pin(2);int64_t seen=0;for(;;){int64_t r=atomic_load(&s->req);if(r==-1)_exit(0);if(r!=seen){seen=r;atomic_store(&s->ack,r);}}}
  pin(0);int64_t t=now();
  for(int64_t i=1;i<=n;i++){atomic_store(&s->req,i);while(atomic_load(&s->ack)!=i);}
  printf("c     polling ring, two cores      mean %ld ns\n",(long)((now()-t)/n));
  atomic_store(&s->req,-1);waitpid(p,0,0);atomic_store(&s->req,0);atomic_store(&s->ack,0);
  int a=eventfd(0,0),b=eventfd(0,0),m=100000;uint64_t x;
  p=fork();
  if(!p){pin(2);for(;;){if(read(a,&x,8)!=8||x==99)_exit(0);x=1;if(write(b,&x,8)!=8)_exit(1);}}
  t=now();for(int i=0;i<m;i++){x=1;if(write(a,&x,8)!=8||read(b,&x,8)!=8)return 1;}
  printf("c     sleeping wake, two cores     mean %ld ns\n",(long)((now()-t)/m));
  x=99;if(write(a,&x,8)!=8)return 1;waitpid(p,0,0);
  int k=2000;t=now();for(int i=0;i<k;i++){encode(s->buf,1048576,10000);__asm__ volatile("":::"memory");}
  printf("c     encode 10k cmds, no crossing mean %ld ns\n",(long)((now()-t)/k));
  t=now();for(int i=0;i<k;i++){encode(s->buf,1048576,10000);__asm__ volatile("":::"memory");int64_t acc=0;for(int j=0;j<10000;j++)acc+=s->buf[j*8]+s->buf[j*8+7];s->sum=acc;__asm__ volatile("":::"memory");}
  printf("c     encode+consume, one process  mean %ld ns\n",(long)((now()-t)/k));
  p=fork();
  if(!p){pin(2);int64_t seen=0;for(;;){int64_t r=atomic_load(&s->req);if(r==-1)_exit(0);if(r!=seen){seen=r;int64_t acc=0;for(int j=0;j<10000;j++)acc+=s->buf[j*8]+s->buf[j*8+7];s->sum=acc;atomic_store(&s->ack,r);}}}
  t=now();for(int64_t i=1;i<=k;i++){encode(s->buf,1048576,10000);atomic_store(&s->req,i);while(atomic_load(&s->ack)!=i);}
  printf("c     frame: encode+cross+consume  mean %ld ns\n",(long)((now()-t)/k));
  atomic_store(&s->req,-1);waitpid(p,0,0);return 0;}
