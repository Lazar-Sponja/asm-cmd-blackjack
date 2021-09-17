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

OdaberiKartu MACRO
	mov eax, 51
	call RandomRange
ENDM

BackgroundColor = Gray
CardBackground = Gray

.const
	;// Definisanje velicine prozora 
	xmin = 0	;// leva ivica
	xmax = 118	;// desna ivica
	ymin = 0	;// gornja ivica
	ymax = 32	;// donja ivica

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
    GameplayButtonBackground byte 116, 3,"                                                                                                                   ",0
                     		         byte"                                                                                                                   ",0
                         		     byte"                                                                                                                   ",0


	DealerInterface byte 116, 12,"   |                                                                                                ____________   ",0
                             byte"----                                                                                               '|          |   ",0
                             byte"                                                                                                  '||B       ! |   ",0
                             byte"                                                                                                  |||  L   J   |   ",0
                             byte"                                                                                                  |||    A     |   ",0
                             byte"                                                                                                  |||   C  C   |   ",0
                             byte"                                                                                                  ||| K      K |   ",0
                             byte"                                                                                                  |||__________|   ",0
                             byte"                                                                                                  |'__________'    ",0
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
	Card4 byte 13,8,"____________" ,0,"|          |", 0,"|B       ! |", 0,"|  L   J   |", 0,"|    A     |", 0,"|   C  C   |", 0,"| K      K |", 0,"____________",0

	Cardf0 byte 5,8,"  -|" ,0,"|` |", 0,"|' |", 0,"| ^|", 0,"| v|", 0,"|  |", 0,"|.'|", 0,"  -|",0
	Cardf1 byte 5,8,"  -|" ,0,"|` |", 0,"|' |", 0,"| *|", 0,"|*||", 0,"|  |", 0,"|.'|", 0,"  -|",0
	Cardf2 byte 5,8,"  -|" ,0,"|` |", 0,"|' |", 0,"| n|", 0,"| v|", 0,"|  |", 0,"|.'|", 0,"  -|",0
	Cardf3 byte 5,8,"  -|" ,0,"|` |", 0,"|' |", 0,"| ^|", 0,"|*||", 0,"|  |", 0,"|.'|", 0,"  -|",0
	Cardf4 byte 5,8,"|-  " ,0,"|;`|", 0,"||*|", 0,"| \|", 0,"|/;|", 0,"|;'|", 0,"| .|", 0,"|-  ",0


    HitButtonSprite byte 13,3, "------------",0,"|   H I T  |",0,"------------",0
    StandButtonSprite byte 17,3,"----------------",0, "|   S T A N D  |", 0,"----------------",0
    DoublDownButtonSprite byte 29,3,"----------------------------",0, "|   D O U B L E   D O W N  |", 0,"----------------------------",0

	BlackJackSprite byte 34,10,"     _--------_            /----|", 0
					byte	   "   /   _____   \          /     |", 0
					byte	   "  |__/      |   |        /--/|  |", 0
					byte	   "            /   /            |  |", 0
					byte	   "          /   /              |  |", 0
					byte	   "        /   /                |  |", 0
					byte	   "      /   /                  |  |", 0
					byte	   "    /   /                    |  |", 0
					byte	   "  /   /___________           |  |", 0
					byte	   " |                |          |__|", 0


	Igrac STRUCT
		cardCount BYTE 0
		pointCount BYTE 0
		winCount  BYTE 0 ;maybe change to like a higher order so more games can be played
		Flags BYTE 0
		cards BYTE 21 DUP(0)
	Igrac ENDS

	;Znacenja flags varijable
	;1 bit govori da li je igrac bustovao
	;2 bit govori da li je igrac double downovao 
	;3 bit govori da li igrac ima jedinicu u ruci
	;4 bit govori da li je igrac dobio black jack
	;5 bit ako je igrac pobedio rundu

	OkruzenjeIgraca STRUCT
		
		IgracUOkruzenju DWORD 0
		SpriteZaOkruzenje DWORD 0
		VelicinaProzora BYTE 0
		KolikoKarataUJednomRedu BYTE 0
		KoordinateProzora BYTE 0,0
		KoordinateCentraZaCrtanjeKarata BYTE 0,0

	OkruzenjeIgraca ENDS

	Dugme STRUCT
		SpriteZaDugme DWORD 0
		KoordinateSprajta BYTE 0,0
		KoordinateKursora BYTE 0,0
	Dugme ENDS


    SelectedButton byte 0

    AktivniIgrac byte 0

	KoordinatePraznogPolja byte 0,0
	KoordinateSpilaKarata byte 98,0
	
	windowRect SMALL_RECT <xmin, ymin, xmax, ymax>      ;// Velicina prozora
	winTitle byte "BlackJack", 0							;// Naslov programa
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
	DugmiciTokomIgre Dugme 3 dup(<?>)
	NajPoenaSkuplenihURundi byte ?

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


UpdatePlayFrame PROC USES eax esi;ne updatuje dugmice
	call DrawBackGround
	mov eax, 1 
	mov esi, offset Okruzenja
	
	UpdateCardsForPlayers:
    call NacrtajKarateIgraca
	INC al
	ADD esi, 14;velicina struct okruzenja
	cmp al, BrojIgraca
	jle UpdateCardsForPlayers

	mov eax, brown + (gray * 16)	
    call SetTextColor

	RET	
UpdatePlayFrame ENDP

DajAdresuFlipSprajta PROC;bl prima boju karte

	AND bl, 3;daje tip karte
	cmp bl, 0
	je DiamondFlip
	cmp bl, 1
	je ClovesFliped
	cmp bl, 2
	je HeartFliped

	mov eax, black + (CardBackground * 16)	
    call SetTextColor
	mov ebx, offset Cardf3
	RET


	DiamondFlip:
	mov eax, red + (CardBackground * 16)	
    call SetTextColor
	mov ebx,offset Cardf0
	RET

	ClovesFliped:
	mov eax, black + (CardBackground * 16)	
    call SetTextColor
	mov ebx, offset Cardf1
	RET

	HeartFliped:
	mov eax, red + (CardBackground * 16)	
    call SetTextColor
	mov ebx, offset Cardf2
	RET

DajAdresuFlipSprajta ENDP

PustiAnimacijuKarte PROC USES eax ebx edx ecx;al govori indeks karte, ah govori o tipu animacije
	call UpdatePlayFrame;ovim se pronalazi prazno polje gde karta treba da ide

	push eax 
	mov eax, brown + (gray * 16)	
    call SetTextColor
	pop eax

	cmp ah, 4
	je CetvrtiTipAnimacije

	

	mov dx, [offset KoordinateSpilaKarata]
	mov cx, [offset KoordinatePraznogPolja]
	SUB cl, dl
	SUB ch, dh;dobija se pomeraj od spila do praznog polja
	SAR cl,2;deli sa 4
	SAR ch,2;deli sa 4

	
	cmp ah, 1
	je PrviTipAnimacije

	cmp ah, 2
	je DrugiTipAnimacije


	cmp ah, 3
	je TreciTipAnimacije
	
	PrviTipAnimacije:;karta se okrece dok ide
	ADD dl, cl
	ADD dh, ch
	mov ebx, offset Cardf4
	call DrawSprite
	mov bl, al
	push eax
	mov eax, 300
	call delay
	

	call UpdatePlayFrame
	ADD dl, cl
	ADD dh, ch
	call DajAdresuFlipSprajta
	call DrawSprite
	call delay

	pop eax 
	call UpdatePlayFrame
	ADD dl, cl
	ADD dh, ch
	mov bl, al
	call DrawCard
	mov eax, 300
	call delay
	jmp KrajAnimacije


	DrugiTipAnimacije:;karta se prvo okrene pa ide
	mov ebx, offset Cardf4
	call DrawSprite
	mov bl, al
	push eax
	mov eax, 300
	call delay 
	

	call UpdatePlayFrame
	call DajAdresuFlipSprajta
	call DrawSprite
	call delay 

	pop eax
	mov bl, al
	call DrawCard
	mov eax, 500
	call delay

	call UpdatePlayFrame
	ADD dl, cl
	ADD dh, ch
	call DrawCard
	mov eax, 300
	call delay

	call UpdatePlayFrame
	ADD dl, cl
	ADD dh, ch
	call DrawCard
	call delay

	call UpdatePlayFrame
	ADD dl, cl
	ADD dh, ch
	call DrawCard
	call delay
	jmp KrajAnimacije

	TreciTipAnimacije:;karta se ne okrece dok ide
	ADD dl, cl
	ADD dh, ch
	mov ebx, offset Card4
	call DrawSprite
	mov eax, 300
	call delay 

	call UpdatePlayFrame
	ADD dl, cl
	ADD dh, ch
	call DrawSprite
	call delay 

	call UpdatePlayFrame
	ADD dl, cl
	ADD dh, ch
	call DrawSprite
	call delay 
	jmp KrajAnimacije

	CetvrtiTipAnimacije:;karta se okrece na mestu
	mov dx, [offset KoordinatePraznogPolja]
	mov ebx, offset Cardf4
	call DrawSprite
	mov bl, al
	mov eax, 300
	call delay 

	call DajAdresuFlipSprajta
	call DrawSprite
	call delay


	KrajAnimacije:
	RET	
PustiAnimacijuKarte ENDP

DodajKartuIgracu PROC USES eax esi ebx;ebx govori o igracu, al govori indeks karte, ah govori o tipu animacije koja se pusta kada se karta dodeljuje igracu

	push eax
	mov eax, 25;velicina igrac struct
	DEC bl
	MUL bl
	mov esi, offset Igraci
	movzx ebx, al
	ADD esi, ebx;AdresaIgraca
	pop eax

	movzx ebx, byte ptr[esi];koliko karata igrac ima u ruci
	push esi



	ADD esi, ebx

	cmp bl, 0
	je SkipCheckingIfFlippedCard

	cmp byte ptr[esi + 3], 52;proverava da li je poslednja karta u ruci flipovana
	je ReadyToAddCard;ako karta nije flipovana ne treba prepisati preko nje

	SkipCheckingIfFlippedCard:
	INC bl
	pop esi
	mov byte ptr [esi],bl;povecava broj karata u ruci igraca
	push esi
	ADD esi, ebx
	ReadyToAddCard:
	


	mov byte ptr[esi + 3], 53;postavlja praznu kartu na polje

	call PustiAnimacijuKarte

	mov byte ptr[esi + 3], al;postavlja kartu na polje
	call UpdatePlayFrame

	pop esi

	cmp al, 52;ako je dodeljena naopacke karta, onda se nista ne proracunava
	je EndOfDodajKartu

	SHR al,2;dobija vrednost karte od 0 do 12
	INC al;od 1 do 13
	cmp al, 10;posto karte sa vrednoscu preko 10 imaju vrednost deset
	jl ClampovanjeVrednosti
	mov al, 10
	ClampovanjeVrednosti:

	mov ah, [esi + 1];ukupan broj poena
	ADD ah, al
	mov [esi + 1], ah;zapisuje koliko poena ima igrac sada
	mov bl, [esi + 3];flags

	cmp al, 1
	jne SkipSettingOneFlag
	OR bl, 4;sets the one flag
	mov byte ptr [esi + 3], bl;saves the value
	SkipSettingOneFlag:


	
	EndOfDodajKartu:

	RET
DodajKartuIgracu ENDP

DrawGamePlayNubbins PROC USES eax ebx edx esi

	mov dl, 0
	mov dh, 28
	mov ebx, offset GameplayButtonBackground
	call DrawSprite ;crta pozadinu iza dugmica

	mov esi, offset DugmiciTokomIgre
	mov al, 1
	DrawGameplayButtonsLoop:
		mov dl, al
		mov eax, brown + (Gray * 16);boja obicnog dugmeta
		call SetTextColor 

		cmp dl, SelectedButton
		jne SelectedButtonColorGameplay;boja selektovanog dugmeta
		mov eax, yellow + (Gray * 16)									 
		call SetTextColor

		SelectedButtonColorGameplay:
		mov al, dl;dl je sluzio kao privremeni brojac
		mov ebx, [esi]
		mov dl, byte ptr [esi + 4]
		mov dh, byte ptr [esi + 5]
		call DrawSprite

		cmp al, SelectedButton
		jne DontDrawSelectedChar
		push eax
		mov dl, [esi + 6]
		mov dh, [esi + 7]
		mov al, 62;ascii za '>'
		call GotoXY
		call WriteChar
		pop eax
		DontDrawSelectedChar:
		ADD esi, 8;duzina Dugme struct
		INC al
		cmp al, 4
		jne DrawGameplayButtonsLoop

	RET
DrawGamePlayNubbins ENDP

DrawBackGround PROC USES eax ebx edx ecx esi
	mov eax, 1;brojac igraca
	mov esi, offset Okruzenja

	DrawPlayerInterfaces: 

		cmp al, AktivniIgrac
		je PreskociCrtanjeZaSada;aktivni igrac treba poslednji da se crta
		
		push eax

		mov eax, brown + (Gray * 16);Boja interfejsa i prozora. Upisuju se u al i ah registre, zato je zapis ovakav
 	    call SetTextColor  

		mov ecx, [esi];adresa igraca
		mov bl, byte ptr [ecx + 3];flags varijabla
		push ebx;cuva flags varijable
		AND bl, 1
		cmp bl, 0
		je SkipDrawingBustedFrame
			mov eax, brown + (black * 16)
			call SetTextColor  
		SkipDrawingBustedFrame:

		mov ebx, [esi + 4];adresa sprajta
		mov dx, [esi + 10];koordinate sprajta
		call DrawSprite

		mov ebx, [esp];vraca ebx vrednost sa stakca u kome su flags variable
		AND bl, 16;ovaj bit cuva da li je igrac pobedio
		cmp bl, 0
		je SkipDrawingVictoryFrame
			mov eax, yellow + (Gray * 16)
			call SetTextColor  
		SkipDrawingVictoryFrame:
		
		pop ebx
		AND bl, 8;ovaj bit cuva da li je igrac dobio black jack
		cmp bl, 0
		je SkipDrawingBlackJackSprite
			push edx
			mov eax, [esi + 4];prve dve koordinate sprajta su velicina prozora x,y
			mov dx, Word ptr[eax]
			SHR dl, 1;deli dimenzije sa dva 
			SHR dh, 1
			mov eax, [esi + 10];koordinate prozora
			ADD dl, al;postavlja koordinate na centar prozora
			ADD dh, ah
			SUB dl, 17;polovina black jack sprajta
			SUB dh, 5
			mov ebx, offset BlackJackSprite
			call DrawSprite
			pop edx
		SkipDrawingBlackJackSprite:

		cmp byte ptr[esp], 1;vrh stacka pokazuje do kog igraca je stiglo 
		je SkipShiftingCursor;prvom igracu, to jest, dealeru, ne treba pomerati kursor za crtanje poena na ekran
		INC dl;koordinate za crtanje poena
		INC dh
		SkipShiftingCursor:
		call GotoXY

		movzx eax, byte ptr [ecx + 2];poeni igraca
		call WriteDec
	

		pop eax
		PreskociCrtanjeZaSada:
		
		INC eax
		ADD esi, 14;velicina strukture
		cmp al, BrojIgraca
		jle DrawPlayerInterfaces

	movzx eax, AktivniIgrac;crtanje aktivnog igraca na kraju kako bi taj interface bio preko svih ostalih
	cmp eax, 0
	je EndOFDrawingBackground

	push eax
	mov eax, yellow + (Gray * 16)	
	call SetTextColor
	pop eax

	DEC eax
	mov cl, 14;velicina okruzenja
	MUL cl
	mov esi, offset Okruzenja
	ADD esi, eax;skace na adresu aktivnog korisnika
	mov ebx, [esi + 4]
	mov dx, [esi + 10]


	call DrawSprite
	cmp eax, 0;ovo je pozicija dealera
	je SkipShiftingCursorActive;prvom igracu, to jest, dealeru, ne treba pomerati kursor za crtanje poena na ekran
	INC dl;koordinate za crtanje poena
	INC dh

	SkipShiftingCursorActive:

	call GotoXY
	mov ecx, [esi];adresa igraca
	movzx eax, byte ptr [ecx + 2]
	call WriteDec


	EndOFDrawingBackground:

	RET
DrawBackGround ENDP

NacrtajKarateIgraca PROC USES eax ecx edx ebx esi;eax, ebx, ecx, edx su temp za racunanje, esi sadrzi adresu radnog ogruzenja u kome crta karte

	mov ebx, [esi];pointer na igraca
	ADD esi, 8
	mov cx, [esi];granice prozora i koliko karata moze da ima prozor u jednom redu
	ADD esi,4 
	movzx eax, byte ptr [ebx]

	cmp eax, 0
	je KrajCrtanjaKarataIgraca

	XOR edx,edx

	DIV cl ;koliko ce biti redova
	cmp ah, 0
	je ZaokruzivanjeNaGoreSkip
	INC al

	ZaokruzivanjeNaGoreSkip:
	mov dx, [esi];gde treba da crta karte

	mov esi, ebx; esi je sada pointer na igraca
	
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
	KrajCrtanjaKarataIgraca:
	RET
NacrtajKarateIgraca ENDP

DrawCard PROC USES eax edx ebx ;eax temp, edx possisiton, bl indeks karte


	cmp bl, 53;ne crta nista, ovo je korisno tokom animacije
	jne NormalnaKarta1
	mov [offset KoordinatePraznogPolja], dx;cuva koordinate praznog polja kako bi animacija znala gde da salje kartu

	RET

	NormalnaKarta1:
	cmp bl, 52;indeks facedown karte
	jne NormalnaKarta2
	mov eax, brown + (gray * 16)
    call SetTextColor     
	mov ebx, offset Card4;adresa sprajta za facedown kartu
	call DrawSprite
	RET

	NormalnaKarta2:
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


    mov eax, black + (CardBackground * 16)
    call SetTextColor      
    mov ebx, offset Card3 
    call DrawSprite
    jmp FinishDrawingCardFrame

    Diamond:
    mov eax, red + (CardBackground * 16)
    call SetTextColor      
    mov ebx, offset Card0 
    call DrawSprite
    jmp FinishDrawingCardFrame

    RoundLeafThing:
    mov eax, black + (CardBackground * 16)
    call SetTextColor      
    mov ebx, offset Card1 
    call DrawSprite
    jmp FinishDrawingCardFrame

    Heart:
    mov eax, red + (CardBackground * 16)
    call SetTextColor      
    mov ebx, offset Card2 
    call DrawSprite

    FinishDrawingCardFrame:


    pop edx

	AND edx, 255
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
    RET

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


main PROC

	invoke GetStdHandle, STD_OUTPUT_HANDLE							 ;// Postavlja handle za ispis podataka
    mov  stdOutHandle, eax

    invoke GetConsoleCursorInfo, stdOutHandle, addr cursorInfo       ;// Cita trenutno stanje kursora
    mov  cursorInfo.bVisible, 0										 ;// Postavlja vidljivost kursora na nevidljiv
    invoke SetConsoleCursorInfo, stdOutHandle, addr cursorInfo       ;// Postavlja novo stanje kursora

	invoke SetConsoleTitle, addr winTitle							 ;// Postavlja title prozora
    invoke SetConsoleWindowInfo, stdOutHandle, TRUE, addr windowRect ;// Dimenzije prozora

	mov BrojIgraca, 4
	mov AktivniIgrac, 2

	invoke getStdHandle, STD_INPUT_HANDLE
	mov stdInHandle, eax
	mov ecx, 10
	;// Cita dva dogadjaja iz bafera
	;invoke ReadConsoleInput, stdInHandle, addr temp, 1, addr bRead
	;invoke ReadConsoleInput, stdInHandle, addr temp, 1, addr bRead

    call Randomize

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

	mov byte ptr [edx], 0;broj karata
	INC edx
	mov byte ptr [edx], 0;broj peona
	INC edx
	mov byte ptr [edx], 0;broj pobeda
	INC edx
	mov byte ptr [edx], 0;flags
    

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

	mov byte ptr [edx], 0;broj karata
	INC edx
	mov byte ptr [edx], 0;broj peona
	INC edx
	mov byte ptr [edx], 0;broj pobeda
	INC edx
	mov byte ptr [edx], 0;flags

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

	mov byte ptr [edx], 0;broj karata
	INC edx
	mov byte ptr [edx], 0;broj peona
	INC edx
	mov byte ptr [edx], 0;broj pobeda
	INC edx
	mov byte ptr [edx], 0;flags

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

	mov byte ptr [edx], 0;broj karata
	INC edx
	mov byte ptr [edx], 0;broj peona
	INC edx
	mov byte ptr [edx], 0;broj pobeda
	INC edx
	mov byte ptr [edx], 0;flags

	mov esi, offset DugmiciTokomIgre
	mov[esi], offset HitButtonSprite
	ADD esi, 4
	mov byte ptr [esi], 2
	INC esi
	mov byte ptr [esi], 28
	INC esi
	mov byte ptr [esi], 4
	INC esi
	mov byte ptr [esi], 29
	INC esi

	mov[esi], offset StandButtonSprite
	ADD esi, 4
	mov byte ptr [esi], 16
	INC esi
	mov byte ptr [esi], 28
	INC esi
	mov byte ptr [esi], 18
	INC esi
	mov byte ptr [esi], 29
	INC esi

	mov[esi], offset DoublDownButtonSprite
	ADD esi, 4
	mov byte ptr [esi], 34
	INC esi
	mov byte ptr [esi], 28
	INC esi
	mov byte ptr [esi], 36
	INC esi
	mov byte ptr [esi], 29



	GameLoop:;prvo se svim igracima dodeljuju pocetne karte pre nego sto igra pocne
		mov SelectedButton, 0
		mov AktivniIgrac, 0;nijedan igrac nije aktivan na pocetku
		call UpdatePlayFrame
		call DrawGamePlayNubbins

		mov eax, 500
		call delay
		mov NajPoenaSkuplenihURundi, 0

		OdaberiKartu;stavlja u al indeks karte
		mov ah, 1;brza dodela karte
		mov ebx, 1;igrac kome se daje karta

		call DodajKartuIgracu

		mov al, 52;naopacke okrenuta karta
		mov ah, 3;tip animacije bez flipovanja karte

		call DodajKartuIgracu
		
		mov esi, offset Igraci
		
		DodajKarteIgracima:
			INC ebx
			ADD esi, 25;velicina igrac struct
			OdaberiKartu
			mov ah, 1
			call DodajKartuIgracu

			OdaberiKartu
			mov ah, 1
			call DodajKartuIgracu


			mov ah, [esi + 1];poeni u ovoj rundi

			cmp ah, 11
			jne DodeliKarteSledecem
			mov al, [esi + 3];flags
			AND al, 4;da li ima jedinicu u ruci
			cmp al, 0
			je DodeliKarteSledecem

			mov al, [esi + 3]
			OR al, 8
			mov [esi + 3], al;cuva da je igrac dobio natural blackjack
			DodeliKarteSledecem:
		
		cmp bl, BrojIgraca;prolazi kroz sve igrace i dodaje im karte
		jl DodajKarteIgracima

		mov AktivniIgrac, 1
		mov SelectedButton, 1

		mov esi, offset Igraci
		jmp PromeniIgraca;ovako se inicijalizuju neophodne stvari za prvog pravog igraca kao i svakog narednog
		
		PlayLoop:;sada igraci mogu da 


			invoke ReadConsoleInput, stdInHandle, addr temp,1,addr bRead
			mov bx, word ptr temp
			cmp bx, 1;proverava da li event dolazi sa tastature
			jne PlayLoop

			mov bl, byte ptr [temp + 4]
			cmp bl, 0
			je PlayLoop;nema razloga reagovati na event odpustanja dugmeta
				mov bl, byte PTR [temp + 10]

				cmp bl, LEFT_KEY
				je DecrementSelectedButton

				cmp bl, RIGHT_KEY
				je IncrementSelectedButton

				cmp bl, UP_KEY
				je HandleGameplayButton

		jmp PlayLoop

		DecrementSelectedButton:
		mov bl, SelectedButton
		cmp bl, 1
		je SetGameplayButtonTop
		DEC bl
		mov SelectedButton, bl
		call DrawGamePlayNubbins
		jmp PlayLoop
		SetGameplayButtonTop:
		mov SelectedButton, 3
		call DrawGamePlayNubbins
		jmp PlayLoop

		IncrementSelectedButton:
		mov bl, SelectedButton
		cmp bl, 3
		je SetGameplayButtonBottom
		INC bl
		mov SelectedButton, bl
		call DrawGamePlayNubbins
		jmp PlayLoop
		SetGameplayButtonBottom:
		mov SelectedButton, 1
		call DrawGamePlayNubbins
		jmp PlayLoop

		HandleGameplayButton:
		mov bl, SelectedButton
		cmp bl, 1
		je HandleHitButton
		cmp bl, 2
		je HandleStandButton
		jmp HandleDoubleDownButton

		HandleHitButton:

			movzx ebx, AktivniIgrac
			OdaberiKartu
			mov ah, 2;sporiji tip animacije

			call DodajKartuIgracu;dodaje kartu aktivnom igracu

			mov al, byte ptr[esi + 1];ucitava broj poena

			cmp al, 21
			je IgracJeDobioBlackJack
			cmp al, 21
			jg IgracJeBustovao

			mov ah, byte ptr[esi + 3];ucitava flags varijablu
			AND ah, 4; treci bit cuva da li igrac ima jedinicu u ruci
			cmp ah, 0;     ako nema
			je PlayLoop;moze da igra ponovo jer nije bustovao niti dobio blackjack

			cmp al, 11;ako igrac ima jedinicu u ruci ta jedinica moze da se racuna kao 21 i ako ima 11 poena onda ima blackjack
			jne PlayLoop;ako nema blackjack moze da igra ponovo

			mov byte ptr[esi + 1], 21;postavlja 21 na broj poena pre nego sto menja igraca
			jmp IgracJeDobioBlackJack

		HandleStandButton:

			mov al, byte ptr[esi + 1];ucitava broj poena

			cmp al, 11
			jg PromeniIgraca;ako ima vise od 11 onda iako ima 1 nece biti od koristi da se racuna kao 11

			mov ah, byte ptr[esi + 3];ucitava flags varijablu
			AND ah, 4; treci bit cuva da li igrac ima jedinicu u ruci
			cmp ah, 0;          ako nema
			je PromeniIgraca;moze samo da se promeni igrac

			ADD al, 10
			mov byte ptr[esi + 1], al;upisuje broj poena sa 1 racunatom kao 11
			jmp PromeniIgraca

		HandleDoubleDownButton:

			movzx ebx, AktivniIgrac
			OdaberiKartu
			mov ah, 2;sporiji tip animacije

			call DodajKartuIgracu;dodaje kartu aktivnom igracu

			mov al, byte ptr[esi + 1];ucitava broj poena
			mov ah, byte ptr[esi + 3];ucitava flags varijablu
			OR ah, 2;podesava flag za double down
			mov byte ptr[esi + 3], ah;sacuva flag


			cmp al, 21
			je IgracJeDobioBlackJack
			cmp al, 21
			jg IgracJeBustovao
			
			cmp al, 11
			jg PromeniIgraca;ako ima vise od 11 onda iako ima 1 nece biti od koristi da se racuna kao 11

			AND ah, 4; treci bit cuva da li igrac ima jedinicu u ruci
			cmp ah, 0;          ako nema
			je PromeniIgraca;moze samo da se promeni igrac

			ADD al, 10
			mov byte ptr[esi + 1], al;upisuje broj poena sa 1 racunatom kao 11
			cmp al, 21
			je IgracJeDobioBlackJack
			jmp PromeniIgraca

		IgracJeBustovao:
			mov ah, byte ptr[esi + 3];ucitava flags varijablu
			OR ah, 1;namesta bust flag
			mov byte ptr[esi + 3], ah;cuva flags varijablu
			mov byte ptr[esi + 1], 0
		jmp PromeniIgraca

		IgracJeDobioBlackJack:
			mov ah, byte ptr[esi + 3];ucitava flags varijablu
			OR ah, 8;namesta bust flag
			mov byte ptr[esi + 3], ah;cuva flags varijablu
		jmp PromeniIgraca

		PromeniIgraca:
			mov cl, NajPoenaSkuplenihURundi
			cmp cl, byte ptr[esi + 1];proverava da li je ovaj igrac imao najvise poena
			jg PreskociPromenuPoena
			mov cl, byte ptr[esi + 1]
			mov NajPoenaSkuplenihURundi, cl
			PreskociPromenuPoena:


			mov al, AktivniIgrac
			INC al
			cmp al, BrojIgraca
			jg DealerovPotez

			mov SelectedButton, 1
			mov AktivniIgrac, al

			call UpdatePlayFrame
			call DrawGamePlayNubbins
			ADD esi, 25; velicina igrac struct

			mov al, byte ptr[esi + 3];flags
			AND al, 8;natural blackjack
			cmp al, 0 
			je PlayLoop

			mov byte ptr[esi + 1], 22

		jmp PromeniIgraca

		DealerovPotez:
			mov AktivniIgrac, 1
			mov SelectedButton, 0
			call UpdatePlayFrame
			call DrawGamePlayNubbins

			mov ebx, 1
			OdaberiKartu
			mov ah, 4;flipuje obrnutu kartu

			call DodajKartuIgracu

			mov esi, offset Igraci;dealer je uvek prvi igrac
			mov al, byte ptr[esi + 1];ucitava broj poena
			mov ah, byte ptr[esi + 3]

			AND ah, 4
			cmp ah, 0
			je DealerPlayLoop
			
			cmp al, 11
			jne DealerPlayLoop

			mov byte ptr[esi + 1], 22
			mov ah, byte ptr[esi + 3]
			OR ah, 8
			mov byte ptr[esi + 3], ah
		jmp ZavrsiRundu

		DealerPlayLoop:

			cmp al, NajPoenaSkuplenihURundi
			jg ZavrsiRundu

			cmp al, 21;ako je dobio black jack a neko ima isto toliko poena, svakako ne moze da pobedi
			je DealerDobioBlackJack

			mov ebx, 1
			OdaberiKartu
			mov ah, 2

			call DodajKartuIgracu

			mov al, byte ptr[esi + 1];ucitava broj poena


			cmp al, 21
			jg DealerBusted

			mov ah, byte ptr[esi + 3]
			AND ah, 4
			cmp ah, 0
			je DealerPlayLoop

			cmp al, 11
			jg DealerPlayLoop

			ADD al, 10
			jmp DealerPlayLoop

		DealerBusted:
			mov al, 0
			mov ah, byte ptr[esi + 3]
			OR ah, 1
			mov byte ptr[esi + 3], ah
		jmp ZavrsiRundu

		
		DealerDobioBlackJack:
			mov ah, byte ptr[esi + 3];ucitava flags varijablu
			OR ah, 8;namesta bust flag
			mov byte ptr[esi + 3], ah;cuva flags varijablu
		jmp ZavrsiRundu

		ZavrsiRundu:

		;mov byte ptr [esi + 1], al; zapisuje dealerove poene
		mov bl, 2;brojac za prvog igraca
		mov ah, NajPoenaSkuplenihURundi
		cmp al, ah
		jle DodajPoeneIgracima

		mov ah, byte ptr[esi + 3]
		OR ah, 16;bit za pobedu
		mov byte ptr[esi + 3], ah
		mov ah, byte ptr[esi + 2]
		INC ah
		mov byte ptr[esi + 2], ah;povecava broj pobeda

		DodajPoeneIgracima:
			
			ADD esi, 25;velicina igraci struct

			mov al, byte ptr [esi + 1];broj poena
			cmp al, ah
			jne IgracNijePobedio

			mov al, byte ptr [esi + 2];koliko pobeda ima igrac
			mov cl, byte ptr [esi + 3];flags
			mov ch, cl
			AND cl, 2;da li je igrac double downovao
			cmp cl, 0;ako nije double downovao
			je NijeDoubleDownovao;povecaj broj poena jedanput
			INC al
			NijeDoubleDownovao:
			INC al
			mov byte ptr [esi + 2], al;upisuje broj pobeda

			OR ch, 16;zapisuje da je igrac pobedio
			mov byte ptr [esi + 3], ch

			IgracNijePobedio:

			INC bl;brojac igraca
			cmp bl, BrojIgraca
		jle DodajPoeneIgracima;ako ima jos igraca

		mov AktivniIgrac, 0
		call UpdatePlayFrame
		mov eax, 3000
		call delay

		mov bl, BrojIgraca
		mov esi, offset Igraci
		OcistiVarijableZaNovuRundu:

			mov byte ptr[esi], 0;broj karata u ruci
			mov byte ptr[esi + 1], 0;broj poena 
			mov byte ptr[esi + 3], 0;flags

			ADD esi, 25
			DEC bl
			cmp bl, 0
		jne OcistiVarijableZaNovuRundu

		jmp GameLoop

    exit
    


main ENDP
END main
