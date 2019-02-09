// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

 // Initialize R0
@R0
D=M

// Initialize R1
@R1
D=M
@val
M=D

// Initialize R2
@R2
M=0

// Decrement a counter value (val), then increment original value to add to itself
// and create a multiplier
(LOOP)
	@val
	D=M
	@END
	D;JEQ // (if==0), goto END
	@val
	M=D-1 // decrement counter value

	// Increment R2
	@R0
	D=M
	@R2
	M=D+M
	@LOOP
	0;JMP

//Finish
(END)
@END
0;JMP
