import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import matplotlib.lines as mlines

# read data from file into dataframe
df = pd.read_csv( "Fig_4_Sept_13_2019.csv", header = 1 )

fig, ax = plt.subplots( nrows=1, ncols=2, figsize=(8,4.5) )

fs = 12
fn='Arial'

for index in df.index:
  if df.loc[index, 'HOa11'] - df.loc[index, 'HOa12'] > 0:
    color = 'red'
  else:
    color = 'blue'
  size = 5000 * abs( df.loc[index, 'HOa11'] - df.loc[index, 'HOa12'] )
  transparency = 0.075
  b11xb22 = df.loc[index, 'FCb111'] * df.loc[index, 'FCb221']
  b12xb21 = df.loc[index, 'FCb121'] * df.loc[index, 'FCb211']
  if b11xb22 > b12xb21:
    i = 0
  else:
    i = 1
  #
  ycoord = np.sqrt( df.loc[index,'FCb221'] * df.loc[index,'FCb121'])
  xcoord = np.sqrt( df.loc[index,'FCb211'] * df.loc[index,'FCb111'])
  ax[i].scatter( xcoord, ycoord, color=color, alpha=transparency, s=size )


ax[0].plot( [10,20], [10,20], ':', color='gray' )
ax[1].plot( [10,17.5], [10,17.5], ':', color='gray' )

for i in [0,1]:
  ax[i].set_xlim(10,20)
  ax[i].set_ylim(10,20)
  ax[i].set_aspect('equal')
  ax[i].set_xlabel('Avg Infectivity from Females',\
    fontsize=fs, fontname=fn)
ax[0].set_ylabel('Avg Infectivity from Males', fontsize=fs, fontname=fn)

for j in [0,1]:
  ax[j].set_xticks([10, 15, 20])
  ax[j].set_xticklabels([r"$10$", r"$15$", r"$20$"], fontsize=fs, fontname=fn)
  ax[j].set_yticks([10, 15, 20])
  if j==0:
    ax[j].set_yticklabels([r"$10$", r"$15$", r"$20$"], fontsize=fs, fontname=fn)
  else:
    ax[j].set_yticklabels([])


ax[0].set_title("Avg Same-Sex > Avg Cross-Sex",fontsize=fs, fontname=fn)



ax[1].set_title('Avg Same-Sex < Avg Cross-Sex', fontsize=fs, fontname=fn)

red_circ = mlines.Line2D([], [], color='red', marker='o', alpha = 0.25,
                          markersize=12, linestyle='None', label=r'$\alpha_{\bullet f}^*>\alpha_{\bullet m}^*$')
blu_circ = mlines.Line2D([], [], color='blue', marker='o', alpha = 0.25, 
                          markersize=12, linestyle='None', label=r'$\alpha_{\bullet f}^*<\alpha_{\bullet m}^*$')
plt.legend(handles=[red_circ, blu_circ], frameon=False, loc='upper right', fontsize=fs)

plt.subplots_adjust( left= 0.1, right=0.95, wspace=0.05, hspace=0.1, bottom=0.2 )
plt.show()
