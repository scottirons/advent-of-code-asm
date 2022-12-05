TITLE Advent of Code Day 4     (day4.asm)

; Author: Scott Irons
; Last Modified:
; Description: Modified from template.asm from Oregon State CS 271

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)
BUFFER_SIZE = 12000
CHAR_SIZE = SIZEOF BYTE

.data

; displaying results
partA		BYTE "Part A result: ",0
partB		BYTE "Part B result: ",0

; reading file and storing it
fileName	BYTE "../input.txt",0
buffer		BYTE BUFFER_SIZE DUP (?)
bytesRead	DWORD ?
fileHandle	DWORD ?

; for comparison's sake
dash		BYTE '-'
newLine		BYTE '\n'

; index of parsing string and str_len stuff
currIndex	DWORD 1
strLen		DWORD ?
adjIndex	DWORD ?

; store the values parsed from the buffer
numArr		DWORD 4 DUP (?)
tempNum		DWORD ?
whichNum	DWORD ?

; part A result
resultA		DWORD ?



.code
main PROC
	
	; create filehandle
	mov		edx, offset fileName
	call	OpenInputFile
	mov		fileHandle, eax

	mov		eax, fileHandle
	mov		edx, OFFSET buffer
	mov		ecx, BUFFER_SIZE
	call	ReadFromFile
	
	; how many bytes were read from the string
	mov		bytesRead, eax

	; current index in the num array. Once this hits 3 (or 4 we'll see what I end up with), I will do comparison stuff for solving ;P
	mov		whichNum, 0

	; for parsing char-by-char
	mov		ecx, OFFSET buffer

	;mov		edx, OFFSET buffer	
	;call	WriteString

_KeepParsing:
	mov		al, [ecx]
	cmp		al, '-'
	jne		_IsComma
	inc		whichNum
	jmp		_WeBack

_IsComma:
	cmp		al, ','
	jne		_IsNewLine
	inc		whichNum
	jmp		_WeBack

_IsNewLine:
	cmp		al, 10
	jne		_NumberTime
	jmp		_AddToTotal

_WeBack:
	; increment index
	add		currIndex, 1
	inc		ecx
	mov		ebx, bytesRead
	cmp		ebx, currIndex
	jg		_KeepParsing
	je		_AddToTotal
	jmp		_ToEnd


_NumberTime:
	mov		ebx, OFFSET numArr
	
	; keep track of other offset
	push	ecx
	mov		ecx, whichNum
	cmp		ecx, 0
	je		_AlreadyZero

; increment the index
_GetToIndex:

	add		ebx, 4
	loop	_GetToIndex

; at the correct index
_AlreadyZero:
	push	ebx

	mov		ecx, [ebx]
	mov		ebx, ecx
	mov		eax, 10
	mul		ebx

	; do temp stuff
	mov		tempNum, eax

	; update value at index
	pop		ebx
	mov		ecx, tempNum
	mov		[ebx], ecx
	; restore register to get current char. Subtract 48 to normalize it. Add this to running total
	pop		ecx
	
	mov		eax, tempNum
	mov		al, [ecx]
	cbw
	cwd
	cdq
	mov		tempNum, eax
	
	sub		tempNum, 48
	mov		eax, tempNum

	; updated?
	add		[ebx], eax
	mov		eax, [ebx]

	jmp		_WeBack

_addToTotal:
	push	ecx

	mov		whichNum, 0
	mov		ebx, OFFSET numArr

	; compare pairs of numbers with EAX and ECX
	mov		eax, [ebx]

	; number 3
	add		ebx, 8
	mov		ecx, [ebx]
	
	; comparing LOWER NUMBERS OF EACH
	cmp		eax, ecx
	je		_IncrementCountA
	jl		_BGreaterEqualD

	; AT THIS POINT, the lower number in the second pair is less. Check if D is greater than or equal to B
	; ebx currently points to the third number
	sub		ebx, 4
	mov		eax, [ebx]
	add		ebx, 8
	mov		ecx, [ebx]

	; compare d and b
	cmp		ecx, eax
	jge		_IncrementCountA
	jmp		_AvoidInfiniteLoop

_BGreaterEqualD:
	; ebx currently points to third number
	sub		ebx, 4
	mov		eax, [ebx]
	add		ebx, 8
	mov		ecx, [ebx]

	; compare 
	cmp		eax, ecx
	jl		_AvoidInfiniteLoop


_IncrementCountA:
	inc		resultA

_AvoidInfiniteLoop:
	; for my weird loop
	mov		ecx, 4
	mov		ebx, OFFSET numArr

_clearArray:
	;
	mov		eax, [ebx]
	;call	WriteInt
	mov		eax, 0
	mov		[ebx], eax
	add		ebx, 4
	loop	_clearArray

	pop		ecx
	mov		ebx, bytesRead
	cmp		ebx, currIndex
	jne		_WeBack

_ToEnd:
	mov		edx, OFFSET partA
	call	WriteString
	mov		eax, resultA
	call	WriteInt

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; test thing
procedure PROC
	mov		edx, OFFSET partA
	call	WriteString

	ret
procedure ENDP


END main
