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


# com="update Badminton set Monday=%s where Slots=%s"
# val=(str(10),str('7am-8am'))
# num=6
# slot='6am-7am'
# cur.execute(f"update Badminton set Monday=Monday-{num} where Slots='{slot}'")
# db.commit()
# date=datetime.today().strftime('%Y-%m-%d')
# cur.execute(f'select * from `bookings` where `Roll_No`=2222 and `Date`>{date}')
# bookings={}
# for i in cur.fetchall():
#     bookings[i['Student_Name']]=
# date=datetime.today().strftime('%Y-%m-%d')
# roll_no='tm217'
# cur.execute(f"select * from `bookings` where `SNU_ID`='{roll_no}' and `Date`>={date}")
# print(cur.fetchall())
snu_id='ll656@snu.edu.in'
booking_id='RUBK79LXG'
date=datetime.today().strftime('%Y-%m-%d')
cur.execute(f"select * from `bookings` where `SNU_ID`='{snu_id}' and `Date`>={date} and `Confirm`='0'")
print(cur.fetchall())