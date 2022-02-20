import mysql.connector as sql
from datetime import datetime
from mysql.connector import errors
db=sql.connect(host='185.210.145.1',user='u724843278_ISC',password='ISCdatabase@1234',database='u724843278_ISC')
cur=db.cursor(dictionary=True)
cur.execute('select `Sports_Name` from `games`')
games=[x['Sports_Name'].replace(' ','_') for x in cur.fetchall()]
date=datetime.now().strftime('%Y-%m-%d')
if datetime.now()<datetime.strptime(datetime.now().strftime('%d-%m-%Y 09:30PM'), '%d-%m-%Y %I:%M%p') and datetime.now().strftime('%A')=='Sunday':
    pass
else:
    for i in games:
        day=datetime.now().strftime('%A')
        cur.execute(f"select `Slots` from {i}")
        slots=[x['Slots'] for x in cur.fetchall()][:-1]
        for x in slots:
            if datetime.strptime(x[x.find('-')+1:],'%I:%M%p')<datetime.strptime(datetime.now().strftime('%I:%M%p'),'%I:%M%p'):
                try:
                    cur.execute(f"insert into `blacklist` (`Student_Name`,`SNU_ID`,`Booking_ID`) select `Student_Name`,`SNU_ID`,`Booking_ID` from `bookings` where `Date`='{date}' and `Present`='0' and `Confirm`='1' and `Slot`='{x}' and `Game`='{i}'")
                    db.commit()
                except errors.IntegrityError:
                    pass
del i
cur.execute('select `SNU_ID` from `blacklist`')
blacklist=[i['SNU_ID'] for i in cur.fetchall()]
nowtime=datetime.now().strftime('%Y-%m-%d %H:%M:%S')
for i in blacklist:
    cur.execute(f"select exists(select * from `bookings` where `SNU_ID`='{i}' and `Date`>='{date}' and `Cancelled`='0') as booking")
    if bool(cur.fetchone()['booking']):
        cur.execute(f"update `bookings` set `Cancelled`='1', `Cancellation_Date`='{nowtime}',`Confirm`='0',`Present`='0' where `SNU_ID`='{i}' and `Date`>='{date}'")
        db.commit()