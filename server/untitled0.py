import mysql.connector as sql
from datetime import datetime, timedelta
from mysql.connector import IntegrityError
db=sql.connect(host='185.210.145.1',user='u724843278_ISC',password='ISCdatabase@1234',database='u724843278_ISC')
cur=db.cursor(dictionary=True)
# start=date.today()-timedelta(days=date.today().weekday())
# end=start+timedelta(days=6)
# snu_id='tm217@snu.edu.in'
# cur.execute("select `Sports_Name`,`URL`,`Info` from `games` where `Enabled`='1' order by `Sports_Name`")
# print(cur.fetchall())
# cur.execute("select exists(select * from `bookings` where `Game``SNU_ID`='ss878@snu.edu.in' and `Date`='2022-02-13' and `Cancelled`='0')")
# print(cur.fetchone())
# cur.execute(f"SELECT count(*) AS 'Booking_Num',`bookings`.`Game`,`games`.`Max_Days` FROM `bookings` LEFT OUTER JOIN `games` ON `bookings`.`Game`=`games`.`Sports_Name` where `bookings`.`Date`>='{start}' and `bookings`.`Date`<='{end}' and `bookings`.`SNU_ID`='{snu_id}' and `bookings`.`Game`='Football' and `bookings`.`Confirm`='1'")
# df=pd.DataFrame(cur.fetchall())
# df=df.set_index('ID')
# df.to_excel('d:/data.xlsx')
# date=datetime.now().strftime('%Y-%m-%d')
# try:
#     cur.execute("select * from `bookings` where `Date`={date} and `Confirm`=1 and `Present`=0 and `Slot`='7:30am-8:30am'")
#     print(cur.fetchall())
#     # cur.execute("insert into `blacklist` (`Student_Name`,`SNU_ID`,`Booking_ID`) select `Student_Name`,`SNU_ID`,`Booking_ID` from `bookings` where `Date`='2022-02-14' and `Present`=0 and `Confirm`=1")
#     # db.commit()
# except IntegrityError:
#     print('duplicate')
# if datetime.strptime(x[x.find('-')+1:],'%I:%M%p')<datetime.strptime(datetime.now().strftime('%I:%M%p'),'%I:%M%p'):
#     cur.execute(f"insert into `blacklist` (`Student_Name`,`SNU_ID`,`Booking_ID`) select `Student_Name`,`SNU_ID`,`Booking_ID` where `Slot`='{x}' and 'Date'='{date}' and `Present`='0' and `Confirm`='1'")
#     db.commit()
# date=datetime.date(datetime.now())
# cur.execute(f"select `Date` from `bookings` where `SNU_ID`='ss878@snu.edu.in' and `Date`>='{date}' and `Game`='Badminton' group by `Date`")
# dates=[i['Date'].strftime('%d-%m-%Y') for i in cur.fetchall()]
date=datetime.date(datetime.now())
# cur.execute(f"select * from `bookings` where `Date`='{date}'")
i='tm217@snu.edu.in'
sports_name='Badminton'
start_day=datetime.today()-timedelta(days=datetime.today().weekday())
start=(start_day).strftime('%Y-%m-%d')
end=(start_day+timedelta(days=6)).strftime('%Y-%m-%d')
# cur.execute(f"select `Date` from `bookings` where `SNU_ID`='{i}' and `Date`>='{date}' and `Game`='{sports_name}' and `Cancelled`='0' group by `Date`")
cur.execute(f"SELECT count(*) AS 'num',`games`.`Max_Days` FROM `bookings` JOIN `games` ON `bookings`.`Game`=`games`.`Sports_Name` where `bookings`.`Date`>='{start}' and `bookings`.`Date`<='{end}' and `bookings`.`SNU_ID`='{i}' and `bookings`.`Game`='{sports_name}' and `bookings`.`Confirm`='1'")
print(cur.fetchall())