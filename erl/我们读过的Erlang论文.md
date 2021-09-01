 我在Erlang Resources 豆瓣小站上发起了一个征集活动 [[链接](http://site.douban.com/204209/widget/notes/17144051/note/409113054/)] ,"[征集] 我们读过的Erlang论文",希望大家来参加.发起这样一个活动的目的是因为Erlang相关的出版物很少,很多时候都是从学术论文中寻找答案,而发现合适的论文是第一步,这个活动就是为了解决这个问题.

 

 在一个极小的知识点可能都会有一篇精彩的论文为你条分缕析,抽丝剥茧,甚至可以拼凑起来一个完整的Erlang知识系统,我们开始吧...

 

 

**《面向软件错误构建可靠的分布式系统》**

Making reliable distributed systems in the presence of sodware errors

地址:  http://pubftp0.availo.se/pub/FreeBSD/distfiles/erlang-doc/r13b01/armstrong_thesis_2003.pdf 

译文地址: http://man.lupaworld.com/content/other/erlang.pdf  

备注: 没有什么可说的,这篇论文几乎是Erlang入门必读,甚至在论文里面已经可以完成Erlang基础知识的学习;

 

**Concurrent Programming in ERLANG**

地址: http://www.erlang.org/download/erlang-book-part1.pdf 

备注: 教科书

**Characterizing the Scalability of Erlang VM on Many-core Processors**

地址: http://kth.diva-portal.org/smash/get/diva2:392243/FULLTEXT01 

备注: 估计是了解Erlang VM必读的一篇论文,在众多涉及Erlang VM实现的博客,论文里面到处可以看到这篇论文的身影;

摘要: This section will introduce the reader to Erlang and brieﬂy describe the **Erlang compiler and virtual machine** in order to give the reader some basic understanding of Erlang.

 

**Exploring Alternative Memory Architectures for Erlang:Implementation and Performance Evaluation**

地址: http://www.fantasi.se/publications/Wilhelmsson_MSc.pdf

备注: 文章介绍了Erlang VM垃圾回收和内存管理

 


**Efﬁcient memory management for concurrent programs that use message passing I,II**

地址: http://user.it.uu.se/~kostis/Papers/scp_mm.pdf 

备注: Erlang VM 内存管理 GC



 

**Heap Architectures for Concurrent Languages using Message Passing**
地址: http://www.fantasi.se/publications/ISMM02.pdf

摘要:We discuss alternative heap architectures for languages that rely on automatic memory management and implement con-
currency through asynchronous message passing. We describe how interprocess communication and garbage collec-
tion happens in each architecture, and extensively discuss the tradeoﬀs that are involved. In an implementation set-
ting (the Erlang/OTP system) where the rest of the runtime system is unchanged, we present a detailed experimental
comparison between these architectures using both synthetic programs and large commercial products as benchmarks.
备注: 一句话总结这篇论文就是:当消息传递的时候本质上发生了什么

 

 

**On Preserving Term Sharing in the Erlang Virtual Machine**

地址: http://user.it.uu.se/~kostis/Papers/erlang12_sharing.pdf 

摘要:In this paper we describe our experiences and argue through examples why ﬂattening terms during copying is not a good idea for

a language like Erlang. More importantly, we propose a sharing preserving copying mechanism for Erlang/OTP and describe a pub-

licly available complete implementation of this mechanism. 

 

**Bit-level Binaries and Generalized Comprehensions in Erlang**
地址: http://user.it.uu.se/~pergu/papers/erlang05.pdf

备注: To further simplify programming on bit streams we then show how binary comprehensions can be introduced in the language and how binary and list comprehensions can be extended to allow both binary and list generators.

备注: 简单描述Core Erlang 和Erlang的关系,发展历史 从Erlang代码到Core Erlang代码中间经历的分析和转换过程中是怎样被大大简化的.

 

**Programming Efﬁciently with Binaries and Bit Strings**

地址: http://www.erlang.org/euc/07/papers/1700Gustafsson.pdf

摘要: This paper will describe the new additions to the language and show how they can be used efﬁciently given the new optimizations

of binary pattern matching and binary construction. It also includes some performance numbers to give an idea of the gains that can be

备注:Erlang Efficiency Guide告诉你How,这篇论文告诉你Why

 

**Programming Distributed Erlang Applications:Pitfalls and Recipes**

地址: http://man.lupaworld.com/content/develop/p37-svensson.pdf 

译文地址:  http://www.kaiyuanba.cn/content/develop/p37-svensson-cn.pdf 

备注:  基本消息传递保障-流语义 跨节点编程陷阱 Pid重复 消息顺序

 

**Parameterized modules in Erlang**

地址: http://ftp.se.postgresql.org/pub/lang/erlang/workshop/2003/paper/p29-carlsson.pdf

备注: 这个已经成为传说,在最新版Erlang中需要通过插件项目使用此特性

 

**Design Patterns for Simulations in Erlang/OTP**

地址: http://ftp.nsysu.edu.tw/FreeBSD/ports/local-distfiles/olgeni/master_thesis_patterns.pdf

备注: 不感兴趣的部分就大段大段的跳过吧,这篇论文讲到了 The implemented behaviours

 

 

**Extended Process Registry for Erlang** 

地址: http://svn.ulf.wiger.net/gproc/doc/erlang07-wiger.pdf  

地址: http://www.erlang.se/workshop/2007/proceedings/02wiger.pdf

备注: gproc: Extended Process Registry 这个应该有不少人在实践了

 

 

**Troubleshooting a Large Erlang System**

地址: http://www.erlang.se/workshop/2004/cronqvist.pdf

备注: 串讲了OTP排错工具集如何使用 

 

**Static Detection of Race Conditions in Erlang**

地址: http://www.it.uu.se/research/group/hipe/dialyzer/publications/races.pdf

摘要: We address the problem of detecting some commonly occurring kinds of race conditions in Erlang programs using static analy-

sis. 

 

**Erlang’s Exception Handling Revisited**

地址: http://www.erlang.se/workshop/2004/exception.pdf 

摘要: We give a comprehensive description of the behaviour of exceptions in modern-day Erlang , present a theoretical model of the
semantics of exceptions, and use this to derive the new try-construct.

 

 

**Cleaning up Erlang Code is a Dirty Job but Somebody’s Gotta Do It**

地址: http://users.ece.cmu.edu/~aavgerin/papers/Erlang09.pdf 

备注: 看这篇论文我们都不一定要用这个代码自动优化工具,更有价值的是问How & Why

 

 **Build Your Next Web Application with Erlang**

地址: http://www.kth.se/polopoly_fs/1.162674!/Menu/general/column-content/attachment/ieee.pdf 

备注: 有O'记那本小册子,这篇论文不读也罢

 

 

**A Study of Erlang ETS Table Implementations and Performance**

地址: http://www.erlang.org/workshop/2003/paper/p43-fritchie.pdf 

摘要: The viability of implementing an in-memory database, Erlang ETS, using a relatively-new data structure, called a Judy array, was studied by comparing the performance of ETS tables based on four data structures: AVL balanced binary trees, B-trees, resizable linear hash tables, and Judy arrays. 

 

 

**A Stream Library using Erlang Binaries**

地址: http://www.duomark.com/erlang/publications/acm2005.pdf

摘要: This paper introduces the memory and behavior characteristics of lists, tuples and binaries in erlang, then continues with a de-

scription of the Bit syntax and standard methods of using binaries to deal with streamed data. Next it introduces BIF functions that
are shown to be much faster than using the traditional Bit syntax to manipulate binary data.  

 

**A Scalability Benchmark Suite for Erlang/OTP**

地址: http://www.softlab.ntua.gr/~gtsiour/files/erlang01-aronis.pdf 

摘要: This paper presents the main aspects of the design and the current status of bencherl, a publicly available scalability benchmark

suite for applications written in Erlang. 

 

**All you wanted to know about the HiPE compiler (but might have been afraid to ask)**

地址: http://user.it.uu.se/~pergu/papers/erlang03.pdf 

备注:几乎解答了HIPE的所有常见问题

 

 

**No more need for records**

地址: http://www.cs.otago.ac.nz/staffpriv/ok/frames.pdf 

备注:Maps结构的缘起 设计上的取舍部分很有意思

 