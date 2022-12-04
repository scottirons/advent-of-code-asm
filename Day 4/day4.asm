TITLE Advent of Code Day 4     (day4.asm)

; Author: Scott Irons
; Last Modified:
; Description: Modified from template.asm from Oregon State CS 271

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)
BUFFER_SIZE = 100

.data

fileName	BYTE "../test.txt",0
buffer		BYTE BUFFER_SIZE DUP (?)
bytesRead	DWORD ?
fileHandle	DWORD ?


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

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
