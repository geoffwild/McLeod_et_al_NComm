import matplotlib.pyplot as plt
import matplotlib.lines as mlines
import pandas as pd

fs=12
fn='Arial'
transparency = 0.3

fig, ax = plt.subplots( nrows=1, ncols=2, sharex=False, sharey=False, figsize=(8,5) )

df = pd.read_csv( "Fig_6_Nov_14_2019.csv", header = 1 )

for index in df.index:
  aSame = df.loc[index, 'FPa11'] + df.loc[index, 'FPa22']
  aCross = df.loc[index, 'FPa12'] + df.loc[index, 'FPa21']
  if aSame - aCross > 0:
    color = 'orange'
  else:
    color = 'black'
  size = 1000 * abs( aSame - aCross )

  xcoord = 1 - df.loc[index,'cA21']
  ycoord = df.loc[index,'rho']
  ax[0].scatter( xcoord, ycoord, color=color, alpha=transparency, s=size )

df = pd.read_csv( "Fig_6_Nov_15_2019.csv", header = 1 )

for index in df.index:
  aSame = df.loc[index, 'FPa11'] + df.loc[index, 'FPa22']
  aCross = df.loc[index, 'FPa12'] + df.loc[index, 'FPa21']
  if aSame - aCross > 0:
    color = 'orange' # orange
  else:
    color = 'black' # black
  size = 1000 * abs( aSame - aCross )

  xcoord = 1 - df.loc[index,'cA21']
  ycoord = df.loc[index,'rho']
  ax[1].scatter( xcoord, ycoord, color=color, alpha=transparency, s=size )

for i in [0,1]:
  ax[i].set_xlim([-0.2,1.2])
  ax[i].set_ylim([-0.2,1.2])
  ax[i].set_xticks([0,1])
  ax[i].set_xticklabels(['min','max'])
  ax[i].set_xlabel('Extent of the difference\n between contact patterns', labelpad=-7, fontsize=fs, fontname=fn)
  ax[i].set_yticks([0,0.5,1])
  ax[i].set_aspect('equal')

ax[0].set_ylabel('Birth rate greater in\n subpop where the\ncontacts are mainly', labelpad=-25, fontsize=fs, fontname=fn)
ax[0].set_yticklabels(['cross\nsex', '', 'same\nsex'],rotation=45)
ax[1].set_yticklabels(['un-\nbiased','','same\nsex'], rotation=45)

ax[0].set_title('Same-sex contacts prevail in A, but\ncross-sex contacts prevail in B',fontsize=fs,fontname=fn)
ax[1].set_title('Same-sex contacts prevail in A, but\nno bias in B',fontsize=fs,fontname=fn)

or_circ = mlines.Line2D([], [], color='orange', marker='o', alpha = 0.25,
                          markersize=12, linestyle='None', label=r'$\bar\alpha^*_{kk}>\bar \alpha^*_{\neg k k}$')
bl_circ = mlines.Line2D([], [], color='black', marker='o', alpha = 0.25, 
                          markersize=12, linestyle='None', label=r'$\bar \alpha^*_{kk}<\bar \alpha^*_{\neg k k}$')
plt.legend(handles=[or_circ, bl_circ], frameon=False, loc='upper left', fontsize=fs-2)
plt.subplots_adjust( left= 0.1, right=0.975, wspace=0.2, hspace=0.1, bottom=0.1, top=0.95 )

plt.show()