# RISC_CPU
A 16 bit RISC CPU with a simple instruction set. Designed and implemented completely in 2 weeks. 
Comes with modifyable size of memory as well as easy to implement on any FPGA board. 

I have included a Assembler python script to convert assembly to the custom ISA machine code. You can then program a main memory with the machine code to run on the CPU.

## How to use:
By following the given ISA, program the main memory and then supply clock and enable and reset signals to the CPU and the memory.

The Project already comes with an assembly already made.

To run a program please, activate RESET and then activate ENABLE after deactivating RESET to begin the execution.

## example assembly code : (Computes the first 10 fibonacci numbers)
```
mov r0 #0
mov r1 #1 
mov r3 #10  %limit
mov r7 #14
mov r4 #2      %counter
mov r5 #1   %incrememnt
add r2 r1 r0
mov r0 r1
mov r1 r2
add r4 r4 r5    % increment counter
cmp r4 r3   %compare counter and limit
skip ge 
jmp r7
halt
```
### Basic Data Path Of the Processor
![image](https://github.com/user-attachments/assets/e0687f02-0461-484e-8678-6f4c3077efaa)
### Instruction Set Architecture.   
![image](https://github.com/user-attachments/assets/7cf6f3fa-bad1-45f6-80fb-a714acf76af3)




