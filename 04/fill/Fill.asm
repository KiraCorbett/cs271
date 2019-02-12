// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.


(START)
	@SCREEN
	D=A
	@current // current var for pixel
	M=D

(KEYBOARD)
	@KBD
	D=M
	@WHITE
	D;JEQ	// if == 0, jump to white
	@BLACK
	D;JGT	// if > 0, jump to black

(WHITE)
	// draw white pixels
 	@current
	A=M
	M=0

	// increment current pixel and reduce remaining pixels 
	@current
	D=M+1
	M=D
	@KBD
	D=A-D
	@END
	0;JMP

(BLACK)
	// draw black pixels
	@current
	A=M
	M=-1
    
    // increment current pixel and reduce remaining pixels 
    @current
    D=M+1
	M=D
	@KBD
	D=A-D
	@END
	0;JMP

(END)
	@START
	D;JEQ	// return to start if > 0
	@KEYBOARD
	D;JGT	// else return to drawing black
