import pandas as pd
a=pd.read_excel("C:/Users/Sarthak/Desktop/Kavita Singhania - NF Jan-22.xlsb",sheet_name="Jan_Orders")
c=pd.read_excel("C:/Users/Sarthak/Desktop/Kavita Singhania - NF Jan-22.xlsb",sheet_name="Dec_Orders")
print('Commission on Delivered Goods:',
      (sum(a[(a['Yes or No']=='Yes') & (a['Final Status January']=='Delivered')]['dp_per_unit'])*.35)
      +(sum(a[(a['Yes or No']=='No') & (a['Final Status January']=='Delivered')]['mrp_per_unit'])*.35)
      +(sum(c[(c['Yes or No']=='Yes') & (c['Final Status January']=='Delivered')]['dp_per_unit'])*.35)
      +(sum(c[(c['Yes or No']=='No') & (c['Final Status January']=='Delivered')]['mrp_per_unit'])*.35))
print('Total on Delivered Goods:',
      (sum(a[(a['Yes or No']=='Yes') & (a['Final Status January']=='Delivered')]['dp_per_unit']))
      +(sum(a[(a['Yes or No']=='No') & (a['Final Status January']=='Delivered')]['mrp_per_unit']))
      +(sum(c[(c['Yes or No']=='Yes') & (c['Final Status January']=='Delivered')]['dp_per_unit']))
      +(sum(c[(c['Yes or No']=='No') & (c['Final Status January']=='Delivered')]['mrp_per_unit'])))
