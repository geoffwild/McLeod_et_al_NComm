import numpy as np
import matplotlib.pyplot as plt
import matplotlib.lines as mlines
import pandas as pd

# read data from file into dataframe
df = pd.read_csv( "Fig_7_Nov_28a_2019.csv", header = 1 )

fig, ax = plt.subplots( nrows=1, ncols=2, figsize=(8,4.25) )

fs = 12
fn = "Arial"
transparency = 0.1

# plot data
cnt = 0
for index in df.index:
  sigma = df.loc[index,'sigma']
  if sigma != 0.1:
    continue
  cnt+=1
  if cnt % 10 != 0:
    continue
  asame = 0.5 * (df.loc[index, 'FPa11'] + df.loc[index, 'FPa22'] )
  across= 0.5 * (df.loc[index, 'FPa21'] + df.loc[index, 'FPa12'] )
  if asame - across > 0:
    color = 'orange'
  else:
    color = 'black'
  size = 5000 * abs( asame - across )
  #
  xcoord = np.sqrt(df.loc[index,'FCb111'] * df.loc[index,'FCb221'])
  ycoord = np.sqrt(df.loc[index,'FCb121'] * df.loc[index,'FCb211'])
  #
  ax[0].scatter( xcoord, ycoord, color=color, alpha=transparency, s=size )
 
df = pd.read_csv( "Fig_7_Nov_28b_2019.csv", header = 1 )

cnt = 0
for index in df.index:
  cnt+=1
  if cnt % 10 != 0:
    continue
  asame = 0.5 * (df.loc[index, 'FPa11'] + df.loc[index, 'FPa22'] )
  across= 0.5 * (df.loc[index, 'FPa21'] + df.loc[index, 'FPa12'] )
  if asame - across > 0:
    color = 'orange'
  else:
    color = 'black'
  #size = 5000 * abs( df.loc[index, 'FPa11'] - df.loc[index, 'FPa12'] )
  size = 5000 * abs( asame - across )
  #
  xcoord = np.sqrt( df.loc[index,'FCb111'] * df.loc[index,'FCb221'] )
  ycoord = np.sqrt( df.loc[index,'FCb121'] * df.loc[index,'FCb211'] )
  #
  ax[1].scatter( xcoord, ycoord, color=color, alpha=transparency, s=size )
  
ax[0].set_ylabel("Avg Cross-sex Transmission", fontsize=fs, fontname=fn)
(min,max) = (9,21)

for i in [0,1]:
  ax[i].set_xlabel("Avg Same-sex Transmission", fontsize=fs, fontname=fn)
  ax[i].set_xlim(min,max)
  ax[i].set_ylim(min,max)
  ax[i].set_xticks([10, 15, 20])
  ax[i].set_xticklabels(["10", "15", "20"], fontsize=fs, fontname=fn)
  ax[i].set_yticks([10,15,20])
  if i == 0:
    ax[i].set_yticklabels(["10", "15", "20"], fontsize=fs, fontname=fn)
    ax[i].plot([min,max],[min,max], ':', linewidth=1, color='gray')
  else:
    ax[i].set_yticklabels(["", "", ""])
    ax[i].plot([min,max-4],[min,max-4], ':', linewidth=1, color='gray')
  ax[i].set_aspect("equal")

ax[0].set_title("Different Influx of Sexes", fontsize=fs, fontname=fn)
ax[1].set_title("Different Contact Patterns", fontsize=fs, fontname=fn)

red_circ = mlines.Line2D([], [], color='orange', marker='o', alpha = 0.25,
                          markersize=12, linestyle='None', label=r'$\bar \alpha^*_{kk}>\bar \alpha^*_{\neg kk}$')
blue_circ = mlines.Line2D([], [], color='black', marker='o', alpha = 0.25, 
                          markersize=12, linestyle='None', label=r'$\bar \alpha^*_{kk}<\bar \alpha^*_{\neg kk}$')
plt.legend(handles=[red_circ, blue_circ], frameon=False, loc='upper right', fontsize=fs)

plt.subplots_adjust( left= 0.1, right=0.975, wspace=0.1, hspace=0.1, bottom=0.1, top=0.95 )
plt.show()