import mysql.connector as sql
from datetime import datetime
import pandas as pd
db=sql.connect(host='185.210.145.1',user='u724843278_ISC',password='ISCdatabase@1234',database='u724843278_ISC')
cur=db.cursor(dictionary=True)
# cur.execute('select sports_name from games')
# games=[i['sports_name'].replace(' ','_') for i in cur.fetchall()]
# slots=['6am-7am','7am-8am','8am-9am','4pm-5pm','5pm-6pm','6pm-7pm','7pm-8pm']
# for i in games:
#     for j in slots:
#         com=f'INSERT INTO {i} (`Slots`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday`, `Saturday`, `Sunday`)values(%s,%s,%s,%s,%s,%s,%s,%s)'
#         val=(str(j),str(20),str(20),str(20),str(20),str(20),str(20),str(20))
#         cur.execute(com,val)
#         db.commit()

# game='Tennis'
# slot='7:00am-8:30am'
# date=datetime.strptime('13/01/2022', "%d/%m/%Y").strftime("%Y-%m-%d")
# cur.execute(f"select Student_Name,SNU_ID from `bookings` where `Game`='{game}' and `Slot`='{slot}' and `Date`='{date}' and `Confirm`='1'")
# print(cur.fetchall())
cur.execute('select * from `Badminton`')
a=cur.fetchall()
d={i:{} for i in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']}
for i in d:
    for x in a:
        d[i][x['Slots']]=x[i]
