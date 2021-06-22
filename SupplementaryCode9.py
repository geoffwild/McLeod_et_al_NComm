import numpy as np
import matplotlib.pyplot as plt
import matplotlib.lines as mlines
import pandas as pd

fig, ax = plt.subplots( nrows=1, ncols=2, sharex=False, sharey=False, figsize=(8,5) )

fs=12
fn="Arial"
transparency = 0.1

df = pd.read_csv( "Fig_5_Sept_17a_2019.csv", header = 1 )

for index in df.index:
  # there are 2 sets of 810 observations in the data frame
  # I only want the first 810
  if index > 809:
    continue
  if df.loc[index, 'HOa11'] - df.loc[index, 'HOa12'] > 0:
    color = 'red'
  else:
    color = 'blue'
  size = 2000 * abs( df.loc[index, 'HOa11'] - df.loc[index, 'HOa12'] )
  xcoord = 2 * df.loc[index,'drho']  
  ycoord = df.loc[index,'FCb111'] - df.loc[index,'FCb211']
  ax[0].scatter( xcoord, ycoord, color=color, alpha=transparency, s=size )

df = pd.read_csv( "Fig_5_Sept_21a_2019.csv", header = 1 )

for index in df.index:
  if df.loc[index, 'HOa11'] - df.loc[index, 'HOa12'] > 0:
    color = 'red'
  else:
    color = 'blue'
  size = 2000 * abs( df.loc[index, 'HOa11'] - df.loc[index,'HOa12'] )
  #
  ycoord = df.loc[index,'FCb111'] - df.loc[index,'FCb211']
  xcoord = 1 - df.loc[index,'cA21']
  #
  ax[1].scatter( xcoord, ycoord, color=color, alpha=transparency, s=size )

(xmin,xmax) = (-0.2,1.2)
(ymin,ymax) = (-12,12)
for i in [0,1]:
  ax[i].set_xlim(xmin, xmax)
  ax[i].set_ylim(ymin, ymax)
  ax[i].set_xticks([0, 1])
  ax[i].set_xticklabels(["none", "max"], fontsize=fs, fontname=fn)
  ax[i].set_yticks([-10, 0, 10 ])
  if i==0:
    ax[i].set_yticklabels(["-10", "0", "10"], fontsize=fs, fontname=fn)
  else:
    ax[i].set_yticklabels(["", "", ""], fontsize=fs, fontname=fn)
  ax[i].set_xlabel('Extent of\n Difference', labelpad=-7, fontsize=fs, fontname=fn)
  ax[i].set_aspect(0.06)

ax[0].set_ylabel("Excess Female Susceptibility", fontsize=fs, fontname=fn)
ax[0].set_title("Different Influx of Sexes", fontsize=fs, fontname=fn)
ax[1].set_title("Different Contact Patterns", fontsize=fs, fontname=fn)

red_circ = mlines.Line2D([], [], color='red', marker='o', alpha = 0.25,
                          markersize=12, linestyle='None', label=r'$\alpha^*_{\bullet 1}>\alpha^*_{\bullet 2}$')
blue_circ = mlines.Line2D([], [], color='blue', marker='o', alpha = 0.25, 
                          markersize=12, linestyle='None', label=r'$\alpha^*_{\bullet 1}<\alpha^*_{\bullet 2}$')
plt.legend(handles=[red_circ, blue_circ], frameon=False, loc='lower left', fontsize=fs)

plt.subplots_adjust( left= 0.1, right=0.975, wspace=0.1, hspace=0.2, bottom=0.1, top=0.95 )

plt.show()