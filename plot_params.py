from scipy.io import loadmat
import numpy as np
import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt



font = {'family' : 'normal',
        'weight' : 'bold',
        'size'   : 18}

plt.rc('font', **font)
plt.rcParams['pdf.fonttype'] = 42
plt.rcParams['ps.fonttype'] = 42
plt.rcParams['svg.fonttype'] = 'none'

sns.set(rc={'figure.figsize':(11.7,8.27)})
sns.set_style("whitegrid", {'axes.grid' : False})





# name = 'results_params_treat/tmp_paramsCircularity.mat'
# data = loadmat(name)

# class_ = data['class'][0,:]
# G = data['Gs'][0,:]
# param = data['paramss'][0,:]


# class_ = np.stack(class_)[:,0]

# df = pd.DataFrame({'class': class_, 'G (Pa)': G,'Circularity':param})


# # g = sns.kdeplot(data=df, x='G (Pa)', y='Circularity', hue='class',fill=True)
# # g = sns.kdeplot(data=df, x='G (Pa)', y='Circularity', hue='class',levels=8, thresh=.3)
# g = sns.kdeplot(data=df, x='G (Pa)', y='Circularity', hue='class',levels=10, thresh=.3,fill=True,alpha=.5)
# sns.scatterplot(data=df, x='G (Pa)', y='Circularity', hue='class')
# g.set(ylim=(0.3, 1.1))
# g.set(xlim=(-20, 180))
# plt.savefig('results_params_treat/tmp_paramsCircularity.svg', transparent=True)





# name = 'results_params_recovery/tmp_paramsCircularity.mat'
# data = loadmat(name)

# class_ = data['class'][0,:]
# G = data['Gs'][0,:]
# param = data['paramss'][0,:]


# class_ = np.stack(class_)[:,0]

# df = pd.DataFrame({'class': class_, 'G (Pa)': G,'Circularity':param})


# # g = sns.kdeplot(data=df, x='G (Pa)', y='Circularity', hue='class',fill=True)
# # g = sns.kdeplot(data=df, x='G (Pa)', y='Circularity', hue='class',levels=8, thresh=.3)
# g = sns.kdeplot(data=df, x='G (Pa)', y='Circularity', hue='class',levels=10, thresh=.3,fill=True,alpha=.5)
# sns.scatterplot(data=df, x='G (Pa)', y='Circularity', hue='class')
# g.set(ylim=(0.3, 1.1))
# g.set(xlim=(-20, 180))
# plt.savefig('results_params_recovery/tmp_paramsCircularity.svg', transparent=True)








# name = 'results_params_treat/tmp_paramsMass.mat'
# data = loadmat(name)

# class_ = data['class'][0,:]
# G = data['Gs'][0,:]
# param = data['paramss'][0,:]


# class_ = np.stack(class_)[:,0]

# df = pd.DataFrame({'class': class_, 'G (Pa)': G,'Mass (pg)':param})


# # g = sns.kdeplot(data=df, x='G (Pa)', y='Mass (pg)', hue='class',fill=True)
# # g = sns.kdeplot(data=df, x='G (Pa)', y='Mass (pg)', hue='class',levels=8, thresh=.3)
# g = sns.kdeplot(data=df, x='G (Pa)', y='Mass (pg)', hue='class',levels=10, thresh=.3,fill=True,alpha=.5)
# sns.scatterplot(data=df, x='G (Pa)', y='Mass (pg)', hue='class')
# g.set(ylim=(0, 1000))
# g.set(xlim=(-20, 180))
# plt.savefig('results_params_treat/tmp_paramsMass.svg', transparent=True)







# name = 'results_params_recovery/tmp_paramsMass.mat'
# data = loadmat(name)

# class_ = data['class'][0,:]
# G = data['Gs'][0,:]
# param = data['paramss'][0,:]


# class_ = np.stack(class_)[:,0]

# df = pd.DataFrame({'class': class_, 'G (Pa)': G,'Mass (pg)':param})


# # g = sns.kdeplot(data=df, x='G (Pa)', y='Mass (pg)', hue='class',fill=True)
# # g = sns.kdeplot(data=df, x='G (Pa)', y='Mass (pg)', hue='class',levels=8, thresh=.3)
# g = sns.kdeplot(data=df, x='G (Pa)', y='Mass (pg)', hue='class',levels=10, thresh=.3,fill=True,alpha=.5)
# sns.scatterplot(data=df, x='G (Pa)', y='Mass (pg)', hue='class')
# g.set(ylim=(0, 1000))
# g.set(xlim=(-20, 180))
# plt.savefig('results_params_recovery/tmp_paramsMass.svg', transparent=True)
