import mysql.connector as sql
from mysql.connector import errors
from datetime import datetime, timedelta, date
db=sql.connect(host='185.210.145.1',user='u724843278_ISC',password='ISCdatabase@1234',database='u724843278_ISC')
cur=db.cursor(dictionary=True)
start=date.today()-timedelta(days=date.today().weekday())
end=start+timedelta(days=6)
snu_id='tm217@snu.edu.in'
# cur.execute("select `Sports_Name`,`URL`,`Info` from `games` where `Enabled`='1' order by `Sports_Name`")
# print(cur.fetchall())
cur.execute(f"select `Max_Days` from `games` where `Sports_Name`='Badminton'")
# cur.execute(f"SELECT count(*) AS 'Booking_Num',`bookings`.`Game`,`games`.`Max_Days` FROM `bookings` LEFT OUTER JOIN `games` ON `bookings`.`Game`=`games`.`Sports_Name` where `bookings`.`Date`>='{start}' and `bookings`.`Date`<='{end}' and `bookings`.`SNU_ID`='{snu_id}' and `bookings`.`Game`='Football' and `bookings`.`Confirm`='1'")
print(cur.fetchall())
# try:
#     cur.execute("update `Badminton` set `Monday`=`Monday`-17 where `Slots`='6:30am-7:30am'")
#     db.commit()
# except errors.DataError:
#     print('lol')
for i in range(5):
    for j in range(5):
        print(i)
        break
    else:
        print(i)