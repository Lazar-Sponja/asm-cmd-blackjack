COMMENT &
/*****************************************************************
           ****** IGRICA ZMIJICE ******

Napisana koristeci Irvine32.inc biblioteku i Irvine-ove
preporuke za modele koji se koriste i velicinu steka za rad
u VS2017.
Na samom pocetku korisnika docekuje interaktivni WELCOME meni
u kom se vrsi izbor brzine kretanja zmijice, prilika da se 
pokrene igra sa default vrednoscu brzine i opcija za napustanje
igrice.
U bilo kom trenutku tokom igranja moguce je napustiti igricu
pritiskom na ESC dugme, cime se korisnik vraca na WELCOME meni
gde se moze izabrati opcija za konacan izlazak iz igre.

Kod i logika igrice su isparcani na najsitnije logicke celine
grupisane u labele i procedure, kako bi krajnje upravljanje bilo
jednostavno. Svaka procedura odradjuje pipav deo posla koji joj
je prepusten, tako da je detaljisanje u main proceduri minimalno,
bez guzve i necitkosti.
*****************************************************************/&

include Irvine32.inc
include macros.inc

.const
	;// Definisanje velicine prozora 
	xmin = 0	;// leva ivica
	xmax = 99	;// desna ivica
	ymin = 0	;// gornja ivica
	ymax = 31	;// donja ivica

	;// Oznake za levo, desno, gore, dole, ESC, ASCII
	LEFT_KEY = 025h        
	UP_KEY = 026h
	RIGHT_KEY = 027h
	DOWN_KEY = 028h
	ESC_KEY = 01Bh
	
	;// Definisanje pocetnih koordinata zmijice i pocetnog smera kretanja
	;// Valja blago prepraviti kod u initSnake kako bi se zmija postavila
	;// vertikalno, umesto horizontalno, kao sto je trenutno.



.data
	;// Stringovi za ispis WELCOME screena i izbor brzine zmijice

	DealerInterface byte 116, 13,"   |                                                                                                ____________   ",0
                             byte"----                                                                                               '|B       ! |   ",0
                             byte"                                                                                                  '||  L   J   |   ",0
                             byte"                                                                                                  |||    A     |   ",0
                             byte"                                                                                                  |||   C  C   |   ",0
                             byte"                                                                                                  ||| K      K |   ",0
                             byte"                                                                                                  |||__________|   ",0
                             byte"                                                                                                  |'__________'    ",0
                             byte"                                                                                                                   ",0
                             byte"                                                                                                                   ",0
                             byte"                                                                                                                   ",0
                             byte"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",0

	ThreePlayerInterface byte 40, 17,"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",0
								 byte"|   |                                 |",0
							   	 byte"|----                                 |",0
							  	 byte"|                                     |",0
							 	 byte"|                                     |",0
								 byte"|                                     |",0
								 byte"|                                     |",0
								 byte"|                                     |",0
								 byte"|                                     |",0
								 byte"|                                     |",0
							  	 byte"|                                     |",0
							 	 byte"|                                     |",0
							 	 byte"|                                     |",0
							 	 byte"|                                     |",0
								 byte"|                                     |",0
								 byte"|                                     |",0
								 byte".......................................",0
	
    CardLookUpTable byte "123456789xJQK"
    CardLookUPNumber10 byte "10",0
    Card0 byte 13,8,"____________", 0,"|          |", 0,"|          |", 0,"|    /\    |", 0,"|    \/    |", 0,"|          |", 0,"|          |", 0,"____________",0
    Card1 byte 13,8,"____________", 0,"|          |", 0,"|          |", 0,"|     O    |", 0,"|   O I O  |", 0,"|          |", 0,"|          |", 0,"____________",0
    Card2 byte 13,8,"____________", 0,"|          |", 0,"|          |", 0,"|    nn    |", 0,"|    \/    |", 0,"|          |", 0,"|          |", 0,"____________",0
    Card3 byte 13,8,"____________", 0,"|          |", 0,"|          |", 0,"|    /^\   |", 0,"|   * I *  |", 0,"|          |", 0,"|          |", 0,"____________",0

    HitButtonSprite byte 13,4, "------------",0,"|   H I T  |",0,"------------",0
    StandButtonSprite byte 17,4,"----------------",0, "|   S T A N D  |", 0,"----------------",0
    DoublDownButtonSprite byte 17,4,"----------------------------",0, "|   D O U B L E   D O W N  |", 0,"----------------------------",0

	Igrac STRUCT
		cardCount BYTE 0
		pointCount BYTE 0
		winCount  BYTE 0 ;maybe change to like a higher order so more games can be played
		cards BYTE 22 DUP(0)
	Igrac ENDS
	
	OkruzenjeIgraca STRUCT
		
		IgracUOkruzenju DWORD 0
		SpriteZaOkruzenje DWORD 0
		VelicinaProzora BYTE 0
		KolikoKarataUJednomRedu BYTE 0
		KoordinateProzora BYTE 0,0
		KoordinateCentraZaCrtanjeKarata BYTE 0,0

	OkruzenjeIgraca ENDS
	
	


    SelectedButton byte 0

    AktivniIgrac byte 0

    Igrac1Karte byte 5,3,5,9,42,47,23,36,19,50,13,31,0,0,0,0,0,0,0,0,0
    Igrac1BrojKarata byte 9
    Igrac1Peni byte 0
    Igrac1Pobede byte 0



	windowRect SMALL_RECT <xmin, ymin, xmax, ymax>      ;// Velicina prozora
	winTitle byte "Zmijica", 0							;// Naslov programa
	cursorInfo CONSOLE_CURSOR_INFO <>					;// Informacije o kursoru


.data?
	;// Promenljive koje su potrebne za hendlovanje podataka unetih u konzolu tj. interakciju sa korisnikom
	stdOutHandle handle ?
	stdInHandle handle ?		;// Promenljiva za kontrolu inputa u konzolu
	numInp dword ?				;// Broj bajtova u ulaznom baferu
	temp byte 16 dup(?)			;// Promenljiva koja sadrzi podatke tipa INPUT_RECORD
	bRead dword ?				;// Broj procitanih ulaznih bajtova

	BrojRedovaCrtanjeKarta byte ?
	BrojNacrtanihKarata byte ?
	BrojIgraca byte ?
	Okruzenja OkruzenjeIgraca 4 dup(<?>)
	Igraci Igrac 4 dup(<?>)

.code
;// -----------------------------------------------------------------------------------------------------------
;// main procedura koja postavlja WELCOME screen, hendluje izbor brzine zmijice
;// i prosledjuje podprocedurama inicijalizaciju ekrana za pocetak igre, postavljanje
;// pocetne zmijice na sredinu ekrana, generisanje hrane na nasumicnom mestu i poziva
;// najvazniju proceduru startGame koja prati komande koje zadaje korisnik i kontrolise
;// kretanje zmijice.
;// Zbog pozivanja silnih procedura koje svaka za sebe obavljaju deo posla, interfejs
;// u main proceduri je prilicno jednostavan, na stranu to sto je potreban veliki
;// broj komandi za obavljanje nekih jednostavnih funkcija, sto nije slucaj sa nekim
;// visim programskim jezikom.
;// -----------------------------------------------------------------------------------------------------------

main PROC


	mov BrojIgraca, 4
	mov AktivniIgrac, 0
	;/////////prep values
	
	mov esi, offset Okruzenja
	mov edx, offset Igraci

    mov [esi], edx;pointer ka igracu koji igra u tom okruzenju
	ADD esi, 4
	mov [esi], offset DealerInterface;pointer ka sprajtu interfacea
	ADD esi, 4
	mov byte ptr [esi], 40;okvir u kome se dele karte
	INC esi
	mov byte ptr [esi], 22;koliko karata moze da stoji u redu pre nego sto predje u novi red
	INC esi
	mov byte ptr [esi], 0;gde se crta prozor x
	INC esi
	mov byte ptr [esi], 0;gde se crta prozor y
	INC esi
	mov byte ptr [esi], 40;centar odakle se crtaju karte x
	INC esi
	mov byte ptr [esi], 5;centar odakle se crtaju karte y

	mov byte ptr [edx], 0
	INC edx
	mov byte ptr [edx], 0
	INC edx
	mov byte ptr [edx], 0

	INC esi;okruzenje 2
	ADD edx, 22;igrac 2

	mov [esi], edx;pointer ka igracu koji igra u tom okruzenju
	ADD esi, 4
	mov [esi], offset ThreePlayerInterface;pointer ka sprajtu interfacea
	ADD esi, 4
	mov byte ptr [esi], 14;okvir u kome se dele karte
	INC esi
	mov byte ptr [esi], 5;koliko karata moze da stoji u redu pre nego sto predje u novi red
	INC esi
	mov byte ptr [esi], 0;gde se crta prozor x
	INC esi
	mov byte ptr [esi], 11;gde se crta prozor y
	INC esi
	mov byte ptr [esi], 6;centar odakle se crtaju karte x
	INC esi
	mov byte ptr [esi], 20;centar odakle se crtaju karte y

	mov byte ptr [edx], 0
	INC edx
	mov byte ptr [edx], 0
	INC edx
	mov byte ptr [edx], 0

	INC esi;okruzenje 3
	ADD edx, 22;igrac 3

	mov [esi], edx;pointer ka igracu koji igra u tom okruzenju
	ADD esi, 4
	mov [esi], offset ThreePlayerInterface;pointer ka sprajtu interfacea
	ADD esi, 4
    
	mov byte ptr [esi], 14;okvir u kome se dele karte
	INC esi
	mov byte ptr [esi], 5;koliko karata moze da stoji u redu pre nego sto predje u novi red
	INC esi
	mov byte ptr [esi], 38;gde se crta prozor x
	INC esi
	mov byte ptr [esi], 11;gde se crta prozor y
	INC esi
	mov byte ptr [esi], 45;centar odakle se crtaju karte x
	INC esi
	mov byte ptr [esi], 20;centar odakle se crtaju karte y

	mov byte ptr [edx], 0
	INC edx
	mov byte ptr [edx], 0
	INC edx
	mov byte ptr [edx], 0

	INC esi;okruzenje 4
	ADD edx, 22;igrac 4

	mov [esi], edx;pointer ka igracu koji igra u tom okruzenju
	ADD esi, 4
	mov [esi], offset ThreePlayerInterface;pointer ka sprajtu interfacea
	ADD esi, 4
	mov byte ptr [esi], 14;okvir u kome se dele karte
	INC esi
	mov byte ptr [esi], 5;koliko karata moze da stoji u redu pre nego sto predje u novi red
	INC esi
	mov byte ptr [esi], 76;gde se crta prozor x
	INC esi
	mov byte ptr [esi], 11;gde se crta prozor y
	INC esi
	mov byte ptr [esi], 84;centar odakle se crtaju karte x
	INC esi
	mov byte ptr [esi], 20;centar odakle se crtaju karte y

	mov byte ptr [edx], 0
	INC edx
	mov byte ptr [edx], 0
	INC edx
	mov byte ptr [edx], 0

	GameLoop:

	call DrawBackGround






main ENDP
;// --------------------------------------------------------------------------------------------


DrawBackGround PROC USES eax ebx edx ecx
    mov eax, brown + (lightGray * 16)									 ;// Boja interfejsa i prozora. Upisuju se u al i ah registre, zato je zapis ovakav
    call SetTextColor  
	movzx eax, BrojIgraca
	;mov ebx, AktivniIgrac
	mov ecx, offset Okruzenja
	ADD ecx, 4;adresa sprajta za okruzenje
	mov ebx, [ecx]
	ADD ecx, 6
	mov dx, [ecx]
	DrawPlayerInterfaces: 


	call DrawSprite

	DEC eax

	ADD ecx, 8
	mov ebx, [ecx]
	ADD ecx, 6
    mov dx, [ecx]
	cmp eax,0
	jne DrawPlayerInterfaces


	RET
DrawBackGround ENDP

NacrtajKarateIgraca PROC USES eax ecx edx ebx esi;eax, ebx, ecx, edx su temp za racunanje, esi sadrzi adresu radnog ogruzenja u kome crta karte

	mov ebx, [esi];pointer na igraca
	ADD esi, 8
	mov cx, [esi];granice prozora i koliko karata moze da ima prozor u jednom redu
	ADD esi,4 
	movzx eax, byte ptr [ebx]
	mov esi, ebx; esi je sada pointer na igraca


	DEC eax


	XOR edx,edx

	DIV cl ;koliko ce biti redova

	mov dx, [esi];gde treba da crta karte

	INC al
	mov BrojRedovaCrtanjeKarta, al ;BrojRedovaCrtanjeKarta ce da cuva broj redova
	SHL al, 1 ;mnozi sa dva za pomeraj polovine vertikalnog razmaka kursora
	SUB dh, al;vertikalna pocetna pozicija kursora
	mov BrojNacrtanihKarata, 0;vodi racuna koliko karata je nacrtano
	mov al, BrojRedovaCrtanjeKarta

		VerticalLoop:
		push ecx;cuva vrednosti cl jer ce posle koristiti za brojace

		push edx

		cmp al,1
		je NijePunRedKarata
		mov al, cl;al prima koliko ce karata da crta u ovom redu
		jmp PronadjenaKolicinaKarata
		NijePunRedKarata:
		mov al, [esi];esi pokazuje na koliko karata igrac ima u ruci
		SUB al, BrojNacrtanihKarata;isto al prima koliko karata treba da nacrta
		PronadjenaKolicinaKarata:

		;/////////////////

		mov cl, al;cl cuva koliko karata crta u ovom redu

		mov bl, dl; ovde ce biti x pozicija prve karte
		mov bh, al; ovde ce biti korak/ trenutno je broj karata u redu
		mov ah, 5
		MUL ah
		cmp al, ch
		jl PronadjenaPocetnaX
		mov al, ch ;ako je al izvan granica, vrati ga na granice
		PronadjenaPocetnaX:
		SUB bl, al; pronadjena x pozicija prve karte

		;//////////////////////////////

		mov al, ch
		SHL al, 1;granice prozora za karte je duplo veca od polovine

		XOR edx,edx
		DIV bh;razmak izmedju karata

		cmp al, 14
		jl PronadjenPomerajX
		mov al, 14;ogranicen razmak
		PronadjenPomerajX:

		mov ch, al;ch cuva pomeraj izmedju karata

		mov edx, [esp]; vraca koordinate kursora
		mov dl, bl; postavlja u dl prvu poziciju karte

			HorizontalLoop:

			push edx;cuva trenutne koordinate karte
			;mov al, BrojNacrtanihKarata
			movzx eax, BrojNacrtanihKarata
			mov ebx, esi
			ADD ebx, 3;ebx sada pokazuje na niz karata koje igrac ima u ruci
			INC al
			mov BrojNacrtanihKarata, al
			
			
			

			ADD ebx, eax
			XOR eax,eax
			mov al, [ebx]
			mov ebx, eax
			call DrawCard
			
			pop edx
			ADD dl, ch
			DEC cl
			cmp cl, 0
			jne HorizontalLoop

		pop edx
		pop ecx
		
		ADD dh, 4
		mov al, BrojRedovaCrtanjeKarta
		DEC al
		mov BrojRedovaCrtanjeKarta, al
		cmp al, 0
		jne VerticalLoop
	RET
NacrtajKarateIgraca ENDP

DrawCard PROC USES eax edx ebx ;eax temp, edx possisiton, bx indeks karte



    push edx
    push ebx
    AND ebx, 3; moduo od 4 lol

    cmp bl, 0
    je Diamond
    cmp bl, 1
    je RoundLeafThing
    cmp bl, 2
    je Heart
    ;ne treba poredjenje za poslednji jer je sigurno taj


    mov eax, black + (lightGray * 16)									 ;// Boja interfejsa i prozora. Upisuju se u al i ah registre, zato je zapis ovakav
    call SetTextColor      
    mov ebx, offset Card3 
    call DrawSprite
    jmp FinishDrawingCardFrame

    Diamond:
    mov eax, red + (lightGray * 16)									 ;// Boja interfejsa i prozora. Upisuju se u al i ah registre, zato je zapis ovakav
    call SetTextColor      
    mov ebx, offset Card0 
    call DrawSprite
    jmp FinishDrawingCardFrame

    RoundLeafThing:
    mov eax, black + (lightGray * 16)									 ;// Boja interfejsa i prozora. Upisuju se u al i ah registre, zato je zapis ovakav
    call SetTextColor      
    mov ebx, offset Card1 
    call DrawSprite
    jmp FinishDrawingCardFrame

    Heart:
    mov eax, red + (lightGray * 16)									 ;// Boja interfejsa i prozora. Upisuju se u al i ah registre, zato je zapis ovakav
    call SetTextColor      
    mov ebx, offset Card2 
    call DrawSprite

    FinishDrawingCardFrame:


    pop edx

    SHR edx, 2

    cmp edx, 9
    je CardNumber10


    mov ebx, offset CardLookUpTable
    ADD ebx, edx
    mov al, [ebx]
    pop edx
    INC dh
    INC dl
    call GotoXY
    call WriteChar

    ADD dh, 6
    ADD dl, 9
    call GotoXY
    call WriteChar
    jmp FinishDrawingCard

    CardNumber10:

    pop eax
    mov edx, eax
    INC dh
    INC dl
    call GotoXY
    mov edx, offset CardLookUPNumber10
    call writeString
    mov edx, eax
    ADD dh, 7
    ADD dl, 9
    call GotoXY
    mov edx, offset CardLookUPNumber10
    call writeString

    FinishDrawingCard:

RET

DrawCard ENDP

DrawSprite PROC USES eax edx ebx ;eax temp, edx are the coordinates where to draw the sprite, ebx is the address of the sprite



    mov ah, [ebx]
    INC ebx
    mov al, [ebx]
    INC ebx
    SpriteDrawLoop:
    call GotoXY
    push edx
    mov edx, ebx
    call WriteString
    movzx edx, ah
    ADD ebx, edx
    pop edx
    INC dh
    DEC al
    cmp al, 0
    jne SpriteDrawLoop

    RET
DrawSprite ENDP

END main