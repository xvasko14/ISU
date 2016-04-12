
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ISU - cviceni 5                  ;
; Vypocet Fibonacciho posloupnosti ;
; Vycisleni kvadraticke funkce     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

global start
%include 'rw32.inc'

section .data
x resd 1
hviezdicka db "* ",0

section .text

main:

trojuholnik:
call ReadUInt8
mov [x],al
mov ebx,[x]; num of cycles
mov edx,[x] ; num of cycles
xor eax,eax
mov esi,hviezdicka ; ked je v esi string a dame call writestring vypise nam hveizdicku ktora tam je

for:
	cmp eax,ebx
	je endfor
	mov ecx,eax
	while:
		cmp ecx,edx ; ecx je 0 urobi sa 5 krat
		je endwhile
		call WriteString
		inc ecx
		jmp while
	endwhile:
	inc eax
	call WriteNewLine
	jmp for
endfor:

call WriteNewLine


troj:
mov ebx,[x]; num of cycles
mov edx,[x] ; num of cycles
xor eax,eax

fortr:
	cmp eax,ebx
	je endfortr
	inc eax
	mov edx,eax
	dec eax
	xor ecx,ecx
	whiletr:
		cmp ecx,edx
		je endwhiletr
		call WriteString
		inc ecx
		jmp whiletr
	endwhiletr:
	inc eax
call WriteNewLine
	jmp fortr
endfortr:

call WriteNewLine

trojpra:
mov ebx,[x]; num of cycles
mov edx,[x] ; num of cycles
xor eax,eax

forpra:
	cmp eax,ebx
	je endforpra
	mov ecx,eax
	inc ecx
	push ebx
	inc eax
	medze: ; cykulus na medzeru
		cmp ebx,eax
		je konmed
		push eax ; kvoli zmene al
		mov al,' '
		call WriteChar
		call WriteChar
		pop eax
		dec ebx
		jmp medze
	konmed:
	dec eax ; dekremetacia eax na 0
	pop ebx

	whilepra: ;urobime jednu hviezdicku
		cmp ecx,0
		je endwhilepra
		call WriteString
		dec ecx
		jmp whilepra
	endwhilepra: ; x(4) krat opakujeme cyklus
	inc eax
call WriteNewLine ; skaceme na novy riadok
	jmp forpra
endforpra:

call WriteNewLine

trojlavy:
mov ebx,[x]; num of cycles
mov edx,[x] ; num of cycles
xor eax,eax

forlavy:
	cmp eax,ebx
	je endforlave
	mov ecx,eax
	push eax
	medzelave:
		cmp eax,0
		je kon
		push eax
		mov al,' '
		call WriteChar
		call WriteChar
		pop eax
		dec eax
		jmp medzelave
	kon:
	pop eax

	whilelave:
		cmp ecx,edx
		je endwhilelave
		call WriteString
		inc ecx
		jmp whilelave
	endwhilelave:
	inc eax
	call WriteNewLine
	jmp forlavy
endforlave:

stvorec:
