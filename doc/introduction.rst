Introduction 
=============

Computability
=============

If some problem is computable, we can resolve it by some mathematic computing
within estimate and receptable time. A problem is computable, we can use
computer to get the result.

Computer consists of some parts: some relate with computing, and some with the
interaction with person. Now let us focus on the computing parts.
A simple computing model is as this: memory, processor, and interface.
Memory usually stores the data(to process) and program(control the processor)
seperatly.
Processor processes the data according to the program.
Interface exchange the data and program between memory and processor.

Here, we consider that the computing and storage are separate.

Processor
=========

A computing process consists of two parts: computing and computing flow.
Computing is the single computing action such as add,
flow is the order of the single action.
The computing module is called arithmetic logic unit(ALU),
the flow control module is called controller.
The processor is controlled by the instruciton.
All instructions of a processor is called instruciton set.

Instruction Set
===============

Instruction is the interface between processor and person.
The instruciton types are different according to the architecture of the
different processors.

Universal ISA
=============

The Instruction Set Architecture(ISA) detemines the processor structure.
A program compiled to a certain IS, can excute on the same type processor.
Across ISA, program usually need to be rewritten or changed some instructions,
because the assembly languages are different.

An instruction is usually consist of operation and operands.
Different ISAs have different operations and different mounts and types of operands.
The operations is excused by some logic circuits and the ALU.
The operands may be flag, data or address.


Bean instruciton set is designed from the view of data flow.
Each instruciton controls some buttons which enable or close some ports to get
or send data.
The data flows on various buses.


