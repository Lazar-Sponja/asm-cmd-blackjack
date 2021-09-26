# Command Line Blackjack
Command line black jack game written in masm x86 assembly code. Literal school project.

The game uses the [irvine32 library](), and can be compiled with masm 6.14 with wine on linux.  

The game consists conists of series of functions which react to player input, either by updating ui elemets or handling the game logic

# Assembling
TODO:

# Game Breakdown
Most functions are functions dedicated to the "fancy" graphics you see on the terminal, while main mostly handles the game logic based on player input 

A cursory explanation of the functions in the code can be found below. Functions use registers for arguments.
## `DrawSprite(dx:position, ebx:addr_of_sprite)`
The fuctions takes two arguments, position and address in memory of the sprite to draw on screen.

The function does this by repeated calls to `GotoXY()` and `WriteString()` from the [irvine32 library]()

## `DrawCard(dx:position, bl:card_index)`
This function takes two arguments, position and card number *(from 0 to 51)*. 

The function decodes the color and number of the card based on it's index by first doing mod 4 operation to figure out the color of the card, and then it calls `DrawSprite()` to draw the card with the decoded symbol at the specified position.

Then the function figures out the card number by integer diving the index by 4, then drawing the number on the corners of the card. 

Special index numbers are 52 and 53. These are used for card animations
- 52 tells the function to draw the back of the card
- 53 skips drawing and saves coordinates to *KoordinatePraznogPolja*

## `NacrtajKarteIgraca(esi:player_ptr)`
This function draws cards that the player has in hand by calculating the number of rows that can fit on the player's table, then does the following:
- Moves up 2 times the number of cards rows up and _n_ times half a card widths to the left
- Draws cards in a row card by card until it hit the max number of cards per row *(max number of cards per row is a variable in the `IgracUOkruzenju` struct whose value get's initalized in main based on how many player are active at a time)*
- Drops by 4 and draws another row. It repeats this until the player runs out of cards

There are a few exceptions to these rules, such as:
- When moving back, _n_ cards widths, if the edge of the table has been reached, cards will start to be drawn denser, as the cursor will move less to the right when drawing the rest of the cards in order to fit in the row


## `DrawBackground()`
This function draws the background sprites like the dealer and his deck, and player boxes in various states, such as busted, won or got a 21. 

The function first draws all the players except the player whose turn it currently is, then that player so that player would have their broder selected.

## `UpdatePlayFrame()`
This function calls `DrawBackground()`, then calls `NacrtajKarteIgraca()`for each player. Basically, updates the current screen. It also sets the text color to default. 

It doesn't refresh the buttons.

## `DajAdresuFlipSprajta(bl:card_type)`
This function moves the address of a flipped card sprite based on the current value in `bl`. 

| `bl` value  | Card type |
|:-----------:|:---------:|
|      0      |  Diamond  |
|      1      |   Clove   |
|      2      |   Heart   |
|      3      |   Spade   |

## `ClearScreenFaster()`
This function writes a blank string over the entire screen to effectively clear it. It is much faster then the `Clrscr()` form the irvine32 library, and the game doesn't care if the frame buffer as invisible characters on screen or no characters on screen

## `DrawNubbins(al:n_buttons, esi:button_array_ptr)`
This function draws all the on screen buttons. It checks which one is the currently selected one *(it checks the SelectedButton variable)* and draws the selected button yellow with the '>' symbol

This function doesn't care which buttons it draws, as long as `esi` points to an array of `Dugme` structs, the function will draw all the buttons, making it usable for both the player select screen and handling gameplay buttons

## `DrawGameplayNubbins()`
This preps `DrawNubbins` to draw the gameplay buttions. Can be a macro too but this is potentially more memory efficient.

## `UpdateBrojIgracaMeni()`
This preps `DrawNubbins` to draw the player select buttions. It also draws the player graphic based on the highlighted button. 

## `PustiAnimacijuKarte(al:card_index, ah:anim_type)`
This function hold 4 different types of animations that get played when dealing cards

1. The card is flipping at it travels to the player
2. The card first flips, then travels to the player
3. The card is moving face-down 
4. The card that is facedown flips

All animations, except the 4th one, calculate a vector form `KoordinateSpilaKarata`, a memory location representing the location of the deck, to `KoordinatePraznogPolja`, a memory location representing the coordinates of where the card will end up being *(this memory location is set by `DrawCard(bl:53)`)*. This vector is then divided by 4 in order to make 4 frame moves from deck to 

## `DodajKartuIgracu(ebx:current_player, al:card_index, ah:animation_type)`
This function calls `PustiAnimacijuKarte()`, draws the the new card on th screen and finally updates that players `pointCount` and `Flags`.
