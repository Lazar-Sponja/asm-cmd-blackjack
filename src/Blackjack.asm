;TITLE ASM Command Line Blackjack  (Blackjack.asm)

include Irvine32.inc
include macros.inc

OdaberiKartu MACRO
	mov eax, 51
	call RandomRange
ENDM

BackgroundColor = Gray
CardBackground = Gray

.const
	;Definisanje velicine prozora 
	xmin = 0	;leva ivica
	xmax = 115	;desna ivica
	ymin = 0	;gornja ivica
	ymax = 31	;donja ivica

	LEFT_KEY = 025h        
	UP_KEY = 026h
	RIGHT_KEY = 027h
	DOWN_KEY = 028h
	ESC_KEY = 01Bh
	ENTER_KEY = 0DH
.data
  
TitleScreenSprite byte 116,29,"	            ______   __                 __           _____              __                                        ",0         
                  byte        "                   |_   _ \ [  |               [  |  _      |_   _|            [  |  _             ______          ",0     
                  byte        "            ______   | |_) | | |  ,--.   .---.  | | / ]       | | ,--.   .---.  | | / ]           /  __  \         ",0           
                  byte        "      _____/  __  \  |  __'. | | `'_\ : / /'`\] | '' <    _   | |`'_\ : / /'`\] | '' <     ______|  |__|  ______   ",0         
                  byte        "     /  __  \ __|   _| |__) || | // | |,| \__.  | |`\ \  | |__' |// | |,| \__.  | |`\ \   /  __  \ _____ /  __  \  ",0           
                  byte        "    |  |__|  |____/|_______/[___]\'-;__/'.___.'[__|  \_] `.____.'\'-;__/'.___.'[__|  \_] |  |__|  | ____|  |__|  | ",0          
                  byte        "    |\______/|____/                                                                      |\______/| ____|\______/| ",0             
                  byte        "    |\______/|                                                                           |\______/|     |\______/| ",0         
                  byte        "    |\______/|                                                          ______           |\___  ______  |\______/| ",0        
                  byte        "     \ ____ /                                                          /  __  \           \ __ /  __  \  \ ____ /  ",0          
                  byte        "                                                                      |  |__|  |              |  |__|  |           ",0         
                  byte        "                                                                      |\______/|              |\______/|           ",0        
                  byte        "                                                                      |\______/|               \______/            ",0       
                  byte        "                                                                      |\______/|                                   ",0
                  byte        "------                                                                 \ ____ /                              ------",0
                  byte        "      ----------------                                                                       ----------------      ",0
                  byte        "                      -----------------------------------------------------------------------                      ",0
                  byte        "                     .                                                                       .                     ",0
                  byte        "                    .                                                                         .                    ",0
                  byte        "                   .                                                                           .                   ",0
                  byte        "                  .                                                                             .                  ",0
                  byte        "                 .                                                                               .                 ",0
                  byte        "                .                                                                                 .                ",0
                  byte        "               .                                ---------------                                    .               ",0
                  byte        "              .                                 |   S T A R T |                                     .              ",0
                  byte        "             .                                  ---------------                                      .             ",0
                  byte        "            .                                                                                         .            ",0
                  byte        "           .                                                                                           .           ",0
                  byte        "          .                                                                                             .          ",0


DealerVictorySprite byte 101,26,  "                                           ____                                                     ", 0
                    byte          "                                   /---\..'     `-_                                                 ", 0
                    byte          "                                 /      .|`         \__                                             ", 0
                    byte          "                                /         |/            \                                           ", 0
                    byte          "              _____________   '          v    _    '    \                                           ", 0
                    byte          "              |           |  /      /^ \      /  \   \   \                                          ", 0
                    byte          "              |           | |       |_ _  _   _'''\    \  \                                         ", 0
                    byte          "              |           |  \      : :; ; \ : ;: ;-____/ |                                         ", 0
                    byte          "              |           |   /     | ` `` `  ```___- \_ _|                                         ", 0
                    byte          "             /|  /\       |  <     /-__---\   /`_----/ |/ \                                         ", 0
                    byte          "            /.//-'/       |   \ /\ --`__`` \ |  ````' /|  |                                         ", 0
                    byte          "          /  /   /        |     | \'\---`` ' '  `````|/| />                                         ", 0
                    byte          "         /  /   /.-''^-   |__    \_\\   .   \_/  _/^\|/|\  >                                        ", 0
                    byte          "         | \   \|```_`'--\|   `- <  \\ / \>__  __\_  |_|\ /                                         ", 0
                    byte          "         \  \   |  |` ._;_| .. -``-.'\ \|  |------  .| |/  \ \_                                     ", 0
                    byte          "          \  |  |  |  |.            \|\\ \`v ``  ` ///   /  \ \                                     ", 0
                    byte          "         __\ |  |   .               /\  \ `  <     /   /    /    \---\_                             ", 0
                    byte          "       /``    ---\_/\_\____________/  \'   \____ /   _/    /            \__                         ", 0
                    byte          "    /`       |           /            |  `-.__  __-'      /                 \_                      ", 0
                    byte          "   /         /           \             |.   / \ / \       /                    \______              ", 0
                    byte          " /          |            ||           _; \ /   V   \     /|                         ___----_        ", 0
                    byte          "|           |           / |.^--..  .--`   \         \  /  |                   _--```         `_     ", 0
                    byte          ":           |          /                   >         V    |               _-``                 `-_  ", 0
                    byte          "|           \         /                    |              |            _-`                       `\ ", 0
                    byte          "|            \        <                    |             /            /                            \", 0
                    byte          "|             \         \                  |           /             /                             |", 0


PobedioJeSprite byte 76, 6," _______         __                     __   _                _            ",0
                byte       "|_   __ \       [  |                   |  ] (_)              (_)        _  ",0
                byte       "  | |__) | .--.  | |.--.   .---.   .--.| |  __   .--.        __  .---. (_) ",0
                byte       "  |  ___// .'`\ \| '/'`\ \/ /__\\/ /'`\' | [  |/ .'`\ \     [  |/ /__\\ _  ",0
                byte       " _| |_   | \__. ||  \__/ || \__.,| \__/  |  | || \__. |   _  | || \__.,(_) ",0
                byte       "|_____|   '.__.'[__;.__.'  '.__.' '.__.;__][___]'.__.'   [ \_| | '.__.'    ",0



DealerTextSprite byte 66,6," ______   ________       _       _____     ________  _______     ",0
                 byte      "|_   _ `.|_   __  |     / \     |_   _|   |_   __  ||_   __ \    ",0
                 byte      "  | | `. \ | |_ \_|    / _ \      | |       | |_ \_|  | |__) |   ",0
                 byte      "  | |  | | |  _| _    / ___ \     | |   _   |  _| _   |  __ /    ",0
                 byte      " _| |_.' /_| |__/ | _/ /   \ \_  _| |__/ | _| |__/ | _| |  \ \_  ",0
                 byte      "|______.'|________||____| |____||________||________||____| |___| ",0


Igrac1Sprite byte 29,4, " ___ ___ ___    _   ___   _ ",0
             byte       "|_ _/ __| _ \  /_\ / __| / |",0
             byte       " | | (_ |   / / _ \ (__  | |",0
             byte       "|___\___|_|_\/_/ \_\___| |_|",0

Igrac2Sprite byte 31,4, " ___ ___ ___    _   ___   ___ ",0
             byte       "|_ _/ __| _ \  /_\ / __| |_  )",0
             byte       " | | (_ |   / / _ \ (__   / / ",0
             byte       "|___\___|_|_\/_/ \_\___| /___|",0

Igrac3Sprite byte 31,4, " ___ ___ ___    _   ___   ____",0
             byte       "|_ _/ __| _ \  /_\ / __| |__ /",0
             byte       " | | (_ |   / / _ \ (__   |_ \",0
             byte       "|___\___|_|_\/_/ \_\___| |___/",0

                             


IgracSprite byte 64,21, "                        _____             _________________    ",0
            byte        "                       /      -------_____|               |    ",0
            byte        "                      |                   |               |    ",0
            byte        "                      |                   |               |    ",0
            byte        "                      |                   |       /- \    |\   ",0
            byte        "                      |                   |   /- \    |   ||   ",0
            byte        "              _  __ /                     |   |   |   |   ||-__",0
            byte        "            /\__\-__                      |   |   |   |   |__--",0
            byte        "           /  /  __\___            _______|   |      |    |    ",0
            byte        "    __-_-_/  / /  /   |  --------         |   |  |   |    |    ",0
            byte        "  /  /  |  \` /  /     \                  |- |   |   |    |    ",0
            byte        "_ |  |  |  |    /      /         `- __ -  |__|   |   |____|    ",0
            byte        "\ \ _________+/       |                     /   /   |/--\  __  ",0
            byte        "  -           -       |                    |-  | - |  -   `  `.",0
            byte        ".              \      |                    |                  |",0
            byte        "`             |        |                   \                  |",0
            byte        "             |          |                    |               ` ",0
            byte        "            `            |                  / \_           _/  ",0
            byte        "           |              |`                \   -- ______-- \  ",0
            byte        "          |               \                 \              /   ",0
            byte        "         /                 ``---            |              \   ",0

	PraznaMesta byte "                                                                                                                   ",0


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

								 
	OnePlayerInterface byte 116, 17,  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",0
								 byte"|   |                                                                                                             |",0
							   	 byte"|----                                                                                                             |",0
							  	 byte"|                                                                                                                 |",0
							 	 byte"|                                                                                                                 |",0
								 byte"|                                                                                                                 |",0
								 byte"|                                                                                                                 |",0
								 byte"|                                                                                                                 |",0
								 byte"|                                                                                                                 |",0
								 byte"|                                                                                                                 |",0
							  	 byte"|                                                                                                                 |",0
							 	 byte"|                                                                                                                 |",0
							 	 byte"|                                                                                                                 |",0
							 	 byte"|                                                                                                                 |",0
                          		 byte"|                                                                                                                 |",0
                           		 byte"|                                                                                                                 |",0
                            	 byte"...................................................................................................................",0


	TwoPlayerInterface byte 59, 17,  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",0
								 byte"|   |                                                    |",0
							   	 byte"|----                                                    |",0
							  	 byte"|                                                        |",0
							 	 byte"|                                                        |",0
								 byte"|                                                        |",0
								 byte"|                                                        |",0
								 byte"|                                                        |",0
								 byte"|                                                        |",0
								 byte"|                                                        |",0
							  	 byte"|                                                        |",0
							 	 byte"|                                                        |",0
							 	 byte"|                                                        |",0
							 	 byte"|                                                        |",0
								 byte"|                                                        |",0
								 byte"|                                                        |",0
								 byte"..........................................................",0
	;Karte se stampaju od vrha
    CardLookUpTable byte "123456789xJQK"
    CardLookUPNumber10 byte "10", 0

    Card0 byte 13,8,"____________", 0,
					"|          |", 0,
					"|          |", 0,
					"|    /\    |", 0,
					"|    \/    |", 0,
					"|          |", 0,
					"|          |", 0,
					"____________", 0
    
	Card1 byte 13,8,"____________", 0,
					"|          |", 0,
					"|          |", 0,
					"|     O    |", 0,
					"|   O I O  |", 0,
					"|          |", 0,
					"|          |", 0,
					"____________", 0

    Card2 byte 13,8,"____________", 0,
					"|          |", 0,
					"|          |", 0,
					"|    nn    |", 0,
					"|    \/    |", 0,
					"|          |", 0,
					"|          |", 0,
					"____________", 0
	
    Card3 byte 13,8,"____________", 0,
					"|          |", 0,
					"|          |", 0,
					"|    /^\   |", 0,
					"|   * I *  |", 0,
					"|          |", 0,
					"|          |", 0,
					"____________", 0
	
	Card4 byte 13,8,"____________" ,0,
					"|          |", 0,
					"|B       ! |", 0,
					"|  L   J   |", 0,
					"|    A     |", 0,
					"|   C  C   |", 0,
					"| K      K |", 0,
					"____________", 0

	;Half flipped cards
	Cardf0 byte 5,8,"  -|" ,0, 
					"|` |", 0,
					"|' |", 0,
					"| ^|", 0,
					"| v|", 0,
					"|  |", 0,
					"|.'|", 0,
					"  -|", 0

	Cardf1 byte 5,8,"  -|" ,0,
					"|` |", 0,
					"|' |", 0,
					"| *|", 0,
					"|*||", 0,
					"|  |", 0,
					"|.'|", 0,
					"  -|", 0

	Cardf2 byte 5,8,"  -|" ,0,
					"|` |", 0,
					"|' |", 0,
					"| n|", 0,
					"| v|", 0,
					"|  |", 0,
					"|.'|", 0,
					"  -|", 0
	
	Cardf3 byte 5,8,"  -|" ,0,
					"|` |", 0,
					"|' |", 0,
					"| ^|", 0,
					"|*||", 0,
					"|  |", 0,
					"|.'|", 0,
					"  -|", 0
	
	Cardf4 byte 5,8,"|-  " ,0,
					"|;`|", 0,
					"||*|", 0,
					"| \|", 0,
					"|/;|", 0,
					"|;'|", 0,
					"| .|", 0,
					"|-  ", 0


    HitButtonSprite byte 13, 3, "------------", 0,
							    "|   H I T  |", 0,
								"------------", 0
	
    StandButtonSprite byte 17,3,"----------------", 0, 
								"|   S T A N D  |", 0,
								"----------------", 0
	
    DoublDownButtonSprite byte 29,3,"----------------------------", 0, 
									"|   D O U B L E   D O W N  |", 0,
									"----------------------------",0

	StartButtonSprite byte 17,3,"----------------", 0, 
								"|   S T A R T  |", 0,
								"----------------", 0

	JedanIgracButtonSprite byte 11,1,"   1 Igrac",0
	DvaIgracaButtonSprite byte 12,1,"   2 Igraca",0
	TriIgracaButtonSprite byte 12,1,"   3 Igraca",0

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
		winCount  BYTE 0
		Flags BYTE 0
		cards BYTE 21 DUP(0)
	Igrac ENDS

	;Znacenja flags varijable
	;1 bit govori da li je igrac bustovao
	;2 bit govori da li je igrac double downovao 
	;3 bit govori da li igrac ima jedinicu u ruciInformacije o kursoru
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
	KoordinateSpilaKarata byte 99,0
	
	windowRect SMALL_RECT <xmin, ymin, xmax, ymax>      ;Velicina prozora
	winTitle byte "ASM CMD Blackjack", 0				;Naslov programa
	cursorInfo CONSOLE_CURSOR_INFO <>
	Igraci Igrac 4 dup(<>)
						

.data?						
	stdOutHandle handle ?
	stdInHandle handle ?		;Promenljiva za kontrolu inputa u konzolu
	numInp dword ?				;Broj bajtova u ulaznom baferu
	temp byte 16 dup(?)			;Promenljiva koja sadrzi podatke tipa INPUT_RECORD
	bRead dword ?				;Broj procitanih ulaznih bajtova
	BrojRedovaCrtanjeKarta byte ?
	BrojNacrtanihKarata byte ?
	BrojIgraca byte ?
	Okruzenja OkruzenjeIgraca 4 dup(<?>)
	DugmiciTokomIgre Dugme 3 dup(<?>)
	DugmiciOdabiranjaKaraktera Dugme 3 dup(<?>)
	NajPoenaSkuplenihURundi byte ?
	SprajtoviIgraca DWORD 3 dup(?)
	StartDugme Dugme <?> ;

.code
UpdatePlayFrame PROC USES eax esi;ne updatuje dugmice
	call DrawBackGround
	mov eax, 1 
	mov esi, offset Okruzenja
	UpdateCardsForPlayers:
    	call NacrtajKarteIgraca
		INC al
		ADD esi, SIZEOF OkruzenjeIgraca;velicina struct okruzenja
		cmp al, BrojIgraca
		jle UpdateCardsForPlayers
	mov eax, brown + (gray * 16);resetovanje boja	
    call SetTextColor
	RET	
UpdatePlayFrame ENDP

DajAdresuFlipSprajta PROC;bl prima boju karte
	and bl, 3;daje tip karte
	cmp bl, 0
	je DiamondFlip
	cmp bl, 1
	je ClovesFlip
	cmp bl, 2
	je HeartFlip

	SpadeFlip:
		mov eax, black + (CardBackground * 16)	
    	call SetTextColor
		mov ebx, offset Cardf3
		RET

	DiamondFlip:
		mov eax, red + (CardBackground * 16)	
    	call SetTextColor
		mov ebx,offset Cardf0
		RET

	ClovesFlip:
		mov eax, black + (CardBackground * 16)	
    	call SetTextColor
		mov ebx, offset Cardf1
		RET

	HeartFlip:
		mov eax, red + (CardBackground * 16)	
    	call SetTextColor
		mov ebx, offset Cardf2
		RET

DajAdresuFlipSprajta ENDP

PustiAnimacijuKarte PROC USES eax ebx edx ecx ;al govori indeks karte, ah govori o tipu animacije
	call UpdatePlayFrame;ovim se pronalazi prazno polje gde karta treba da ide
	cmp ah, 4
	je CetvrtiTipAnimacije;okretanje dilerove facedown karte

	;Priprema za ostale tipove animacija
	mov ebx, offset KoordinateSpilaKarata
	mov dx, word ptr [ebx] ;masm 6.14 compatibility fix
	mov ebx, offset KoordinatePraznogPolja
	mov cx, word ptr [ebx] ;masm 6.14 compatibility fix
	SUB cl, dl
	SUB ch, dh;dobija se pomeraj od spila do praznog polja
	SAR cl,2;deli sa 4
	SAR ch,2;deli sa 4
	
	;Provera koji tip animacije
	cmp ah, 1
	je PrviTipAnimacije
	cmp ah, 2
	je DrugiTipAnimacije
	cmp ah, 3
	je TreciTipAnimacije

	;Karta se okrece dok ide. Ova animacija se pusta kada se karte dele svim igracima
	PrviTipAnimacije:
		;prvi frejm
		;transliranje vektora animacije
		ADD dl, cl;x projekcija
		ADD dh, ch;y projekcija
		mov ebx, offset Cardf4
		call DrawSprite
		mov bl, al
		push ebx
		mov eax, 300
		call delay

		;Drugi frejm
		call UpdatePlayFrame;obrise prosli frejm
		ADD dl, cl
		ADD dh, ch
		call DajAdresuFlipSprajta
		call DrawSprite
		call delay

		;Treci frejm
		pop ebx 
		call UpdatePlayFrame
		ADD dl, cl
		ADD dh, ch
		call DrawCard
		call delay
		RET;Kraj animacije

	;Karta se prvo okrene pa ide. Ovo se pusta kada igrac igra
	DrugiTipAnimacije:
		;Prvi frejm. Polu-okrenuta karta
		mov ebx, offset Cardf4
		call DrawSprite
		mov bl, al
		push ebx
		mov eax, 300
		call delay 

		;Drugi frejm
		call UpdatePlayFrame
		call DajAdresuFlipSprajta
		call DrawSprite
		call delay 

		;Treci frejm, karta okrenuta na vrhu spila
		pop ebx
		call DrawCard
		mov eax, 500
		call delay

		;Cetvrti frejm, karta se krece do ruke
		call UpdatePlayFrame
		ADD dl, cl
		ADD dh, ch
		call DrawCard
		mov eax, 300
		call delay

		;Peti frejm
		call UpdatePlayFrame
		ADD dl, cl
		ADD dh, ch
		call DrawCard
		call delay

		;Sesti frejm
		call UpdatePlayFrame
		ADD dl, cl
		ADD dh, ch
		call DrawCard
		call delay
		RET

	;Karta se ne okrece dok ide. Davanje dileru facedown kartu
	TreciTipAnimacije:
		;Prvi frejm
		ADD dl, cl
		ADD dh, ch
		mov ebx, offset Card4
		call DrawSprite
		mov eax, 300
		call delay 

		;Drugi frejm
		call UpdatePlayFrame
		ADD dl, cl
		ADD dh, ch
		call DrawSprite
		call delay 

		;Treci frejm
		call UpdatePlayFrame
		ADD dl, cl
		ADD dh, ch
		call DrawSprite
		call delay 
		RET

	;Karta se okrece na mestu, okretanje dilerove klopke
	CetvrtiTipAnimacije:
		;Prvi frejm
		mov edx, offset KoordinatePraznogPolja ;masm 6.14 compatability fix
		mov dx, word ptr [edx]
		mov ebx, offset Cardf4
		call DrawSprite
		mov bl, al
		mov eax, 300
		call delay 

		;Drugi frejm
		call DajAdresuFlipSprajta
		call DrawSprite
		call delay
		RET
PustiAnimacijuKarte ENDP

DodajKartuIgracu PROC USES eax esi ebx ecx ;ebx govori o igracu, al govori indeks karte, ah govori o tipu animacije koja se pusta kada se karta dodeljuje igracu
	;Biranje igraca
	push eax; eax sadrzi argument ali takodje je potreban za mnozenje
	mov eax, SIZEOF Igrac
	DEC bl
	MUL bl
	mov esi, offset Igraci
	movzx ebx, al
	ADD esi, ebx
	pop eax 

	movzx ebx, (Igrac ptr [esi]).cardCount ;koliko karata igrac ima u ruci
	mov ecx, esi 
	ADD ecx, ebx;ecx sadrzi sada pokazac na predpredpredposlednju kartu 
	ADD ecx, 3  ;ecx sadrzi sada pokazivac na poslednju kartu

	cmp bl, 0
	je SkipCheckingIfFlippedCard

	cmp byte ptr[ecx], 52;proverava da li je poslednja karta u ruci flipovana
	je ReadyToAddCard;ako karta nije flipovana ne treba prepisati preko nje

	SkipCheckingIfFlippedCard:
	INC bl
	mov (Igrac ptr [esi]).cardCount, bl;povecava broj karata u ruci igraca
	INC ecx
	ReadyToAddCard:
	
	mov byte ptr[ecx], 53;postavlja praznu kartu na polje

	call PustiAnimacijuKarte

	mov byte ptr[ecx], al;postavlja kartu na polje
	call UpdatePlayFrame ;nacrta novu kartu 

	cmp al, 52;ako je dodeljena naopacke karta, onda se nista ne proracunava
	je EndOfDodajKartu

	SHR al,2;dobija vrednost karte od 0 do 12
	INC al;od 1 do 13
	cmp al, 10;posto karte sa vrednoscu preko 10 imaju vrednost deset
	jl ClampovanjeVrednosti
	mov al, 10
	ClampovanjeVrednosti:

	mov ah, (Igrac ptr [esi]).pointCount;ukupan broj poena
	ADD ah, al;Dodavanje novih poena
	mov (Igrac ptr [esi]).pointCount, ah;zapisuje koliko poena ima igrac sada
	mov bl,(Igrac ptr [esi]).Flags;flags

	cmp al, 1
	jne EndOfDodajKartu
	OR bl, 4h ;sets the one flag, which is bit 3
	mov (Igrac ptr [esi]).Flags, bl;saves the value
	EndOfDodajKartu:
	RET
DodajKartuIgracu ENDP

DrawNubbins PROC USES eax ebx edx esi ;al je broj dugmica, esi je adresa prvog dugmeta
	mov ah, 1
	INC al
	DrawButtonsLoop:
			push eax
			cmp ah, SelectedButton
			je SelectedButtonColor;if(ah==selectedButton)
				;else
				mov eax, brown + (Gray * 16);boja obicnog dugmeta
				call SetTextColor 
				jmp DoneSettingButtonColor
			SelectedButtonColor:
				;if(true)
				mov eax, yellow + (Gray * 16)									 
				call SetTextColor
			
			DoneSettingButtonColor:
			;Crtanje sprajtova
			mov ebx, (Dugme ptr [esi]).SpriteZaDugme
			mov dx, word ptr (Dugme ptr [esi]).KoordinateSprajta
			call DrawSprite
	
			mov eax, [esp]
			cmp ah, SelectedButton
			jne DontDrawSelectedChar
				mov dx, word ptr (Dugme ptr [esi]).KoordinateKursora
				mov al, 62 ;ascii za '>'
				call GotoXY
				call WriteChar
			DontDrawSelectedChar:
			pop eax
			ADD esi, SIZEOF Dugme ;duzina Dugme struct
			INC ah
			cmp ah, al
		jne DrawButtonsLoop
		RET
	
DrawNubbins ENDP

DrawGamePlayNubbins PROC USES eax esi;Poziva DrawNubbins za crtanje dugmica tokom igre
	mov esi, offset DugmiciTokomIgre
	mov al, 3
	call DrawNubbins
	RET
DrawGamePlayNubbins ENDP

ClearScreenFaster PROC 
	mov eax, brown + (Gray * 16)
	call SetTextColor 
    mov ebx, offset PraznaMesta;faster to move regs then mem
	mov edx, 0 
    ClearScreenLoop:
   		call GotoXY
   		push edx
   		mov edx, ebx
   		call WriteString
   		pop edx
   		INC dh
   		cmp dh, 32
   		jne ClearScreenLoop
    RET
ClearScreenFaster ENDP

UpdateBrojIgracaMeni PROC USES eax ebx edx esi

	call ClearScreenFaster
	mov esi, offset DugmiciOdabiranjaKaraktera
	mov al, 3

	call DrawNubbins
	mov eax, brown + (Gray * 16)
	call SetTextColor

	;Drawing Shapiro on screen
	movzx eax, SelectedButton
	DEC eax
	mov bl, 7
	MUL bl
	mov dl, 30
	ADD dl, al;centrira poziciju karaktera
	mov dh, 10
	mov ebx, offset IgracSprite
	mov al, SelectedButton;brojac
	DrawDuelShapiro:
		call DrawSprite
		SUB dl, 14
		DEC al
		cmp al, 0
	jne DrawDuelShapiro
	RET
UpdateBrojIgracaMeni ENDP

DrawBackGround PROC USES eax ebx edx ecx esi
	mov cl, 1;brojac igraca
	mov esi, offset Okruzenja
	;crtanje svih sem aktivnog igraca
	DrawPlayerInterfaces: 
		cmp cl, AktivniIgrac
		je PreskociCrtanjeZaSada;if(player != AktivniIgrac)
			mov eax, brown + (Gray * 16);Boja interfejsa i prozora. Upisuju se u al i ah registre, zato je zapis ovakav
 	    	call SetTextColor  
			mov eax, (OkruzenjeIgraca ptr [esi]).IgracUOkruzenju ;adresa igraca
			mov bl, (Igrac ptr [eax]).Flags
			TEST bl, 1h ;vrh stacka pok
			jz SkipDrawingBustedFrame;ovo je kao if blok bez elsa. ovo je if(player_busted)
				mov eax, brown + (black * 16)
				call SetTextColor  
			SkipDrawingBustedFrame:
			push ebx;cuva flegove igraca na stek
			mov ebx, (OkruzenjeIgraca ptr [esi]).SpriteZaOkruzenje;adresa sprajta
			mov dx, word ptr (OkruzenjeIgraca ptr [esi]).KoordinateProzora ;koordinate sprajta
			call DrawSprite;ebx je sprite, edx su koordinate
			pop ebx;vraca flegove sa steka
			TEST bl, 10h ;proveravamo bit 5 koji cuva da li je igrac pobedio
			jz SkipDrawingVictoryFrame;if(player_won)
				mov eax, yellow + (Gray * 16)
				call SetTextColor
			SkipDrawingVictoryFrame:
			TEST bl, 8h ; proveravamo bit 4 koji gleda da li je igrac dobio blekdzek
			jz SkipDrawingBlackJackSprite
				push edx;cuva koordinate prozora na stek
				mov ebx, (OkruzenjeIgraca ptr [esi]).SpriteZaOkruzenje
				mov dx, word ptr [ebx];masm 6.14
				SHR dl, 1;deli dimenzije sa dva 
				SHR dh, 1
				mov ax, word ptr (OkruzenjeIgraca ptr [esi]).KoordinateProzora ;koordinate prozora
				ADD dl, al;postavlja koordinate na centar prozora
				ADD dh, ah
				SUB dl, 17;polovina black jack sprajta
				SUB dh, 5
				mov ebx, offset BlackJackSprite
				call DrawSprite
				pop edx;vraca koordinate prozora sa steka
			SkipDrawingBlackJackSprite:
			cmp cl, 1 ;if(player!=dealer)
			je SkipShiftingCursor
				INC dl;koordinate za crtanje poena
				INC dh
			SkipShiftingCursor:
			call GotoXY
			mov ebx, (OkruzenjeIgraca ptr [esi]).IgracUOkruzenju
			movzx eax, (Igrac ptr [ebx]).winCount ;poeni igraca
			call WriteDec
		PreskociCrtanjeZaSada:
		INC ecx
		ADD esi, SIZEOF OkruzenjeIgraca ;velicina strukture
		cmp cl, BrojIgraca
		jle DrawPlayerInterfaces

	;crtanje aktivnog igraca
	movzx ecx, AktivniIgrac
	cmp ecx, 0 ;nijedan igrac nije trenutno aktivan, zavsri funkciju
	je EndOFDrawingBackground
	mov eax, yellow + (Gray * 16)	
	call SetTextColor
	DEC ecx
	mov eax, ecx ;popunjaca vise bajtove eax sa nulama i pomera nizi bajt. bitno
	mov bl, SIZEOF OkruzenjeIgraca
	MUL bl
	mov esi, offset Okruzenja
	ADD esi, eax;skace na adresu aktivnog korisnika, potencijalno efikasnije od base displacementa?
	mov ebx, (OkruzenjeIgraca ptr [esi]).SpriteZaOkruzenje
	mov dx, word ptr (OkruzenjeIgraca ptr [esi]).KoordinateProzora
	call DrawSprite
	cmp ecx, 0;ovo je pozicija dealera
	je SkipShiftingCursorActive;prvom igracu, to jest, dealeru, ne treba pomerati kursor za crtanje poena na ekran
		INC dl;koordinate za crtanje poena
		INC dh
	SkipShiftingCursorActive:
	call GotoXY
	mov ebx, (OkruzenjeIgraca ptr [esi]).IgracUOkruzenju
	movzx eax, (Igrac ptr [ebx]).winCount
	call WriteDec
	EndOFDrawingBackground:
	RET
DrawBackGround ENDP

NacrtajKarteIgraca PROC USES eax ecx edx ebx esi;eax, ebx, ecx, edx su temp za racunanje, esi sadrzi adresu radnog ogruzenja u kome crta karte

	
	mov ebx, (OkruzenjeIgraca ptr [esi]).IgracUOkruzenju ;pointer na igraca
	mov cx, word ptr (OkruzenjeIgraca ptr [esi]).VelicinaProzora  ;granice prozora i koliko karata moze da ima prozor u jednom redu.
	movzx eax, (igrac ptr [ebx]).cardCount

	cmp eax, 0
	je KrajCrtanjaKarataIgraca

	XOR edx,edx

	DIV cl ;koliko ce biti redova 
	cmp ah, 0
	je ZaokruzivanjeNaGoreSkip
	INC al

	ZaokruzivanjeNaGoreSkip:
	mov dx, word ptr (OkruzenjeIgraca ptr [esi]).KoordinateCentraZaCrtanjeKarata ;gde treba da crta karte

	mov esi, ebx; esi je sada pointer na igraca
	
	mov BrojRedovaCrtanjeKarta, al ;BrojRedovaCrtanjeKarta ce da cuva broj redova
	SHL al, 1 ;mnozi sa dva za pomeraj polovine vertikalnog razmaka kursora
	SUB dh, al;pomera kursor za al mesta na gore
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
		mov al, (igrac ptr [esi]).cardCount
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
NacrtajKarteIgraca ENDP

DrawCard PROC USES eax edx ebx ;eax temp, edx posisiton, bl indeks karte
	cmp bl, 53;ne crta nista, ovo je korisno tokom animacije
	jne NormalnaKarta1
	mov eax, offset KoordinatePraznogPolja ;masm 6.14 compatibility 
	mov word ptr [eax], dx;cuva koordinate praznog polja kako bi animacija znala gde da salje kartu
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
    pop edx ;popping card index
	AND edx, 255 ;getting the last byte of the card index
    SHR edx, 2 ;div by 4
    cmp edx, 9 ;checking if card is 10 since it's two chars
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
	;10 sucks because of writeString and GotoXY using edx differently
    pop eax
    mov edx, eax
    INC dh
    INC dl
    call GotoXY
    mov edx, offset CardLookUPNumber10
    call writeString
    mov edx, eax ;coordinates repoped
    ADD dh, 7;7 here because going from corner instead of from top number
    ADD dl, 9
    call GotoXY
    mov edx, offset CardLookUPNumber10
    call writeString
	RET
DrawCard ENDP

DrawSprite PROC USES eax edx ebx ;eax temp, edx are the coordinates where to draw the sprite, ebx is the address of the sprite
    mov ah, [ebx] ;move width to ah
    INC ebx ;ebx now points to height of sprite
    mov al, [ebx] ;move hight to al
    INC ebx ;ebx point to the sprite itself
    SpriteDrawLoop:
    	call GotoXY
    	push edx ;write string also uses edx so it must be saved to stack first
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

PustiStartDugmeAnimaciju PROC
	mov eax, yellow + (CardBackground * 16)
    call SetTextColor   
	;mov esi, offset StartDugme  
	mov dx, word ptr StartDugme.KoordinateSprajta
	mov ebx, StartDugme.SpriteZaDugme ;adresa sprajta
	call DrawSprite
	mov dx, word ptr StartDugme.KoordinateKursora
	mov al, 62;ascii za '>'
	call GotoXY
	call WriteChar

	mov eax, 300
	call delay

	mov eax, brown + (CardBackground * 16)
    call SetTextColor   
	mov dx, word ptr StartDugme.KoordinateSprajta
	call DrawSprite
	mov dx, word ptr StartDugme.KoordinateKursora
	mov al, 62 ;ascii za '>'
	call GotoXY
	call WriteChar

	mov eax, 300
	call delay

	mov eax, yellow + (CardBackground * 16)
    call SetTextColor   
	mov dx, word ptr StartDugme.KoordinateSprajta
	call DrawSprite

	mov eax, 300
	call delay
	RET
PustiStartDugmeAnimaciju ENDP



main PROC

	;Intializing console settings
	invoke GetStdHandle, STD_OUTPUT_HANDLE		
    mov  stdOutHandle, eax

    invoke GetConsoleCursorInfo, stdOutHandle, addr cursorInfo      
    mov  cursorInfo.bVisible, 0										
    invoke SetConsoleCursorInfo, stdOutHandle, addr cursorInfo    

	invoke SetConsoleTitle, addr winTitle							
    invoke SetConsoleWindowInfo, stdOutHandle, TRUE, addr windowRect 

	invoke getStdHandle, STD_INPUT_HANDLE
	mov stdInHandle, eax

	;Sets new seed
	call Randomize

	mov esi, offset SprajtoviIgraca
	mov [esi], offset Igrac1Sprite
	mov [esi+4], offset Igrac2Sprite
	mov [esi+8], offset Igrac3Sprite

	;Inicijalizacija Start Dugmeta
	mov	StartDugme.SpriteZaDugme, offset StartButtonSprite
	mov word ptr StartDugme.KoordinateSprajta, 1730h ;Pomera kordinate (48,23) kao poziciju start dugmeta
	mov word ptr StartDugme.KoordinateKursora, 1832h ;Pomera kordinate (50,24) kao poziciju start dugmeta

	;Inicijalizacije Dugmica tokom igre
	mov DugmiciTokomIgre.SpriteZaDugme, offset HitButtonSprite
	mov word ptr DugmiciTokomIgre.KoordinateSprajta, 1C02h	;Pomera kordinate (2,28) kao poziciju hit dugmeta
	mov word ptr DugmiciTokomIgre.KoordinateKursora, 1D04h	;Pomera kordinate (4,29) kao poziciju hit dugmeta

	mov esi, SIZEOF Dugme
	mov (Dugme ptr DugmiciTokomIgre[esi]).SpriteZaDugme, offset StandButtonSprite
	mov word ptr (Dugme ptr DugmiciTokomIgre[esi]).KoordinateSprajta, 1C10h	;Pomera kordinate (16,28) kao poziciju stand dugmeta
	mov word ptr (Dugme ptr DugmiciTokomIgre[esi]).KoordinateKursora, 1D12h	;Pomera kordinate (18,29) kao poziciju stand dugmeta

	ADD esi, SIZEOF Dugme
	mov (Dugme ptr DugmiciTokomIgre[esi]).SpriteZaDugme, offset DoublDownButtonSprite
	mov word ptr (Dugme ptr DugmiciTokomIgre[esi]).KoordinateSprajta, 1C22h	;Pomera kordinate (34,28) kao poziciju bust dugmeta
	mov word ptr (Dugme ptr DugmiciTokomIgre[esi]).KoordinateKursora, 1D24h	;Pomera kordinate (36,29) kao poziciju bust dugmeta

	;CharacterSelectDugmici Vrednosti
	mov	DugmiciOdabiranjaKaraktera.SpriteZaDugme, offset JedanIgracButtonSprite
	mov word ptr DugmiciOdabiranjaKaraktera.KoordinateSprajta, 0A02h ;Pomera kordinate (2,10) kao poziciju dugmeta
	mov word ptr DugmiciOdabiranjaKaraktera.KoordinateKursora, 0A04h ;Pomera kordinate (50,24) kao poziciju dugmeta

	mov esi, SIZEOF Dugme
	mov (Dugme ptr DugmiciOdabiranjaKaraktera[esi]).SpriteZaDugme, offset DvaIgracaButtonSprite
	mov word ptr (Dugme ptr DugmiciOdabiranjaKaraktera[esi]).KoordinateSprajta, 0D02h	;Pomera kordinate (2,13) kao poziciju dugmeta
	mov word ptr (Dugme ptr DugmiciOdabiranjaKaraktera[esi]).KoordinateKursora, 0D04h	;Pomera kordinate (4,13) kao poziciju stand dugmeta

	ADD esi, SIZEOF Dugme
	mov (Dugme ptr DugmiciOdabiranjaKaraktera[esi]).SpriteZaDugme, offset TriIgracaButtonSprite
	mov word ptr (Dugme ptr DugmiciOdabiranjaKaraktera[esi]).KoordinateSprajta, 1002h	;Pomera kordinate (2,16) kao poziciju dugmeta
	mov word ptr (Dugme ptr DugmiciOdabiranjaKaraktera[esi]).KoordinateKursora, 1004h	;Pomera kordinate (4,16) kao poziciju dugmeta

	MainGameLoop:

	;Clearing screen before play
	call ClearScreenFaster
	mov eax, brown + (gray * 16)	
    call SetTextColor
	mov edx, 0
	mov ebx, offset TitleScreenSprite
	call DrawSprite


	MainMenueLoop:
	invoke ReadConsoleInput, stdInHandle, addr temp,1,addr bRead ;read keypress
	mov bx, word ptr temp
	cmp bx, 1;proverava da li event dolazi sa tastature
	jne MainMenueLoop

	mov bl, byte ptr [temp + 4]
	cmp bl, 0
	je MainMenueLoop
		mov bl, byte PTR [temp + 10]
		cmp bl, ENTER_KEY
		je NumberOfPlayersSelectPrep
	jmp MainMenueLoop

	NumberOfPlayersSelectPrep:
	call PustiStartDugmeAnimaciju


	mov SelectedButton, 1
	call UpdateBrojIgracaMeni

	NumberOfPlayersSelectLoop:
	invoke ReadConsoleInput, stdInHandle, addr temp,1,addr bRead
	mov bx, word ptr temp
	cmp bx, 1;proverava da li event dolazi sa tastature
	jne NumberOfPlayersSelectLoop

	mov bl, byte ptr [temp + 4]
	cmp bl, 0
	je NumberOfPlayersSelectLoop
		mov bl, byte PTR [temp + 10]

		cmp bl, UP_KEY
		je DecreaseNumOfPlayers

		cmp bl, DOWN_KEY
		je IncreaseNumOfPlayers

		cmp bl, ENTER_KEY
		je PrepMainGame
		
	jmp NumberOfPlayersSelectLoop

	DecreaseNumOfPlayers:
		mov al, SelectedButton
		DEC al
		cmp al, 0
		jne SkipResettingNumPlayBottom
		mov al, 3
		SkipResettingNumPlayBottom:
		mov SelectedButton, al
		call UpdateBrojIgracaMeni
	jmp NumberOfPlayersSelectLoop

	IncreaseNumOfPlayers:
		mov al, SelectedButton
		INC al
		cmp al, 4
		jne SkipResettingNumPlayTop
		mov al, 1
		SkipResettingNumPlayTop:
		mov SelectedButton, al
		call UpdateBrojIgracaMeni
	jmp NumberOfPlayersSelectLoop

	PrepMainGame:
	call ClearScreenFaster
	;PREP VREDNOSTI DEALERA
	mov edx, offset Igraci

	mov Okruzenja.IgracUOkruzenju, edx
	mov Okruzenja.SpriteZaOkruzenje, offset DealerInterface
	mov Okruzenja.VelicinaProzora, 40
	mov Okruzenja.KolikoKarataUJednomRedu, 22
	mov word ptr Okruzenja.KoordinateProzora, 0000h
	mov word ptr Okruzenja.KoordinateCentraZaCrtanjeKarata, 0528h;(40,5)

	ADD edx, SIZEOF Igrac;igrac 2
	mov esi, TYPE Okruzenja

	mov al, SelectedButton
	cmp al, 1
	je PrepOnePlayerGame

	cmp al, 2
	je PrepTwoPlayerGame

		;/////////prep values 3 igraca
		;Player 1
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).IgracUOkruzenju, edx
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).SpriteZaOkruzenje, offset ThreePlayerInterface
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).VelicinaProzora, 14
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).KolikoKarataUJednomRedu, 5
		mov word ptr (OkruzenjeIgraca ptr Okruzenja[esi]).KoordinateProzora, 0B00h ;(0,11)
		mov word ptr (OkruzenjeIgraca ptr Okruzenja[esi]).KoordinateCentraZaCrtanjeKarata, 1406h ;(6,20)

		;Player 2
		ADD esi, SIZEOF OkruzenjeIgraca
		ADD edx, SIZEOF Igrac
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).IgracUOkruzenju, edx
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).SpriteZaOkruzenje, offset ThreePlayerInterface
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).VelicinaProzora, 14
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).KolikoKarataUJednomRedu, 5
		mov word ptr (OkruzenjeIgraca ptr Okruzenja[esi]).KoordinateProzora, 0B26h ;(38,11)
		mov word ptr (OkruzenjeIgraca ptr Okruzenja[esi]).KoordinateCentraZaCrtanjeKarata, 142Dh ;(45,20)

		;Player 3
		ADD esi, SIZEOF OkruzenjeIgraca
		ADD edx, SIZEOF Igrac
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).IgracUOkruzenju, edx
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).SpriteZaOkruzenje, offset ThreePlayerInterface
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).VelicinaProzora, 14
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).KolikoKarataUJednomRedu, 5
		mov word ptr (OkruzenjeIgraca ptr Okruzenja[esi]).KoordinateProzora, 0B4Ch ;(76,11)
		mov word ptr (OkruzenjeIgraca ptr Okruzenja[esi]).KoordinateCentraZaCrtanjeKarata, 1454h ;(84,20)

		mov BrojIgraca, 4

	jmp GameLoop

	PrepTwoPlayerGame:
		;Player 1
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).IgracUOkruzenju, edx
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).SpriteZaOkruzenje, offset TwoPlayerInterface
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).VelicinaProzora, 26
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).KolikoKarataUJednomRedu, 10
		mov word ptr (OkruzenjeIgraca ptr Okruzenja[esi]).KoordinateProzora, 0B00h ;(0,11)
		mov word ptr (OkruzenjeIgraca ptr Okruzenja[esi]).KoordinateCentraZaCrtanjeKarata, 1410h ;(16,20)

		;Player 2
		ADD esi, SIZEOF OkruzenjeIgraca
		ADD edx, SIZEOF Igrac
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).IgracUOkruzenju, edx
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).SpriteZaOkruzenje, offset TwoPlayerInterface
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).VelicinaProzora, 26
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).KolikoKarataUJednomRedu, 10
		mov word ptr (OkruzenjeIgraca ptr Okruzenja[esi]).KoordinateProzora, 0B39h ;(57,11)
		mov word ptr (OkruzenjeIgraca ptr Okruzenja[esi]).KoordinateCentraZaCrtanjeKarata, 144Ch ;(76,20)

		mov BrojIgraca, 3

	jmp GameLoop

	PrepOnePlayerGame:
		;Player 1
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).IgracUOkruzenju, edx
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).SpriteZaOkruzenje, offset OnePlayerInterface
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).VelicinaProzora, 40
		mov (OkruzenjeIgraca ptr Okruzenja[esi]).KolikoKarataUJednomRedu, 22
		mov word ptr (OkruzenjeIgraca ptr Okruzenja[esi]).KoordinateProzora, 0B00h ;(0,11)
		mov word ptr (OkruzenjeIgraca ptr Okruzenja[esi]).KoordinateCentraZaCrtanjeKarata, 1428h ;(40,20) 

		mov BrojIgraca, 2

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
		
		mov esi, 0
		
		DodajKarteIgracima:
			INC ebx
			ADD esi, SIZEOF Igrac

			;First card
			OdaberiKartu
			mov ah, 1
			call DodajKartuIgracu

			;Second card
			OdaberiKartu
			mov ah, 1
			call DodajKartuIgracu

			;Checking for natural blackjacks
			mov ah, (Igrac ptr Igraci[esi]).pointCount ;poeni u ovoj rundi
			cmp ah, 11
			jne DodeliKarteSledecem 
				;if(pointCount == 11)
				mov al, (Igrac ptr Igraci[esi]).flags
				TEST al, 4h ;da li ima jedinicu u ruci
				jz DodeliKarteSledecem
					;if(player has ace)
					OR al, 8
					mov (Igrac ptr Igraci[esi]).flags, al;cuva da je igrac dobio natural blackjack
			DodeliKarteSledecem:
			cmp bl, BrojIgraca;prolazi kroz sve igrace i dodaje im karte
			jl DodajKarteIgracima

		mov AktivniIgrac, 1

		mov esi, offset Igraci
		jmp PromeniIgraca;ovako se inicijalizuju neophodne stvari za prvog pravog igraca kao i svakog narednog
		
		PlayLoop:
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

				cmp bl, ENTER_KEY
				je HandleGameplayButton

				cmp bl, ESC_KEY
				je PokaziPobednike
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

			mov al, (Igrac ptr [esi]).pointCount ;ucitava broj poena

			cmp al, 21
			je IgracJeDobioBlackJack
			cmp al, 21
			jg IgracJeBustovao

			mov ah, (Igrac ptr [esi]).flags ;ucitava flags varijablu
			TEST ah, 4; treci bit cuva da li igrac ima jedinicu u ruci; 
			jz PlayLoop;moze da igra ponovo jer nije bustovao niti dobio blackjack

			cmp al, 11;ako igrac ima jedinicu u ruci ta jedinica moze da se racuna kao 21 i ako ima 11 poena onda ima blackjack
			jne PlayLoop;ako nema blackjack moze da igra ponovo

			mov (Igrac ptr [esi]).pointCount, 21;postavlja 21 na broj poena pre nego sto menja igraca
			jmp IgracJeDobioBlackJack

		HandleStandButton:

			mov al, (Igrac ptr [esi]).pointCount
			cmp al, 11
			jg PromeniIgraca;ako ima vise od 11 onda iako ima 1 nece biti od koristi da se racuna kao 11

			mov ah, (Igrac ptr [esi]).Flags
			TEST ah, 4; treci bit cuva da li igrac ima jedinicu u ruci
			jz PromeniIgraca;moze samo da se promeni igrac

			ADD al, 10
			mov (Igrac ptr [esi]).pointCount, al;upisuje broj poena sa 1 racunatom kao 11
			jmp PromeniIgraca

		HandleDoubleDownButton:

			movzx ebx, AktivniIgrac
			OdaberiKartu
			mov ah, 2;sporiji tip animacije

			call DodajKartuIgracu;dodaje kartu aktivnom igracu

			mov al, (Igrac ptr [esi]).pointCount;ucitava broj poena
			mov ah, (Igrac ptr [esi]).Flags;ucitava flags varijablu
			OR ah, 2;podesava flag za double down
			mov (Igrac ptr [esi]).Flags, ah;sacuva flag

			cmp al, 21
			je IgracJeDobioBlackJack
			cmp al, 21
			jg IgracJeBustovao
			
			cmp al, 11
			jg PromeniIgraca;ako ima vise od 11 onda iako ima 1 nece biti od koristi da se racuna kao 11

			TEST ah, 4; treci bit cuva da li igrac ima jedinicu u ruci
			je PromeniIgraca;moze samo da se promeni igrac

			ADD al, 10
			mov (Igrac ptr [esi]).pointCount, al;upisuje broj poena sa 1 racunatom kao 11
			cmp al, 21
			je IgracJeDobioBlackJack
			jmp PromeniIgraca

		IgracJeBustovao:
			mov ah, (Igrac ptr [esi]).Flags;ucitava flags varijablu
			OR ah, 1;namesta bust flag
			mov (Igrac ptr [esi]).Flags, ah;cuva flags varijablu
			mov (Igrac ptr [esi]).pointCount, 0
			jmp PromeniIgraca

		IgracJeDobioBlackJack:
			mov ah, (Igrac ptr [esi]).Flags;ucitava flags varijablu
			OR ah, 8;namesta bust flag
			mov (Igrac ptr [esi]).Flags, ah;cuva flags varijablu
	
		PromeniIgraca:
			mov cl, NajPoenaSkuplenihURundi
			cmp cl, (Igrac ptr [esi]).pointCount ;proverava da li je ovaj igrac imao najvise poena
			jg PreskociPromenuPoena
			mov cl, (Igrac ptr [esi]).pointCount
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
			ADD esi, SIZEOF Igrac

			mov al, (Igrac ptr [esi]).Flags;flags
			TEST al, 8;natural blackjack
			jz PlayLoop;If(player doesn't have natural blackjack) play
				;if condition met	
				mov (Igrac ptr [esi]).pointCount, 22;Nat vredi vise od obicnog 21
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
			mov al, (Igrac ptr [esi]).pointCount;ucitava broj poena
			mov ah, (Igrac ptr [esi]).Flags

			TEST ah, 4; Did the dealer get an ace?
			jz DealerPlayLoop
			
			cmp al, 11
			jne DealerPlayLoop

			mov al, 22
			OR ah, 8 ;Dealer got a natural blackjack
			mov (Igrac ptr [esi]).Flags, ah
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

			mov al, (Igrac ptr [esi]).pointCount;ucitava broj poena


			cmp al, 21
			jg DealerBusted

			mov ah, (Igrac ptr [esi]).Flags
			TEST ah, 4;Did the dealer get an ace?
			je DealerPlayLoop

			cmp al, 11
			jg DealerPlayLoop

			ADD al, 10
			jmp DealerPlayLoop

		DealerBusted:
			mov al, 0
			mov ah, (Igrac ptr [esi]).Flags
			OR ah, 1
			mov (Igrac ptr [esi]).Flags, ah
		jmp ZavrsiRundu

		
		DealerDobioBlackJack:
			mov ah, (Igrac ptr [esi]).Flags;ucitava flags varijablu
			OR ah, 8;namesta bust flag
			mov (Igrac ptr [esi]).Flags, ah;cuva flags varijablu
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

		PokaziPobednike:
			mov eax, brown + (gray * 16)	
			call SetTextColor

			call ClearScreenFaster
			mov dl, 10
			mov dh, 0
			mov ebx,  offset PobedioJeSprite
			call DrawSprite

			mov esi, offset Igraci
			mov cl, 0
			mov bl, 1
			mov bh, BrojIgraca
			MaksimalniBrojPobedaLoop:
			mov al, byte ptr[esi + 2]
			cmp cl, al
			jge NijeMaksPoena
			mov cl, al
			NijeMaksPoena:
			INC bl
			ADD esi, 25;velicina igraca struct
			cmp bl,bh
			jle MaksimalniBrojPobedaLoop

			mov esi, offset Igraci
			mov al, byte ptr[esi + 2];dealerovi poeni
			cmp cl, al
			je DealerPobedio



				ADD esi, 25
				mov ch, BrojIgraca
				SUB ch, 2;prvi igrac ima indeks 0
				mov eax, 18
				MUL ch
				mov dl, 36
				mov dh, 10
				SUB dl, al;pomera ulevo
				
				mov eax, offset SprajtoviIgraca
				mov ch, 2
				NacrtajIgracePobednike:
					
					mov ebx, offset IgracSprite

					push eax
					mov eax, brown + (gray * 16)	
					call SetTextColor

					cmp cl, byte ptr[esi + 2]
					jne NemenajBojuPobednika
					
						mov eax, yellow + (gray * 16)	
						call SetTextColor

					NemenajBojuPobednika:
					pop eax

					call DrawSprite
					cmp cl, byte ptr[esi + 2]
					jne NePisiImePobednika

						push edx

						ADD dh, 17
						mov ebx, DWORD ptr [eax]

						call DrawSprite

						pop edx 
					NePisiImePobednika:
					ADD dl, 30
					ADD eax, 4;velicina dword
					ADD esi, 25
					INC ch
				cmp ch, BrojIgraca
				jle NacrtajIgracePobednike

				mov eax, 10000
				call delay
				jmp MainGameLoop

			DealerPobedio: 
			mov dl, 0
				mov dh, 6
				mov ebx, offset DealerVictorySprite
				call DrawSprite

				mov eax, yellow + (gray * 16)	
				call SetTextColor

				mov dl, 30
				mov dh, 24
				mov ebx, offset DealerTextSprite
				call DrawSprite

				mov eax, 10000
				call delay
				jmp MainGameLoop

    exit
main ENDP
END main
