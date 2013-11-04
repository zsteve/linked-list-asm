; assembler demo of doubly linked list


include list.inc

.data

.code
start:
main proc 
	printf("Assembler demo of doubly linked list\n")
	invoke initList, 100, 1
	invoke insertNode, 1
	invoke insertNode, 1
	invoke deleteNode
	xor ecx, ecx
	.while 1
		pushad
		call nextNode
		.if eax==0
			popad
			printf("\n\n REACHED END OF LIST : Iterations : %d\n", ecx)
			jmp @@exitloop1
		.endif
		popad
		inc ecx
	.endw
	@@exitloop1:
	xor ecx, ecx
	.while 1
		pushad
		call prevNode
		.if eax==0
			popad
			printf("\n\n REACHED START OF LIST : Iterations : %d\n", ecx)
			jmp @@exitloop2
		.endif
		popad
		inc ecx
	.endw
	@@exitloop2:
	inkey
	Ret
main EndP
	call main
	ret
end start