Introduction
============

These testbenches are the programs of the problems from ProjectEuler.net.

Project
=======

Mulitples of 3 and 5
--------------------

Problem 1
~~~~~~~~~
If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.
Find the sum of all the multiples of 3 or 5 below 1000.

Program
~~~~~~~

::

   x0=0
   y=0
   d3=3
   d6=6
   d9=9
   d12 = 12
   d5=5
   d10 = 10
   d15 = 15
   
   while x < 30
      y = y+x0+d3
      y = y+x0+d6
      y = y+x0+d9
      y = y+x0+d12
      y = y+x0+d5
      y = y+x0+d10
      y = y+x0+d15
      x0 = x0+d15
   end
