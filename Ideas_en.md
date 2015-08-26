# Abbreviations #

B - BUY,
BL - BUYLimit,
BS - BUYSTOP,
S - SELL,
SL - SELLLimit,
SS - SELLSTOP

X@B: X - ticket, B - Operation



# Idea #

We have:
<b>Market Order</b> - (primary parent).
Exemple: 0@B

The options cover:
  * 1. Grid limit orders in the direction of the main parent
If a parent was BUY, then the grid will BUYLimit.
Example: 3@BL - 2@BL - 1@BL - 0@B
  * 2. Stop orders in the grid direction of the main parent
If a parent was BUY, then the grid will BUYStop.
Example: 0 @ B - 1 @ BS - 2 @ BS - 3 @ BS
  * 3. Grid limit orders in the opposite direction (SELLLimit)
Example: 0 @ B - 1 @ SL - 2 @ SL - 3 @ SL
  * 4. Net stop orders in the opposite direction (SELLStop)
Example: 3 @ SS - 2 @ SS - 1 @ SS - 0 @ B
  * 5. Ability to use independent of each option.
  * 6. Ability to use a dependent related options.
Example: (3 @ BL && 6 @ SS) - (2 @ BL && 5 @ SS) - (1 @ BL && 4 @ SS) - 0 @ B
  * 7. STOPORDERS (Stop order) have the potential to be the parents of the highest degree.