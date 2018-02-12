counter
=======

A device trigger the MC by an exception.
The MC counts a device, when the count reach 8'hf0, exports the signal 8'h10, else exports 8'h01.
When the device get a signal 8'h10, it reset the MC.

Counter.set(0)
while true
   if interrupt == 8'h81
      Counter.trriger()
   elif interrupt == 8'h10
      mc.reset()
   if Counter.value == 8'hf0
      port1.export(8'h10)
   else
      port1.export(8'h01)
