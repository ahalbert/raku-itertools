Module
------
itertools - A direct port of Python's itertools to perl6.

Description
-----------
It provides all the functionality that python's itertools does, including lazy evaluation.
In the future, I'd like to maximize the performance of these functions.
Function signatures may be a little different. 

I needed a ``itertools.combinations_with_replacement``` and couldn't find an easy
builtin or library to do it.

It turns out perl6 has most of these functions built in already. Unfortunatley, I did not realize that until after writing it. Oops. 

Copying
-------
Copyright (c) 2016 Armand Halbert.  All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. Perl6 is distributed
under the GNU GPL. 

Prerequisites
-------------
* perl6 (Obviously)

Build/Installation
------------------
For now, clone from this repository. 

Author
------
Armand Halbert <armand.halbert@gmail.com>
