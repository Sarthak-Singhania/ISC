import mysql.connector as sql
from datetime import datetime
db=sql.connect(host='185.210.145.1',user='u724843278_ISC',password='ISCdatabase@1234',database='u724843278_ISC')
cur=db.cursor(dictionary=True)
# cur.execute('select sports_name from games')
# games=[i['sports_name'].replace(' ','_') for i in cur.fetchall()]
# # for i in games:
# #     for j in slots:
# #         com=f'INSERT INTO {i} values(%s,%s,%s,%s,%s,%s,%s,%s)'
# #         val=(str(j),str(20),str(20),str(20),str(20),str(20),str(20),str(20))
# #         cur.execute(com,val)
# #         db.commit()
# com="update Badminton set Monday=%s where Slots=%s"
# val=(str(10),str('7am-8am'))
# num=6
# slot='6am-7am'
# cur.execute(f"update Badminton set Monday=Monday-{num} where Slots='{slot}'")
# db.commit()
date=datetime.today().strftime('%Y-%m-%d')
cur.execute(f'select * from `bookings` where `Roll_No`=2222 and `Date`>{date}')
bookings={}
for i in cur.fetchall():
    bookings[i['Student_Name']]=