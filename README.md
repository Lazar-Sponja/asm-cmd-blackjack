# Command Line Blackjack
Command line black jack game written in masm x86 assembly code. Literal school project

The game consists conists of series of functions which react to player input, either by updating ui elemets or handling the game logic


# Functions
Most functions are functions dedicated to the `"fancy"` graphics you see on the terminal, while main mostly handles the game logic based on player input 

A detalied explanation of the functions in the code can be found below
## `DrawSprite(position, addr_of_sprite)`
The fuctions takes two arguments, position and address in memory of the sprite to draw on screen. The position argumet is expected to be in the `edx` register, while the sprite address at `ebx`.

## `DrawCard(position, card_index)`
This function takes two arguments, position and card number *(from 0 to 51)*. 

The function decodes the color and number of the card based on it's index by first doing mod 4 operation to figure out the color of the card, and then it calls draw sprite to call a card with the decoded symbol at the specified position.

Then the function figures out the card number by integer diving the index by 4, then drawing the number on the corners of the card. 

Special index numbers are 52 and 53. These are used for card animations
- 52 tells the function to draw the back of the card
- 53 skips drawing and saving coordinates to *KoordinatePraznogPolja*

## `NacrtajKarteIgraca(player_ptr)`
This function takes the pointer to a player table, in the register `esi`. This function draws cards that the player has in hand by calculating the number of rows that can fit on the players table, by moving up 2 times the number of cards rows up and $n$ times half a card width rows to the left, then drawing each row and dropping by 4 to draw the next row.