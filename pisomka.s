;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ISU - test 2                      ;
; Reseni jednoducheho matematickeho ;
; problemu v asembleru              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

global start
%include 'rw32.inc'

section .data

a dd 10
b dd 20
c dd 7
d dd 8
lenA resd 1
lenB resd 1
bufA resb 50
bufB resb 50
buflen dd 50

prompt db 10,"Zadejte dva retezce pro porovnani.",10,0
Akratsi db "Prvni retezec je kratsi.",10,0
Adelsi db "Prvni retezec je delsi.",10,0
ABstejne db "Retezce jsou stejne.",10,0
ABruzne db "Retezce jsou ruzne.",10,0

section .text
main:
	jmp calldivadd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 1. uloha (4 body)                                                ;
; Vzdy pouzivejte cdecl, tj. uklizi volajici, vysledek v eax       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Vytvorte funkci divadd, ktera spocita (a + b) / (c + d).
; Pro mezisoucty pouzijte lokalni promenne.
; Tuto funkci nakonec zavolejte a vysledek vypiste pomoci WriteInt32
; - spocitejte (10 + 20) / (7 + 8), tj. vysledek je 2
;
; Bodovani:
; 1b Vypocet
; 1b Prebirani parametru pres zasobnik, konvence volani, uklid
; 1b Pouziti lokalnich promennych na zasobniku
; 1b Po zavolani funkce jsou zachovany hodnoty registru (mimo eax)
;
; Odpovidajici kod v C:
;
; int divadd(int a, int b, int c, int d) {
;	int x = a + b;
;   int y = c + d;
;   return x / y;
; }
;
; WriteInt32(divadd(10, 20, 7, 8)); // volejte dle manualu v rw32.inc

priklad1:

divadd:
	push ebp
	mov ebp,esp
	mov eax,[ebp+8] ; posledny parameter d
	mov ebx,[ebp+12] ; c
	mov ecx,[ebp+16] ; b
	mov edx,[ebp+20] ; prvy parameter a
	add ebx,eax ;ebx = c+d
	mov [ebp-4],ebx ; y=ebx
	xor eax,eax ; free eax

	add eax,ecx ;eax = b
	add eax,edx ;eax = a+b
	mov [ebp-8],eax ; x = eax
	cdq
	div dword[ebp-4]; v eax je delitel
	mov esp,ebp ; esp vratime do povodneho stavu
	pop ebp
	ret
calldivadd:
	mov eax,[a]
	mov ebx,[b]
	mov ecx,[c]
	mov edx,[d]
	push eax
	push ebx
	push ecx
	push edx
	call divadd
	call WriteInt32
	;pop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 2. uloha (4 body)                                                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Prepiste nasledujici kod do assembleru. Jak se pracuje s funkcemi
; pro konzoli (Write*, Read*) najdete v hlavice knihovny rw32.inc.
;
; Bodovani:
; 1b Vstup a vystup na konzoli
; 2b Konstrukce do-while, if
; 1b Porovnani retezcu pomoci retezovych instrukci
;
; do {
;	WriteString(prompt);
;	// nacti prvni retezec (prazdny = konec)
;   lenA = ReadString(bufA, buflen);
;	// nacti druhy retezec
;	lenB = ReadString(bufB, buflen);
;
;   if (lenA < lenB) {
;		WriteString(Akratsi);
;	} else if (lenA > lenB {
;		WriteString(Adelsi);
;   } else {
;		// porovnej je
;		if (bufA == bufB) { // pouzijte retezove instrukce
;			WriteString(ABstejne);
;		} else {
;			WriteString(ABruzne);
;		}
;	}
; } while(lenA > 0 || lenB > 0);

priklad2:
do:
	mov esi,prompt
	call WriteString
	mov ebx,[buflen]
	mov edi,bufA
	call ReadString
	;eax je ulozeny skutocny pocet nacitanych znakov

	mov [lenA],eax
	mov edi,bufB
	call ReadString

	mov [lenB],eax
	if:
		cmp byte[lenA],al ; al=lenB
		jnl elseif
	the:
		mov esi,Akratsi
		call WriteString
		jmp endif
	elseif:
		cmp byte[lenA],al
		jng else

		mov esi,Adelsi
		call WriteString
		jmp endif
	else:
		mov ecx,[lenA]
		mov edi,bufA
		mov esi,bufB
		repe cmpsb;porovnanie bufA buf B v edi esi cez cmpsb
		jne else2 ; vysledok je bud equal or not equal
		then:
		 mov esi,ABstejne
		 call WriteString
		 jmp endif ;koniec
		else2:
		 mov esi,ABruzne
		 call WriteString
	endif:
	xor eax,eax
	xor ebx,ebx
while:
cmp dword[lenA],eax
ja do
cmp dword[lenB],ebx
ja do
ended:

