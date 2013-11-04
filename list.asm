LIST struct
	first	dd ?
	last	dd ?
	current	dd ?
LIST EndS

.data

	myList LIST {}

.code

initList proc elemCount:DWORD, elemSize:DWORD
	LOCAL last:DWORD
	; initList initializes the list to elemCount elements of elemSize size
	; first element is a special case
	mov ebx, alloc(sizeof(ELEM))	; init first elem
	mov myList.first, ebx
	mov ebx, myList.first
	push ebx
	push ecx
	mov eax, alloc(elemSize)
	mov dword ptr [eax], 0
	pop ecx
	pop ebx
	mov [ebx].ELEM.data, eax		; store the data pointer
	mov [ebx].ELEM.prev, NULL		; NULL ptr means end or start
	mov last, ebx
	mov ecx, 1						; we use ECX as counter for number initialized
loopinit:
	push ebx						; save values of EBX and ECX
	push ecx
	mov eax, alloc(sizeof(ELEM))
	pop ecx
	pop ebx
	mov [ebx].ELEM.next, eax
	push eax
	push ebx
	push ecx
	printf("Next :\t\t%X\n", [ebx].ELEM.next)
	pop ecx
	pop ebx
	pop eax
	mov ebx, eax
	pushad
	printf("Current :\t%X\n", ebx)
	popad
	push ebx
	push ecx
	mov eax, alloc(elemSize)
	mov dword ptr [eax], 0
	pop ecx
	pop ebx
	mov [ebx].ELEM.data, eax
	mov eax, last
	mov [ebx].ELEM.prev, eax
	mov last, ebx
	push ebx
	push ecx
	printf("Last :\t\t%X\n", [ebx].ELEM.prev)
	pop ecx
	pop ebx
	inc ecx
	cmp ecx, elemCount
	jb loopinit
	mov eax, last
	mov myList.last, eax
	mov eax, myList.first
	mov myList.current, eax
	mov eax, 1
	Ret
initList EndP

getData proc 
	mov eax, myList.current
	mov eax, [eax].ELEM.data
	Ret
getData EndP

nextNode proc
	mov eax, myList.current
	cmp [eax].ELEM.next, 0
	je @@noNextNode
	mov eax, [eax].ELEM.next
	mov myList.current, eax
	mov eax, 1
	ret
@@noNextNode:
	xor eax, eax
	Ret
nextNode EndP

prevNode proc
	mov eax, myList.current
	cmp [eax].ELEM.prev, 0
	je @@noPrevNode
	mov eax, [eax].ELEM.prev
	mov myList.current, eax
	mov eax, 1
	ret
	@@noPrevNode:
	xor eax, eax
	Ret
prevNode EndP

insertNode proc elemSize:DWORD
	; inserts a new node after the one pointed to by myList.current
	mov edx, myList.current
	mov ecx, [edx].ELEM.next
	push edx
	push ecx
	mov eax, alloc(elemSize)
	pop ecx
	pop edx
	mov [edx].ELEM.next, eax
	mov [ecx].ELEM.prev, eax
	mov [eax].ELEM.prev, edx
	mov [eax].ELEM.next, ecx
	mov eax, 1
	Ret
insertNode EndP

deleteNode proc
	; deletes the node pointed to by myList.current
	mov edx, myList.current
	mov ecx, [edx].ELEM.prev
	mov ebx, [edx].ELEM.next
	pushad
	free(edx)
	popad
	.if ecx!=0
		mov [ecx].ELEM.next, ebx
	.endif
	.if ebx!=0
		mov [ebx].ELEM.prev, ecx
	.endif
	mov myList.current, ebx
	Ret
deleteNode EndP