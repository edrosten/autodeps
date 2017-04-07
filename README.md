Autodeps for C++
================

I like Make. Make is best ~~pony~~ build tool. If you don't know it
already, it expresses dependencies as a DAG (directed acyclic graph), so
a node lists it's dependencies and has a rule about how to generate the
file(s) from the dependencies. If a file is older than its dependencies,
then it's stale and needs to be rebuilt.

If the DAG is specified correctly, then if you change one source file,
you'll rebuild the minimum necessary with the maximum possible
parallelism...

...I meant GNU Make by the way, of course. 

In Make, dependencies are generally specified statically, like this:

```make
target: dependency1 dependency2
```

The problem with this is that in many cases dependencies are not static.
That is, the dependencies are a function of the dependencies. What? OK,
let me illustrate. Suppose you have a dependency:

```make
foo.o: foo.cc
```

OK, so the object file foo.o depends on foo.cc. So far, so good. But
it's almost certainly incomplete. If foo.cc #include's anything then
foo.o also relly depends on that too. In other words with the incomplete
dependencies, if you modify that header and type "make", foo.o won't
rebuild because make doesn't know it ought to. This has the annoying
problem that when you're modifying headers, you keep having to "make
clean" and rebuild *everything*.

Fortunatley, make provides a solution for you in typical make fashion:
it provides the mechanism to deal with dynamic dependencies and you
provide the language specific tools. You can just do:

```make
include morestuff
```

Naturally, morestuff is going to be dynamically generated, and you give
as manmy arguments as you like. GCC is nice and since it knows about the
dependencies (it has to when it actually does the compile), and will
emit them in make format while it does the build, ready to be included
next time. So if a source file changes, the .o is rebuilt and new
dependencies are generated. Next time we come to build, it checks those
fresh new dependencies.


Take a look at the code.

Now try creating an empty "c.h" and make b.h include it. Type make
(you'll see a.o rebuild). Now touch "c.h". Make will rebuild a.o again
as it should. Revert b.h and remove c.h. Make again builds it correctly.
Touch c.h again and type make and nothing (correctly) gets rebuilt.


Actually, the mechanism is is subtle and interesting.  It looks like a
simple include directive, but the key is that if morestuff doesn't
exist, make will build it first, include it and then process the rest of
the build. You cn do cool stuff there, but fortunately it's not needed
here.
