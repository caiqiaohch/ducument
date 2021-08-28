# [Erlang 虚拟机内的内存管理（Lukas Larsson演讲听写稿）](https://www.cnblogs.com/zhengsyao/p/erts_allocators_speech_by_lukas_larsson.html)

Erlang核心开发者Lukas Larsson在2014年3月份Erlang Factory上的一个演讲详细介绍了Erlang内存体系的原理以及调优案例：

http://www.erlang-factory.com/conference/show/conference-6/home/#lukas-larsson

在这里可以下载slides和观看视频（为了方便不方便科学上网的同学，我把视频搬运到了 http://v.youku.com/v_show/id_XNzA1MjA0OTEy.html ）

这个演讲的内容很丰富，原理介绍很细致，但是slides比较简略，所以我把这个演讲的整个内容听写出来了，收获颇多，完整的transcript如下：

------

 

Thank you.

Page 2
When I wrote this talk, I thought that I was going to give a bunch of examples about how you analyse memory and see what the different allocators and things how the Erlang virtual machine works and spend a lot of focus on doing actual examples.
It turned out that the theory of this stuff is quite complicated, so it's more of theory talk and having some stories at the end rather than being a story focused.
So I am going to talk about the problem and why there are memory allocators in Erlang virtual machine and what they are used for and different handling, going through all the different concepts with the memory allocators, so that you get the terminology right, so that you know the different options you want to set so on and so forth, get to know all the different things we are talking about when talking about blocks, when talking about carriers and so on.
I'm going to have look at the statistics that you can gather. There are a lot of statistics and main reason why we have the allocators implementated the way they are is because we can gather the statistics about your system, try to figure out, ok this is an optimal way of using your memory.
We are going to have look at two different cases where we have been looking at the statistics that we can get from Erlang allocators, making modifications, and hopefully make system work better.
And at the end we'll look at some of the new features, because there are a lot of development happening in the allocators, we've spent a lot time optimizing these things and trying to shrink the fragmentation to become smaller and smaller.

Page 3
The reason why we have memory allocators in Erlang virtual machine is because the normal malloc and so on are relatively slow for very small allocations, so when you are allocating small ets objects some where, it quite heavy operation to have to do syscall go all the way down, so we kind of cache memory up in the virtual machine.
Also, in order to battle fragmentation, we use different strategies for how to allocate data, allocating something like a module or something like that, ok, you want to spend a lot of time finding the correct place to allocate that memory, but allocating something like a message being sent to another process, you don't want to spend as many cpu cycles to try to find the perfect place in memory, because it will be deallocated when you receive the message. So we have different strategies depending what type of memory that we are allocating.

Also there is no way to get statistics in a cross-platform manner. Now we want to have out of the allocators if you want to just use malloc or something like that.

If you want to try on your system running without erlang allocators, just use malloc from the beginning, you pass that flag to Erlang virtual machine, and it will disable everything. And you just run normal malloc.
Sometimes, this is faster, I was looking at a benchmark that's called ESTONE, I was going to see, ok, how much faster are these allocators, I switched them off, and benchmark went faster than using the allocators.
So it's not always, but that's what you get for some statistics benchmarks.
In real production environments, they help a lot. There is another benchmark I have been running to do a 4G telephone benchmark thing, and there there is a 40% speedup to see in these allocators than using malloc and so on.
So in real world applications, it's usually better for small benchmarks, they overact sometimes, bits over..
The allocators also help a lot when you are doing NUMA, so lots of cores lots of things..

Page 4
So I'm going on talk a bit about concepts.
These are the forming things that we are talking about.
carriers and blocks, single- vs. multi-block carriers, how do multiblock work and what's thread specific allocators.

Page 5
So talking about blocks.
This is a terminology so that we can talk about these things.
A block is one continuous piece of memory that Erlang virtual machine needs, this is something like for instance when you do a ets insert, that piece of data becomes a block, heap and stack of a Erlang process is a block, and message being sent from one process to another is copying inside a block, so it's continuous piece of C memory.
We have carriers.
Carriers is something container, contains one or more blocks. So we have something looking like that.
So we have a header, saying ok that this is a carrier of this type with these settings and so on. And we put the block into it.
And as we continue with more operations on ETS table, we put more and more data, hopefully in a good place into the block. And we delete something, and we get fragmentation. We might end up with something looking like this.
Now these blocks are like this. They are normally .. we align them, normally aligned at 18 bit limits, so they are about 256 KB minimum, aligned at that limit, so it allows us to do lots of optimizations.

The size of how much memory can be allocated can be controlled with many different settings.

Page 6
Before I do that, we talk about single and multiblock carriers.

So when looking at the statistics on the allocators, we have two different concepts there, so we have single block carrier which is something that contains one block, it's carrier that contains one block of memory.

Now normally you want to put large, for some definition of large block into one single block carrier.
And if you have small blocks, you want to put them into the same carrier, this is because the operating system is quite good at handling large continuous chunks of memory, and single block carrier usually uses just allocator like malloc normally.

Large depends on your context, sometimes, large can be something like 256 bytes, sometimes it can be 5 MB, so it depends a bit on your context.

The default is half MB, which seems to work for most situations. So if you have a block of some sort that's smaller than 512 KB, then it's placed on multiblock carrier, if it's bigger, then it's placed on single block carrier.

And you control that by single block carrier threshold.

Normally you want to have most of your data in multiblock carriers.
So in a normal system that you are running you have most .. I don't know .. 80~85~90% of your data to be part of multiblock carrier.

So if you realize in a system that you are running that you have a lot of singleblock carriers, not a lot of multiblock carriers, you might want to raise the limit to see, ok , so I know from my code that I'm reading 1 MB messages from TCP socket all the time, this becomes 1 MB binaries, and that's bigger than 512 KB, those are always put into singleblock carriers, so I might want to just adjust the threshold to 1.5 MB, and then , they put all those blocks into multiblock carriers, and hopefully your system will be a lot faster.

When manipulating the threshold you probably also want to change the size of carriers that are being allocated. So if you are increasing the size of individual blocks, you will wanting increase the actual carriers that are being created. So if you increase the threshold to 1 MB, the.. I believe the default size of multiblock carriers is 2 MB, the smallest one, and it grows up into 8 MB, depending on how many carriers you have.

Since you doubled the initial amount, you might want to double the next one as well, so you started at 4 MB might grow up to 16 MB, or something of that effect.

Page 7
There are quite a few different types of allocators. These are different areas that you can configure individually how they work.

So we have the heap allocator, the binary allocator, the driver allocator and the ets allocator. So these are the things that you can reason about as an Erlang programmer.

These allocators are normally the ones that you tune. I've not seen problems with any allocators yet. Normally somebody allocating binaries that are going out of hand or they have many many small ets stuff that are put into table, they get fragmentation usually because of that. That's the two normal ones that you have problems with.

There are also temporary, short lived, standard lived, long lived and fix size allocations, and these are emulator internal things.

Page 8
The difference between these emulator internal things:
temporary is a very short time, for something that just lives in a C function, some examples for what can be there.
standard is links, monitors, these kinds of C structures.
short is something that lives across .. I don't know .. a scheduler for erlang functions, lives for only 4 or 5 milliseconds, something like that.
long is for things like code, atoms, things that we know could possibly live forever.
fixed are things we know are certain sizes, we can make optimizations because of this, so process control blocks, port control blocks and lots of other things.
If you want to find the exact things that there are, there is a file called erl_alloc.types in the erlang/otp repository under erts, all the mappings are set there and mappings are different if you are running a half-word emulator, if you are running a 64 bit, 32 bit, if you are running windows, unix or ...
So many things are depending on operating system that you build the erlang virtual machine for, you have different setting for these things.

Page 9
So talking a bit about..
So, single blocks carriers are quite easy, you don't have to manage them, you have one block one carrier, and that's it, and one carrier is one chunk of memory requested from operating system. so it's very easy to handle.

multiblocks, on the other hand, are quite difficult. you have a lots of small areas because you need to keep track of where I can put this piece of memory. I need to place something that's 8 bytes big, and I need to look for the best place to put it, and spend a good amount of time for it.
So we have a few ~7 different strategies that you can use in order to allocate where to put the blocks inside multiblock carrier.
So we have the block oriented ones, these are strategies that span carriers, so if you have two carriers, and with them build the trees with all the free blocks of all the carriers that are in that allocator at the point.
We have the best fit, it's just, it's the best fit looks for the one with the least wastes, so if you have a block that's 8 bytes, and you find the slot that's 9, and next smaller slot is 7, then you put it in the 9 slot, and so on.
Address order best fit works in the same way, only that if there is a tie, it uses the one with the lowest address, rather than just taking the one that was put in the queue last.
Address order first fit tries to take the one with the lowest address that you can fit them.
Good fit takes the good fit to do it. You can tune with the settings that you define as a good fit. so if you say that it's ok to waste 10% of the blocks, if I have something that's 10 bytes big, then a good fit is something that doesn't waste more than 15 bytes. So something like that, you can tune what you want to have a good fit to be.
A fit, is mostly used for these temporary allocations that are really fast, so just finding something.

We have the carrier oriented ones. these are broken down so that first you have the strategies to say how the carriers are organized, than you have strategies saying how the blocks within a carrier organized.
I think I will get into more details about the.....

Page 10
I have a picture here. saying a small example about how best fit works. So we have two carriers, the shaded areas are memories that are taken, the blue and red ones are free slots, so free memory areas.
we build a tree looking something like this, after different carriers saying ok we do a binary search trees, so that is, I thinks it's a red-black balanced binary search tree, that you look for blocks in.
In the end it looks something like this, the smallest red one all the way to the right, and then you have built up this tree of them, and the neat thing is that this requires of course no memory to build this tree because we save the pointers of this tree in the free slots. So it doesn't actually take any memory to build this tree. and then we just search this tree to see, ok, which one can be find, and we take a slot, then you take out of the tree, we balance, and then hopefully you find good slot to be in.

So I've been talking a lot about the blocks in there, so you have different blocks. but the carriers, where do they come from?

Page 12
So we have two different ways of allocating carriers in the runtime system.
We have something called mseg alloc and the sys alloc.
so the mseg allocator basically tries to shut out the operating system as much as possible, and just allocates big segments. And this is normally used for multiblock carrier allocation.
On linux it uses /dev/zero and opens that as a file, and mmap with different arguments in order to get large chunks of memory.
One of the key things about the mseg alloc is that it has a cache. so it has a cache of certain size of carrier that was just returned to it. I think the default is 10 or something like that, and only normal system, most I see, we have a cache hit rate of about 80%~85%, normally when we are using a lot of carriers in a system.

sys alloc just call to malloc, free or posix_memalign depending on your operating system. It allocates pieces of memory in multiples of a variable you can set there, let's call them Muxxxx. So I think the default is 2 MB. so it allocates 2 MB no matter if you want to have something that's let's say 1 MB. it over allocates 2 MB in order to make it easier for operating system to get less fragmentation of things.
We had a lot of problems with projects that have had fragmentation of virtual memory space, so this is why we help malloc in order to have these nice chunks that it can manage and gets it perfect.
sys alloc is also used to allocate what we call the main carrier. main carrier is an initial carrier, so the first one that's always there during startup.
The idea with the main carrier is that you have sufficient memory in order to do the normal bootup of erlang emulator without doing any extra allocations in order to speed up starting something.

Page 13
So another picture. Now we are getting into different schedulers.
so we have short live allocator, eheap, binary and all of the different things, they request carriers from mseg alloc.
All of these, we have one chain of these per scheduler in the system. so all of these are locals, you have one ets alloc for scheduler 1, one ets alloc for scheduler 2, etc... So they are all local, and can take advantage of the NUMA architecture of your system, so allocation is always close to you.
And, these small mailboxes, they are say that, of course we have to pass memory around between the schedulers, so if we want to do free or something that we passed over we have to send a message to that scheduler in order to do free, because we don't have any locks at all on the actual allocators, because we want these to be lock free, so we are doing them via a message passing between the schedulers that do the allocations.
In R16B02, we added a carrier pool that's shared between different schedulers, you get access to this if you use the carrier oriented algorithms that I was talking about before. and so if you use something like the address order best fit carrier or first fit block something like that, you get to access this pool. This pool get populated of carriers that are below a certain percentage of utilizations, so if you have a carrier on scheduler n, that has utilization of say 20%, so it has quite high fragmentation, then that scheduler can give that carrier to the pool, and somebody that needs a carrier, say scheduler 1 needs a new carrier to allocate data in, it can take that from the pool rather than having that from somewhere else.
You lose some of the NUMA things of course, but you get better memory utilization, which is nice.

For all of the async threads, and all of the driver threads, there is a global allocator that has a big lock in front of it, and all of the data get put into there, so if for instance you are reading a file with binaries, those binaries get put into this global allocator.

And all of these mseg , as if they run out of layers here, we have something called erts_mmap at the bottom as well, that was added in R16B03, that's something fun as well. If you want to know the details, just ask me afterwards.

Page 14
So, that's general theoretical background for these things. So getting statistics trying to figure out what's wrong, let's dig down to some of these things.
We have different types of allocators, they are called things like these when we are talking about statistics part of them.
So if you do erlang:system_info(allocator), you get information about which allocators are active on your system. It's not always the same, and it's definitely not always the same over releases. But doing this, you can get the information about what feed are just enabled on your system. You get all of different settings that you set on you system, you can figure out what your threshold is, or what's your multiblock carrier strategies and other things like that. And the features like if you have the posix_memalign in your system, if you can lock physical memory in place rather than trying to get linux way of doing memory management. In there, lots of other things.

Page 15
Now you can dig into more detail, even more.
So if you say erlang:system_info, and put one of the type we have seen in the previous slide: eheap_alloc, ets_alloc, something like that, you get list of tuples with lots lots of data.
You can see that, the first structure we have is instances.
Instance 0 is the global allocator that's used for async threads.
Instance 1 is for scheduler 1, instance 2 is for scheduler 2, etc. etc. etc..
For each instance, we have the version of allocator use, the options set, statistics about the multiblock carriers, statistics about the singleblock carriers, and statistics about the calls made about the carrier.
I'll break these down for you..

Page 16
So this is what you get out of the data.

Page 17
I put it in a table for you, so you don't have to read the data stuff.
So, what we get is that we get the current value, we get the maximum value of that parts since the last call to get the statistics, and we get the maximum value of the system life time.
We can see the number of blocks, there we have 1 million, 1 million and 1.8 million blocks.
And there, we get the total size of all of the blocks, I think I actually have a .. So we have a 820 MB, 820 MB there, we have maximum, when we have a peak of 3.3 GB of memory.
We can see the carriers, we fit these 1 million blocks into 455 carriers.
We can see the carriers sizes down there as well.

Page 19
Singleblock carrier would of course have the same amount of blocks as carriers.
We can see that the block size is 6, 6, 20, but since we over allocate a bit, the carrier size is 7.5, 7.5 and 25. Quite simple.

Page 20
The number of calls that you can see. We can see that we have done quite a few calls.

Page 21
Quite many, so 28 thousand mega calls has been done to the binary alloc.
So quite a few binaries have been allocated there.
We freed roughly the same amount which is a good thing, otherwise we would have memory leak.
And we have been able to reallocate some as well.
And we can see that mseg alloc has done 24 thousand of allocations, while sys alloc has done zero. so this is a good thing.
So that's for the singleblock and multiblock things.

Page 22
So you can also get the statistics about the carrier allocators.
We can get the amount of segments, cache information, seeing the alloc, dealloc and destroy.
So here we can see the cache working.
We have mseg alloc of 464 there, while actually we only created 40 carriers.
So we have a quite high cache hit rate there. We have done 464 calls, only 40 of them ended up in OS call.

I am justing think of how much time I have.. which seems to be plenty.. that's good...

Page 23
So some case study to see how you analyze these things, and get these data once you understand what they mean.
So I run across two cases. I run across many cases, but these ones are quite useful for the open source community, because you guys seem to run into them a lot more than our commercial customers.

Page 24
So the first one I want to talk about is large binaries.
So there was this person that realized that I am running strace, and I know that these allocators are supposed to be really efficient, it should be using mmap to allocate my stuff, but for some reason, it's not using mmap, it's using malloc instead. It's using a lot malloc.

Page 25
So I requested the statistics of binary allocators.
In there, you can see that there were about 300 mega calls being done to binary alloc.
And we have 0.4 mega calls done to mseg alloc.
So we have a discrepancy because we want to have most of our stuff into the mseg allocator not to the system allocator, because mseg allocator means that we use multiblock carriers, while system allocator means that we are using singleblock carrier mostly.
And we could see that we have sys alloc call of 1.4 mega calls, so quite a discrepancy there.
So this is when bells are whispering for me, saying something is wrong with these settings.
So at this point you can reason about the allocators, something is wrong with how the thresholds set for which things are being put. I noticed this is binary alloc or so, so this person is allocating large binaries than the actual singleblock threshold for most of the binaries, and therefore they push into singleblock carriers, and which is not as efficient.
Going back, we can see that multiblock carrier size is about 2.4 GB, and the singleblock carrier size is 11 GB of memory.
So it's a big discrepancy, normally we want to have the reverse if not even more in favor of multiblock carriers in there.

So, what can we do about this?
So we want to adjust the singleblock carrier threshold somehow, but how should we adjust it?

So looking at the statistics, we can also get the average block size that's in the single block carriers.
You take the number of blocks divided by the total size of the carriers, we can see that the block size is about 1.68 MB, in this case it was reading from TCP socket.
Now we have the block size, ok, this is the average block size. So we probably want to go a bit over that size when tuning the allocators.
And in the end we ended up setting it to 2MB, which is reasonable limit above there, and is a nice clean number.
So, that put the binaries that are greater than 2 MB into singleblock carriers, while puts that are smaller than 2 MB into multiblock carriers.
And since multiblock carriers are being done by mmap, and you get the caching of mseg and all that, the performance increase is quite good I believe.
And also of course, increase the largest multiblock carrier size and the smallest multiblock carrier size, as these two last ones say, for only the binary allocator, this is where the strength of the erlang runtime allcoators come in, because you can say that, I only was setting the binary allocators, because if you set the settings for all of the allocators, then you will have the problem, most probably with ETS or something like that, over allocates the memory than you really want in your system.
So you can specify saying I have problem only with binary allocations, therefore I put only binary tuning into my emulator.

Page 27
So second case that I was running into .. was actually helping Fred Hebert with a problematic allocator, which he wrote a big blog post about it, so this is data if you read the blog post.
The symptom that he was having was that erlang:memory(total) was showing about 7 GB of used memory, but top in his operating system was showing that 15 GB memory was being used by the BEAM.
And then all of the sudden, he got some kind of small traffic spike, and he got crashed on ets alloc failing to allocate. And he was confused, because Hey I have .. it says I have 7 GB only, and then it was 15 GB, I don't have memory to allocate these things.
Now the thing to know about erlang:memory(total) is that is the total areas of the blocks in your system.
It's not the total areas of the carriers in your system.
So there is the discrepancy, it's only the used areas that is the Erlang total, it's not the actual allocated from the operating system.
So if you see this discrepancy between what erlang:memory gives and what the top in your operating system gives, most probably you have some kind of fragmentation problem with your allocators.

Page 28
So again, looking at the statistics in there, we can see that he has a lot of blocks, and he has a blocks size that was at the moment 1.6 GB, I believe this was just one instance, so it's only one scheduler.
But we can see the max block size is 6.8 GB, but we can see at the carrier size, was largely the same for the current and maximum, so this is what our problem is, you have a fragmentation in the allocation of these binaries.
So for some reason, the allocators were allocating binaries in lots of different carriers, but one day when releasing them, it was not releasing all of the binaries within a carrier, it was one binary there, one binary there, and it was impossible to release these carriers. And then, he got a spike in ETS inserts, and he cannot put ets data into a carrier puts for binary allocation. And therefore trying to create ETS carriers, and you run out of memory.
So again we have to know what the average block size is, we can see that block size is about 800 bytes per block when we were at current, they had peak of 1.7 KB per block, and the carriers were about 7.8 and 7.7 MB per carrier. This is something you would expect.
But if you take the block size divided by the carrier size, we have a utilization about 22% when running at current, which is not good at all. But when we are at max, we had 93%, which is quite ok.
So what we want to do here is to find a better strategy for allocate these binaries so that we don't get into scenario when we are freeing binaries, the carriers can not be returned to operating system.

Page 29
So what we ended up changing there was to use .. the default allocator for binary is a normal best fit allocator, by using the address order best fit, we are trying to squeeze allocations further down into the memory space and therefore compacting them. Spending a couple of CPU cycles doing this, ...(没听清), notice any difference.
We also shrunk the size of the largest multiblock carriers, by doing this we were hoping that statistics would be in our favor, so that we could free more of the carriers. And that turned out to be the case as well.
I don't know exactly what his xxx(没听清，应该指的是内存使用率) now is, but it's not at 20%, that's more like 50% or 40%, which saved the system in a lot of cases. So there's nothing to deal with these crashes any more.

Page 30
Some of the new features are coming up lately.
So I was talking about the pool that was coming in R16B01, so this can only be migrated from things with the same type. It's migration in between schedulers, but it's still binary to binary migration, so you cannot migrate something from a binary allocation to an ets allocation yet. This is something that we probably get to work on eventually.
So this will not save the fragmentation problem having this pool, but it helps when you are having a scenario where you are allocating in a lot of schedulers in high load, and then your load shrinks for once, and it helps a lot, and you get a lot of deallocations. The reason for this introduction is that we have a customer that was in memory goaf as the load of system decreased, which is not really what you want to see, because you had a peak and then we allocate a lot of memory, lots of memory, and then the load shrunk, and he was just allocating in one scheduler, but he was not able to use the carriers in the other schedulers, and therefore the memory of that scheduler increased, and it wasn't able to deallocate the other schedulers. So by migrating these carriers to scheduler 1, we solve that problem. This by the way is turned on by default in 17.0, so check your system and see if you want to have it or not, we have only see the positive effective of this, but it might be possible that there are some down sides for it.
In R16B03, we have something called super carrier, which is where the erts_mmap functionality was add in. So this is a way for us to prealloc a huge chunk of memory for Erlang virtual machine at startup, so that we don't have to request for memory from operating system.
The reason why we put this in, is because we have a virtualized environment where one of our customers is running, we took about 20 seconds to do a malloc. So it was taking a long time, and there was a test was timing out for some reason. So we put this in place, so that they could preallocate 8 GB of memory, and don't have to request it from memory system at such long intervals.
It can also be used to limit the amount of memory that Erlang virtual machine uses, but ulimit is a better tool for that than using this.

(Question: Why is that? Why is ulimit better.....?)
Answer: You get the same results. And I think operating system in general is better at managing these things, because you kind of ... the reason why we use do singleblock carriers as operating system allocations is because it can cheat by taking memory from caches and so on and so on, if we are allocating things with mmap we don't get the caches that malloc uses and so on, so we don't get access to all of the memory that's in the system. So but if you use ulimit, you don't get the downside, but you get the same benefits.

Q&A
\1. Question: there is one super carrier for the entire system. So how does that work with the NUMA architecture?
Answer: I don't think we've done any benchmark on that actually to see how that works. The implementation about how it takes carriers and so on, I might be a bit fuzzy about it, so I am not 100% sure, but it some kind of taking on the same side on the allocating things. Don't know, unfortunately it's the answer.

\2. Question: how does the migration of carrier work with the NUMA system?
Answer: Yes, you can have problem with that, definitely. You will have remote memory access as you might want them to be. But if you do not want this behaviour, it's very easy to shut off. you dont have to deal with that. In systems that do not have lot of NUMA interactions with different things, it's just benificial to do it. Normally you dont want to have this scenario any way where memory is being allocated not release from these other parts in there.

(You have that problem with process migration in scheduler)
Yeah, as long as you do message passing, or interacting environments, .., we don't group things in NUMA nodes for processes in order for them to not have the overhead, and if you send a message from one process to something in another NUMA node, the memory of that message will remain in the original NUMA node, so we have a lot of these things, any way. ...

\3. Question: what does the S+1 mean? (指的是slides第15页中的最后一行)
Answer: I guess the S+1 I was talking about is just ... one plus.. that's the two one.
The thread zero .. and then 1 is the first scheduler, 2 is the second scheduler, 3 is the third scheduler, and so on and so on.. I might have made a mistake in this slide SO I'll fix it.
No, there is nothing at the end over there, it just ends at the last scheduler.

\4. Question: If NIF uses the driver allocator?
Answer: NO, it uses heap allocator, you allocate directly on the heap for things when you are building stuff there. of course if you make binaries that's bigger than 64 bytes, you will end up in the binary allocator. but NIFs have the advantage of building stuff directly on the heap, which is why they are a bit faster when calling small stuff than drivers.

Unless of course you go over the heap size, then it will create heap fragment, which is part of the heap allocators but in the different memory area.
All of the fragments get collapsed when you do garbage collection.

5 Question: where can I find the information about this stuff without reading the source code.
Answer: Yes you can. you can read my mind, and there are two other minds you can read as well(笑). In part of doing the work done with Fred to get the fragmentation problem, I was working ... recon(听不清，就是一起开发了recon). And see modular in recon_alloc, does some basic analysis for you, trys to figure out what's in the system. it has maybe 7 or 8 functions, their data analyse different aspects of things, problems that we have encountered. We are trying to add more things to it, but what I find is that most of the problems that you encounter are unique. It's not like that it's a general problem for everybody because then it would be a general setting, but if it's almost always a specific problem that somebody's having because they've written their code in certain way and therefore this happens. BUt for this fragmentation part, finding out there are many singleblock carriers rather than multiblock carriers, their functions in this library can do that.
With lot of documentation explaining all of these stuff, the documentation is almost better than the tool. I would say. So just reading documentation explains most of the things I did in my slides.