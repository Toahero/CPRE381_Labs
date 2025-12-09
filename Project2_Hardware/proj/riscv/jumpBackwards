.data
.text
.globl main
main:
    add x1, zero, zero #Initialize x1 to 0
    addi x2, zero, 10 #Initialize x2 to 10
   loopStart:
        addi x1, x1, 1

   	bge x1, x2, end
   
    	addi x1, x1, -1024

	j loopStart
	
end:

   wfi
