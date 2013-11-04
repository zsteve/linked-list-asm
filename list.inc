ulong	typedef dword
ushort	typedef	word
uchar	typedef byte

include masm32rt.inc

ELEM struct
	next ulong ?
	prev ulong ?
	data ulong ?
ELEM EndS

include list.asm

initList PROTO elemCount:DWORD, elemSize:DWORD