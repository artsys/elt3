# 缩写解释 #

B - Buy,多
BL - BUYLimit, 买入限价
BS - BUYSTOP,买入止损
S - SELL,空
SL - SELLLimit,卖出限价
SS - SELLSTOP,卖出止损

X@B: X - ticket(单号), B - Operation(操作)



# 思路 #

已有交易:
<b>Market Order</b> - (primary parent 主单)。
例如: 0@B

操作如下:
  * 1. 主单方向的网格限价单
若主单为多单，网格挂买入限价BuyLimit。
例如: 3@BL - 2@BL - 1@BL - 0@B
  * 2. 主单方向的网格止损单
若主单为多单，网格挂买入止损BuyStop
例如: 0 @ B - 1 @ BS - 2 @ BS - 3 @ BS
  * 3. 相反方向的网络限价单 (SELLLimit)
例如: 0 @ B - 1 @ SL - 2 @ SL - 3 @ SL
  * 4. 相反方向的网络单 (SELLStop)
例如: 3 @ SS - 2 @ SS - 1 @ SS - 0 @ B
  * 5. 能够使用每个独立的选项。
  * 6. 能够使用具有依存关系的选项。
例如: (3 @ BL && 6 @ SS) - (2 @ BL && 5 @ SS) - (1 @ BL && 4 @ SS) - 0 @ B
  * 7. STOPORDERS (Stop order) have the potential to be the parents of the highest degree.