## 2.3 编写并使用程序库 ##

将 test1.o 和 test2.o 合并成一个 libtest.a 存档：

    % ar cr libtest.a test1.o test2.o

这里 –shared 选项通知链接器生成共享库，而不是生成普通的可执行文件。共享库文件通常使用 .so 作为后缀名，这里 so 表示共享对象 shared object）。与静态库文件相同，文件名以 lib 开头，表示这是一个程序库文件。要创建一个共享库，你必须在编译那些用于生成共享库的对象时为编译器指定 –fPIC选项。

    % gcc –c –fPIC test1.c

然后你将得到的对象文件合并成一个共享库：

    % gcc –shared –fPIC –o libtest.so test1.o test2.o

对链接器指定 –static 选项表示你希望使用静态版本。

    % gcc –static –o app app.o –L. –ltest

如果某个链接到程序中的共享库被安装在这些目录之外的地方，系统将无法找到这个共享库，并因此拒绝执行你的程序。一种解决方法是在链接的时候指明 –Wl,-rpath 参数。假设你用下面的命令进行链接：

    % gcc –o app app.o –L. –ltest –Wl,-rpath,/usr/local/lib

1. 假设我们将LD_LIBRARY_PATH设为 /usr/local/lib:/opt/lib， 则系统会在搜索默认路径 /lib和/usr/lib之前搜索 /usr/local/lib和 /opt/lib目录。
2. 如果在编译程序的时候设定了LD_LIBRARY_PATH环境变量，链接器会在搜索 –L参数指定的路径之前搜索这个环境变量中指定的路径以寻找库文件。

要在编译时将这个程序链接到 libtiff 则应在链接程序命令行中指定 –ltiff：

    % gcc –o tifftest tifftest.c –ltiff

可以用 ldd 命令显示与一个程序建立了动态链接的库的列表。

    % ldd tifftest
    libtiff.so.3 => /usr/lib/libtiff.so.3 (0x4001d000)
    libc.so.6 => /lib/libc.so.6 (0x40060000
    libjpeg.so.62 => /usr/lib/libjpeg.so.62 (0x40155000)
    libz.so.1 => /usr/lib/libz.so.1 (0x40174000)
    /lib/ld-linux.so.2 => /lib/ld-linux.so.2 (0x40000000)

1. libtiff 会引用 libjpeg 和 libz，这两个库的共享库版本也会被引入（共享库可以指向自己依赖的其它共享库）。
1. 静态库无法指向其它的库。如果你决定通过指定 –static 参数，将程序与静态版本的 libtiff 链接时，你会得到这些关于“无法解析的符号”的错误信息。

两个库可能互相依赖。也就是说，第一个库可能引用了第二个库中定义的符号，你可以在命令行中多次指定同一个库。链接器会在每次读取到这个库的时候重新查找库中的符号。

    % gcc –o app app.o –lfoo –lbar –lfoo

运行的时候将自动加载这些库中的代码。

    dlopen (“libtest.so”, RTLD_LAZY);
    void* handle = dlopen (“libtest.so”, RTLD_LAZY);
    void (*test)() = dlsym (handle, “my_function”);
    (*test)();
    dlclose (handle);

# 第三章：进程 #

## 3.2.1 使用 system ##

    #include <stdlib.h>
    int main ()
    {
    int return_value;
    return_value = system ("ls -l /");
    return return_value;
    }

## **3.2.2 使用 fork 和 exec** ##

一个进程通过调用 fork 会创建一个被称为子进程的副本进程。父进程从调用 fork 的地
方继续执行；子进程也一样。

    #include <stdio.h>
    #include <sys/types.h>
    #include <unistd.h>
    int main ()
    {
	    pid_t child_pid;
	    printf ("the main program process ID is %d\n", (int) getpid());
	    child_pid = fork ();
	    if (child_pid != 0) {
		    printf ("this is the parent process, with id %d\n", (int)
		    getpid ());
		    printf ("the child's process ID is %d\n", (int) child_pid);
	    }
	    else
	    	printf ("this is the child process, with id %d\n", (int)
	    getpid ());
	    return 0;
    }


Exec 族函数用一个程序替换当前进程中正在运行的程序。当某个 exec 族的函数被调用时，如果没有出现错误的话，调用程序会被立刻中止，而新的程序则从头开始运行。

**将 fork 和 exec 结合使用**


    	#include <stdio.h>
    	#include <stdlib.h>
    	#include <sys/types.h>
    	#include <unistd.h>
    /* 产生一个新进程运行新的程序。 PAORGAM 是要运行的程序的名字；系统会在
    执行路径中搜索这个程序运行。 ARG_LIST 是一个以 NULL 指针结束的字符串列表，
    用作程序的参数列表。返回新进程的 ID。 */
    int spawn (char* program, char** arg_list)
    {
	    pid_t child_pid;
	    /* 复制当前进程。 */
	    child_pid = fork ();
	    if (child_pid != 0)
	    /* 这里是父进程。 */
	    return child_pid;
	    else {
		    /* 现在从执行路径中查找并执行 PROGRAM。 */
		    execvp (program, arg_list);
		    /* execvp 函数仅当出现错误的时候才返回。 */
		    fprintf (stderr, "an error occurred in execvp\n");
		    abort ();
		    }
	    }
	    int main ()
	    {
		    /* 准备传递给 ls 命令的参数列表 */
		    char* arg_list[] = {
		    "ls", /* argv[0], 程序的名称 */
		    "-l",
		    "/",
		    NULL /* 参数列表必须以 NULL 指针结束 */
	    };
	    /* 建立一个新进程运行 ls 命令。忽略返回的进程 ID */
	    spawn ("ls", arg_list);
	    printf ("done with main program\n");
	    return 0;
    }

## 3.3 信号 ##

信号（ Signal） 是 Linux 系统中用于进程之间相互通信或操作的一种机制。信号是一个发送到进程的特殊信息。信号机制是异步的；当一个进程接收到一个信号时，它会立刻处理这个信号，而不会等待当前函数甚至当前一行代码结束运行。 当一个进程接收到信号，基于不同的处理方式（ disposition），该进程可能执行几种不同操作中的一种。对于多数种类的信号， 程序都可以自由指定一个处理方式——程序可以选择忽略这个信号，或者调用一个特定的信号处理函数。如果指定了一个信号处理函数，当前程序会暂停当前的执行过程，同时开始执行信号处理函数， 并且当信号处理函数返回之后再从被暂停处继续执行。

**Linux 系统在运行中出现特殊状况的时候也会向进程发送信号通知。非法操作收到：**

1.  SIGBUS （主线错误）， 
1. SIGSEGV （段溢出错误）
1.  SIGFPE（浮点异常）

**一个进程除了响应系统发来的信号，还可以向其它进程发送信号。**
SIGTERM或SIGKILL信号来结束其它进程。

**向运行中的进程发送命令。**
两个“用户自定义”的信号SIGUSR1 和SIGUSR2。

**SIGHUP信号有时也用于这个目的——通常用于唤醒一个处于等待状态的进程或者使进程重新读取配置文件。**


**这两个 sigaction 结构中最重要的都是 sa_handler 域。它可以是下面三个值：**

1. · SIG_DFL，指定默认的信号处理方式
1. · SIG_IGN，指定该信号将被忽略
1. · 一个指向信号处理函数的指针。这个函数应该接受信号值作为唯一参数，

因为信号处理是异步进行的，当信号处理函数被调用的时候，主程序可能处在非常脆弱的状态， 并且这个状态会一直保持到信号处理函数结束。应该尽量避免在信号处理函数中使用输入输出功能、绝大多数库函数和系统调用。

**信号处理函数也可能被其它信号的到达所打断。**

甚至于对全局变量赋值可能也是不安全的，因为一个赋值操作可能由两个或更多机器指令完成，而在这些指令执行期间可能会有第二个信号到达，致使被修改的全局变量处于不完整的状态。如果你需要从信号处理函数中设置全局标志以记录信号的到达，这个标志必须是特殊类型 **sig_atomic_t**  的实例。 

**使用信号处理函数：**

    #include <signal.h>
    #include <stdio.h>
    #include <string.h>
    #include <sys/types.h>
    #include <unistd.h>
    sig_atomic_t sigusr1_count = 0;
    void handle (int signal_number)
    {
    	++sigusr1_count;
    }
    int main ()
    {
	    struct sigaction sa;
	    memset (&sa, 0, sizeof (sa));
	    sa.sa_handler = &handler;
	    sigaction (SIGUSR1, &sa, NULL);
	    /* 这里可以执行一些长时间的工作。 */
	    /* ... */
	    printf ("SIGUSR1 was raised %d times\n", sigusr1_count);
	    return 0;
    }


## 3.4 进程终止 ##

1. 进程会以两种情况的之一结束：调用 exit 函数退出或从 main 函数返回。
1. SIGBUS， SIGSEGV 和SIGFPE 信号的出现会导致进程结束。其它信号也可能显式结束进程。
1. 当用户在终端按下Ctrl+C 时会发送一个 SIGINT 信号给进程。 SIGTERM 信号由 kill 命令发送。
1. 这两个信号的默认处理方式都是结束进程。进程通过调用 abort 函数给自己发送一个 SIGABRT 信号，导致自身中止运行并且产生一个 core file。
1. 最强有力的终止信号是 SIGKILL，它会导致进程立刻终止，而且这个信号无法被阻止或被程序自主处理。

## 3.4.1 等待进程结束 ##

- 主程序可能希望暂停运行以等待子进程完成任务。可以通过 wait族系统调用实现这一功能。
- WEXITSTATUS 宏可以提取子进程的退出值。
- WIFEXITED 宏从一个子进程的返回状态中检测该进程是正常结束（利用exit 函数或者从 main 函数返回）还是被没有处理的信号异常终止。
- 可以用 WTERMSIG 宏从中得到结束该进程的信号。

    int main ()
    {
    	int child_status;
    	/* 传递给 ls 命令的参数列表 */
    	char* arg_list[] = {
    	"ls", /* argv[0], 程序的名称 */
    	"-l",
    	"/",
    	www.AdvancedLinuxProgramming.com 46
    	NULL /* 参数列表必须以 NULL 结束 */
    	};

	    /* 产生一个子进程运行 ls 命令。忽略返回的子进程 ID。 */
	    spawn ("ls", arg_list);
	    /* 等待子进程结束。 */
	    wait (&child_status);
	    if (WIFEXITED (child_status))
	    	printf ("the child proces exited normally, with exit code %d\n", WEXITSTATUS (child_status));
	    else
	    	printf ("the child process exited abnormally\n");
	    return 0;

    }


## 3.4.3 僵尸进程 ##

如果一个子进程结束的时候，它的父进程正在调用 wait 函数，子进程会直接消失，而退出代码则通过 wait 函数传递给父进程。
如果子进程结束的时候，父进程并没有调用 wait，子进程死亡的时候会转化为一个僵尸进程。
如果父进程不清理子进程，它们会作为僵尸进程，一直被保留在系统中。

    #include <stdlib.h>
    #include <sys/types.h>
    #include <unistd.h>
    int main ()
    {
	    pid_t child_pid;
	    /* 创建一个子进程 */
	    child_pid = fork ();
	    if (child_pid > 0) {
		    /*这是父进程。休眠一分钟。 */
		    sleep (60);
	    }
	    else {
		    /*这是子进程。立刻退出。 */
		    exit (0);
	    }
	    return 0;
    }


## 3.4.4 异步清理子进程 ##
创建一个子进程只是简单的调用 exec 运行其它程序，在父进程中立刻调用 wait进行等待并没有什么问题，会导致父进程阻塞等待子进程结束。
在子进程运行的同时，父进程继续并行运行。怎么才能保证能清理已经结束运行的子进程而不留下任何僵尸进程在系统中浪费资源呢？
一种解决方法是让父进程定期调用 wait3 或 wait4 以清理僵尸子进程。在这种情况调用 wait 并不合适，因为如果没有子进程结束，这个调用会阻塞直到子进程结束为止。
另外一种更漂亮的解决方法是当一个子进程结束的时候通知父进程。

**（ sigchld.c）利用 SIGCHLD 处理函数清理子进程**

    #include <signal.h>
    #include <string.h>
    #include <sys/types.h>
    #include <sys/wait.h>
    sig_atomic_t child_exit_status;
    void clean_up_child_process (int signal_number)
    {
	    /* 清理子进程。 */
	    int status;
	    wait (&status);
	    /* 在全局变量中存储子进程的退出代码。 */
	    child_exit_status = status;
    }
    int main ()
    {
	    /* 用 clean_up_child_process 函数处理 SIGCHLD。 */
	    struct sigaction sigcihld_action;
	    memset (&sigchld_action, 0, sizeof (sigchld_action));
	    sigcihld_action.sa_handler = &clean_up_child_process;
	    sigaction (SIGCHLD, &sigchld_action, NULL);
	    /* 现在进行其它工作，包括创建一个子进程。 */
	    /* ... */
	    return 0;
    }

# 第四章：线程 #
- 如果任何一个线程调用了一个 exec 函数，所有其它线程就此终止。
- 子进程开始时候运行父进程的程序，并且从父进程处复制了虚拟内存、文件描述符和其它信息。 子进程可以修改自己的内存、关闭文件描述符、执行其它各种操作，但是这些操作不会影响父进程；反之亦然。
- 当一个程序创建了一个线程时并不会复制任何东西。创建和被创建的线程同先前一样共享内存空间、文件描述符和其它各种系统资源。

## 4.1 创建线程 ##

    #include <pthread.h>
    #include <stdio.h>
    
    /* 打印 x 到错误输出。没有使用参数。不返回数据。 */
    void* print_xs (void* unused)
    {
    	while (1)
    		fputc ('x', stderr);
    	return NULL;
    }
    /* 主程序 */
    int main ()
    {
    	pthread_t thread_id;
    	/* 传教新线程。新线程将执行 print_xs 函数。 */
    	pthread_create (&thread_id, NULL, *print_xs, NULL);
    	/* 不断输出 o 到标准错误输出。 */
    	while (1)
    		fputc ('o', stderr);
    	return 0;
    }


## 4.1.1 给线程传递数据 ##

    #include <pthread.h>
    #include <stdio.h>
    /* print_function 的参数 */
    struct char_print_parms
    {
    	/* 用于输出的字符 */
    	char character;
    	/* 输出的次数 */
    	int count;
    };
    /* 按照 PARAMETERS 提供的数据，输出一定数量的字符到 stderr。
    PARAMETERS 是一个指向 struct char_print_parms 的指针 */
    void* char_print (void* parameters)
    {
    	/* 将参数指针转换为正确的类型 */
    	struct char_print_parms* p = (struct char_print_parms*) parameters;
    	int i;
    	for (i = 0; i < p->count; ++i)
    	fputc (p->character, stderr);
    	return NULL;
    }
    /* 主程序 */
    int main ()
    {
    	pthread_t thread1_id;
    	pthread_t thread2_id;
    	struct char_print_parms thread1_args;
    	struct char_print_parms thread2_ars;
    	/* 创建一个线程输出 30000 个 x */
    	thread1_args.character = 'x';
    	thread1_args.count = 30000;
    	pthread_create (&thread1_id, NULL, &char_print, &thread1_args);
    	/* 创建一个线程输出 20000 个 o */
    	thread2_args.character = 'o';
    	thread2_args.count = 20000;
    	pthread_create (&thread2_id, NULL, &char_print, &thread2_args);
    	return 0;
    }


## 4.2.2 等待线程 ##

    int main ()
    {
    	pthread_t thread1_id;
    	pthread_t thread2_id;
    	struct char_print_parms thread1_args;
    	struct char_print_parms thread2_args;
    	/* 创建一个输出 30000 个 x 的线程 */
    	hread1_args.character = 'x';
    	thread1_args.count = 30000;
    	prhread_create (&thread1_id, NULL, &char_print, &thread1_args);
    	/* 创建一个输出 20000 个 o 的线程 */
    	thread2_args.character = 'o';
    	thread2_args.count = 20000;
    	pthread_create (&thread2_id, NULL, &char_print, &thread2_args);
    	/* 确保第一个线程结束 */
    	pthread_join (thread1_id, NULL);
    	/* 确保第二个线程结束 */
    	pthread_join (thread2_id, NULL);
    	/* 现在我们可以安全地返回 */
    	return 0;
    }

## 4.1.3 线程返回值 ##

    #include <pthread.h>
    #include <stdio.h>
    /*（非常低效地）计算连续的质数。返回第 N 个质数。 N 是由 *ARG 指向的参数。 */
    void* compute_prime (void* arg)
    {
    	int candidate = 2;
    	int n = *((int*) arg);
    	while (1) {
	    	int factor;
	    	int is_prime = 1;
	    	/*用连续除法检测是否为质数。 */
	    	for (factor = 2; factor < candidate; ++factor)
	    	if (candidate % factor == 0) {
	    		is_prime = 0;
	    		break;
	    	}
	    	/*这个质数是我们寻找的么？ */
	    	if (is_prime) {
	    		if (--n == 0)
	    		/*将所求的质数作为线程返回值传回。 */
	    		return (void*) candidate;
	    	}
	    	++candidate;
    	}
    	return NULL;
    }
    
    int main ()
    {
    	pthread_t thread;
    	int which_prime = 5000;
    	int prime;
    	/*开始计算线程，求取第 5000 个质数。 */
    	pthread_create (&thread, NULL, &compute_prime, &which_prime);
    	/*在这里做其它的工作……*/
    	/*等待计算线程的结束，并且取得结果。 */
    	pthread_join (thread, (void*) &prime);
    	/*输出所求得的最大质数。 */
    	printf("The %dth prime number is %d.\n", which_prime, prime);
    	return 0;
    }

## 4.1.5 线程属性 ##

1. 创建一个 pthread_attr_t 对象。最简单的方法是声明一个该类型的自动变
量。
2. 调用 pthread_attr_init，传递一个指向新创建对象的指针。这个步骤将各
个属性置为默认值。
3. 修改这个对象，使各个属性包含期望的值。
4. 在调用 pthread_create 的时候，传递一个指向该对象的指针。
5. 调用 pthread_attr_destroy 释放这个属性对象。这个 pthread_attr_t 对象
本身不会被释放；可以通过 pthread_attr_init 将其重新初始化。

## 4.2 线程取消 ##

一个线程在它正常结束（通过从线程函数返回或者调用 pthread_exit 退出）的时候终止。
一个线程可以请求另外一个线程中止。这被成为取消一个线程。要取消一个线程， 以被取消的线程 ID 作为参数调用 pthread_cancel。 
你应该对一个被取消的线程执行 pthread_wait 以释放它占用的资源，除非这个线程是脱离线程。
一个线程可以控制自身是否可以被取消，以及何时允许取消操作。



## 4.3 线程专有数据（ thread-specific data） ##
不过有时仍然需要将一个变量复制给每个线程一个副本。 GNU/Linux 系统通过为每个线程提供一个线程专有数据区（ thread-specific data area）。

**通过线程专有数据实现的每线程日志**

    #include <malloc.h>
    #include <pthread.h>
    #include <stdio.h>
    /* 用于为每个线程保存文件指针的 TSD 键值。 */
    static pthread_key_t thread_log_key;
    /* 将 MESSAGE 写入当前线程的日志中。 */
    void write_to_thread_log (const char* message)
    {
    	FILE* thread_log = (FILE*) pthread_getspecific (thread_log_key);
    	fprintf (thread_log, “ %s\n” , message);
    }
    /* 将日志文件指针 THREAD_LOG 关闭。 */
    void close_thread_log (void* thread_log)
    {
    	fclose ((FILE*) thread_log);
    }
    void* thread_function (void* args)
    {
    	char thread_log_filename[20];
    	FILE* thread_log;
    	/* 生成当前线程使用的日志文件名。 */
    	sprintf (thread_log_filename, “ thread%d.log” , (int) pthread_self ());
    	/* 打开日志文件。 */
    	thread_log = fopen (thread_log_filename, “ w” );
    	/* 将文件指针保存在 thread_log_key 标识的 TSD 中。 */
    	pthread_setspecific (thread_log_key, thread_log);
    	write_to_thread_log (“ Thread starting.” );
    	/* 在这里完成线程任务……*/
    	return NULL;
    }
    int main ()
    {
    	int i;
    	pthread_t threads[5];
    	/* 创建一个键值，用于将线程日志文件指针保存在 TSD 中。
    	调用 close_thread_log 以关闭这些文件指针。 */
    	pthread_key_create (&thread_log_key, close_thread_log);
    	/* 创建线程以完成任务。 */
    	for (i = 0; i < 5; ++i)
    		pthread_create (&(threads[i]), NULL, thread_function, NULL);
    	/* 等待所有线程结束。 */
    	for (i = 0; i < 5; ++i)
    		pthread_join (threads[i], NULL);
    	return 0;
    }

## 4.3.1 清理句柄 ##
清理句柄是一个临时性的工具，只在当线程被取消或中途退出而不是正常结束运行的时候被调用。

## 4.3.2 C++中的线程清理方法 ##

如果一个线程运行中调用了 pthread_exit， C++并不能保证线程的栈上所有自动对象的析构函数将被调用。不过可以通过一个很聪明的方法来获得这个保证：通过抛出一个特别设计的异常，然后在顶层的栈框架内再调用 pthread_exit 退出线程。  

通过提供两个参数（一个指向清理函数的函数指针和一个作为清理函数参数的 void*类型的值）调用 pthread_cleanup_push 可以创建一个清理句柄。对 pthread_cleanup_push 的调用可以通过调用 pthread_cleanup_pop 进行平衡： pthread_cleanup_pop 会取消对一个句柄的注册。  

# 4.4 同步和临界代码段 #
## 4.4.1 竞争状态 ##

要消灭竞争状态，你需要通过某种方法使操作具有原子性。一个原子操作是不可分割不可中断的单一操作；一旦这个操作过程开始，在结束之前将无法被暂停或中断，也不会有其它的操作同时进行。

    #include <malloc.h>

    struct job {
    /* 用于连接链表的域 */
    struct job* next;
    /* 其它的域，用于描述需要处理的任务 */
    };

    /* 一个链表的等待任务 */
    struct job* job_queue;
    void* thread_function (void* arg)
    {
	    while (job_queue != NULL) {
	    /* 获取下一个任务 */
	    struct job* next+job = job_queue;
	    /* 从列表中删除这个任务 */
	    job_queue = jhob_queue->next;
	    /* 进行处理 */
	    process_job (next_job);
	    /* 清理 */
	    free (next_job);
	    }
	    return NULL;
    }

## 4.4.2 互斥体 ##
现在假设有两个线程几乎同时完成了处理工作，但队列中只剩下一个队列。第一个线程检查 job_queue 是否为空；发现不是，则该线程进入循环，将指向任务对象的指针存入next_job。这时， Linux 正巧中断了第一个线程而开始运行第二个线程。这第二个线程也检查任务队列，发现队列中的任务，然后将这同一个任务赋予 next_job。在这种不幸的巧合下，两个线程将处理同一个任务。

使情况更糟糕一点，我们假设一个线程已将任务从队列中删除，使 job_queue 为空。当另一个线程执行 job_queue->next 的时候将会产生一个段错误。

对于刚才这个任务队列竞争状态问题的解决方法就是限制在同一时间只允许一个线程访问任务队列。当一个线程开始检查任务队列的时候，其它线程应该等待直到第一个线程决定是否处理任务，并在确定要处理任务时删除了相应任务之后才能访问任务队列。

创建和初始化互斥体的方法：

    pthread_mutex_t mutex;
    pthread_mutex_init (&mutex, NULL);

或者：

    pthread_mutex_t mutex = THREAD_MUTEX_INITIALIZER;


从队列中删除任务的线程函数：

    #include <malloc.h>
    #include <pthread.h>
    struct job {
    /* 维护链表结构用的成员。 */
    struct job* next;
    /* 其它成员，用于描述任务。 */
    };

    /* 等待执行的任务队列。 */
    struct job* job_queue;
    /* 保护任务队列的互斥体。 */
    pthread_mutex_t job_queue_mutex = PTHREAD_MUTEX_INITIALIZER;
    /* 处理队列中剩余的任务，直到所有任务都经过处理。 */
    void* thread_function (void* arg)
    {
	    while (1) {
		    struct job* next_job;
		    /* 锁定保护任务队列的互斥体。 */
		    pthread_mutex_lock (&job_queue_mutex);
		    /* 现在可以安全地检查队列中是否为空。 */
		    if (job_queue == NULL)
		    next_job = NULL;
		    else {
			    /* 获取下一个任务。 */
			    next_job = job_queue;
			    /* 从任务队列中删除刚刚获取的任务。 */
			    job_queue = job_queue->next;
		    }
		    /* 我们已经完成了对任务队列的处理，因此解除对保护队列的互斥体的锁定。 */
		    pthread_mutex_nlock (&job_queue_mutex);
		    /* 任务队列是否已经为空？如果是，结束线程。 */
		    if (next_job == NULL)
		    	break;
		    /* 执行任务。 */
		    proces_job (next_job);
		    /* 释放资源。 */
		    free (next_job);
    	}
    	return NULL;
    }


向任务队列中添加一个任务的函数可以写成这个样子：

    void enqueue_job (struct job* new_job)
    {
    	pthread_mutex_lock (&job_queue_mutex);
    	new_job->next = job_queue;
    	job_queue = new-job;
    	pthread_mutex_unlock (&job_queue_mutex);
    }

4.4.3 互斥体死锁

当一个或多个线程处于等待一个不可能出现的情况的状态的时候，我们称之为死锁状态。

共有三种互斥体：

- 锁定一个快速互斥体（ fast mutex，默认创建的种类）会导致死锁的出现。
- 锁定一个递归互斥体（ recursive mutex）不会导致死锁。
- 当尝试第二次锁定一个纠错互斥体（ error-checking mutex）的时候， GNU/Linux 会自动检测并标识对纠错互斥体上的双重锁定；这种双重锁定通常会导致死锁的出现。

创建一个纠错互斥体：

    pthread_mutexattr_t attr;
    pthread_mutex_t mutex;
    pthread_mutexattr_init (&attr);
    pthread_mutexattr_setkind_np (&attr, PTHREAD_MUTEX_ERRORCHECK_NP);
    pthread_mutex_init (&mutex, &attr);
    pthread_mutexattr_destroy (&attr);

## 4.4.4 非阻塞互斥体测试 ##

当你对一个解锁状态的互斥体调用 pthread_mutex_trylock 时，就如调用 pthread_mutex_lock 一样会锁定这个互斥体；
pthread_mutex_trylock 会 返 回 0 。 而 当 互 斥 体 已 经 被 其 它 线 程 锁 定 的 时 候 ，pthread_mutex_trylock 不会阻塞。相应的， pthread_mutex_trylock 会返回错误码 EBUSY。持有锁的其它线程不会受到影响。你可以稍后再次尝试锁定这个互斥体。

4.4.5 线程信号量

信号量可以很方便地做到这一点。信号量是一个用于协调多个线程的计数器。如互斥体一样， GNU/Linux 保证对信号量的取值和赋值操作都是安全的，不会造成竞争状态。每个信号量都有一个非负整数作为计数。

信号量支持两种基本操作：

-  “等待”（ wait）操作会将信号量的值减一。如果信号量的值已经是一，这个操作会阻塞直到（由于其它线程的一些操作）信号量的值成为正值。当信号量的值成为正值的时候， 等待操作会返回，同时信号量的值减一。

-  “ 投递”（ post）操作会将信号量的值加一。如果信号量之前的值为零，并且有其它线程在等待过程中阻塞，其中一个线程就会解除阻塞状态并结束等待状态（同时将信号量的值重置为 0）。

## 4.4.6 条件变量 ##

当标志没有设置的时候让线程进入休眠状态；而当某种特定条件出现时，标志位被设置，线程被唤醒。


## 4.4.7 两个或多个线程的死锁 ##

确保所有线程锁定这些资源的顺序相同，这样就可以避免死锁的出现。


# 第五章：进程间通信 #
- · 共享内存允许两个进程通过对特定内存地址的简单读写来完成通信过程。
- · 映射内存与共享内存的作用相同，不过它需要关联到文件系统中的一个文件上。
- · 管道允许从一个进程到另一个关联进程之间的顺序数据传输。
- · FIFO 与管道相似，但是因为 FIFO 对应于文件系统中的一个文件，无关的进程也
- 可以完成通信。
- · 套接字允许无关的进程、甚至是运行在不同主机的进程之间相互通信。

## 5.1.3 分配 ##

进程通过调用 shmget（ SHared Memory GET，获取共享内存）来分配一个共享内存块。

## 5.1.4 绑定和脱离 ##

要让一个进程获取对一块共享内存的访问，这个进程必须先调用 shmat（ SHared Memory Attach，绑定到共享内存）。
 
当一个进程不再使用一个共享内存块的时候应通过调用 shmdt（ SHared Memory DeTach，脱离共享内存块）函数与该共享内存块脱离。

## 5.1.5 控制和释放共享内存块 ##

调用 shmctl（ "SHared Memory ConTroL"，控制共享内存）函数会返回一个共享内存块的相关信息。

## 5.1.6 示例程序 ##

    #include <stdoi.h>
    #include <sys/shm.h>
    #include <sys/stat.h>
    int main ()
    {
	    int segment_id;
	    char* shared_memory;
	    struct shmid_ds shmbuffer;
	    int segment_size;
	    const int shared_segment_size = 0x6400;
	    /* 分配一个共享内存块 */
	    segment_id = shmget (IPC_PRIVATE, shared_segment_size,
	    IPC_CREAT | IPC_EXCL | S_IRUSR | S_IWUSR );
	    /* 绑定到共享内存块 */
	    shared_memory = (char*) shmat (segment_id, 0, 0);
	    printf ("shared memory attached at address %p\n",
	    shared_memory);
	    /* 确定共享内存的大小 */
	    shmctl (segment_id, IPC_STAT, &shmbuffer);
	    segment_size = shmbuffer.shm_segsz;
	    printf ("segment size: %d\n", segment_size);
	    /* 在共享内存中写入一个字符串 */
	    sprintf (shared_memory, "Hello, world.");
	    /* 脱离该共享内存块 */
	    shmdt (shared_memory);
	    /* 重新绑定该内存块 */
	    shared_memory = (char*) shmat (segment_id, (void*) 0x500000, 0);
	    printf ("shared memory reattached at address %p\n",
	    shared_memory);
	    /* 输出共享内存中的字符串 */
	    printf ("%s\n", shared_memory);
	    /* 脱离该共享内存块 */
	    shmdt (shared_memory);
	    /* 释放这个共享内存块 */
	    shmctl (segment_id, IPC_RMID, 0);
	    return 0;
    }


## 5.1.7 调试 ##

使用 ipcs 命令可用于查看系统中包括共享内存在内的进程间通信机制的信息。指定-m参数以获取有关共享内存的信息。

# 5.2 进程信号量 #
## 5.2.1 分配和释放 ##
与用于分配、释放共享内存的 shmget 和 shmctl 类似，系统调用 semget 和 semctl负责分配、释放信号量。

**分配和释放二元信号量**

    #include <sys/ipc.h>
    #include <sys/sem.h>
    #include <sys/types.h>
    /* 我们必须自己定义 semun 联合类型。 */
    union semun {
    	int val;
    	struct semid_ds *buf;
    	unsigned short int *array;
    	struct seminfo *__buf;
    };
    /* 获取一个二元信号量的标识符。如果需要则创建这个信号量 */
    int binary_semaphore_allocation (key_t key, int sem_flags)
    {
    	return semget (key, 1, sem_flags);
    }
    /* 释放二元信号量。所有用户必须已经结束使用这个信号量。如果失败，返回 -1 */
    int binary_semaphore_deallocate (int semid)
    {
    	union semun ignored_argument;
    	return semctl (semid, 1, IPC_RMID, ignored_argument);
    }

## 5.2.2 初始化信号量 ##

    #include <sys/types.h>
    #include <sys/ipc.h>
    #include <sys/sem.h>
    /* 我们必须自己定义 union semun。 */
    union semun {
    	int val;
    	struct semid_ds *buf;
    	unsigned short int *array;
    	struct seminfo *__buf;
    };
    /* 将一个二元信号量初始化为 1。 */
    int binary_semaphore_initialize (int semid)
    {
    	union semun argument;
    	unsigned short values[1];
    	values[0] = 1;
    	argument.array = values;
    	return semctl (semid, 0, SETALL, argument);
    }


## 5.2.3 等待和投递操作 ##

    #include <sys/types.h>
    #include <sys/ipc.h>
    #include <sys/sem.h>
    /* 等待一个二元信号量。阻塞直到信号量的值为正，然后将其减 1 */
    int binary_semaphore_wait (int semid)
    {
    	struct sembuf operations[1];
    	/* 使用（且仅使用）第一个信号量 */
    	operations[0].sem_num = 0;
    	/* 减一 */
    	operations[0].sem_op = -1;
    	/* 允许撤销操作 */
    	operations[0].sem_flg = SEM_UNDO;
    	return semop (semid, operations, 1);
    }
    /* 对一个二元信号量执行投递操作：将其值加一。
    这个操作会立即返回。 */
    int binary_semaphore_post (int semid)
    {
    	struct sembuf operations[1];
    	/* 使用（且仅使用）第一个信号量 */
    	operations[0].sem_num = 0;
    	/* 加一 */
    	operations[0].sem_op = 1;
    	/* 允许撤销操作 */
    	operations[0].sem_flg = SEM_UNDO;
    	return semop (semid, operations, 1);
    }

## 5.2.4 调试信号量 ##

命令 ipcs -s 可以显示系统中现有的信号量组的相关信息。而 ipcrm sem 命令可以从命令行删除一个信号量组。


# 5.3 映射内存 #

映射内存提供了一种使多个进程通过一个共享文件进行通信的机制。尽管可以将映射内存想象为一个有名字的共享内存，你始终应当记住两者之间有技术层面的区别。映射内存既可以用于进程间通信，也可以作为一种访问文件内容的简单方法。


## 5.3.1 映射一个普通文件 ##
要将一个普通文件映射到内存空间，应使用 mmap（映射内存，“ Memory APped”，读作“ em-map”）。


## 5.3.3 对文件的共享访问 ##
不同进程可以将同一个文件映射到内存中，并借此进行通信。通过指定 MAP_SHARED标志，所有对映射内存的写操作都会直接作用于底层文件并且对其它进程可见。如果不指定这个标志， Linux 可能在将修改写入文件之前进行缓存。

## 5.3.4 私有映射 ##

在 mmap 中指定 MAP_PRIVATE 可以创建一个写时复制（ copy-on-write）区域。所有对映射区域内存内容的修改都仅反映在当前程序的地址空间中；其它进程即使映射了同一个文件也不会看到这些变化。与普通情况下直接写入所有进程共享的页面中的行为不同，指定MAP_PRIVATE 进行映射的进程只将改变写入一份私有副本中。该进程随后执行的所有读写操作都针对这个副本进行。

## 5.3.5 mmap 的其它用途。 ##

系统调用 mmap 还可以用于除进程间通信之外的其它用途。一个常见的用途就是取代read 和 write。