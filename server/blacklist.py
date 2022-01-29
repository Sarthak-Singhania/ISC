import mysql.connector as sql
from datetime import datetime
db=sql.connect(host='185.210.145.1',user='u724843278_ISC',password='ISCdatabase@1234',database='u724843278_ISC')
cur=db.cursor(dictionary=True)
today=datetime.now().strftime('%Y-%m-%d %H:%M:%S')
slot=datetime.now().strftime('%H:00%p')
cur.execute(f"select `Student_Name`, `SNU_ID` from `bookings` where `Date`='{today}'")