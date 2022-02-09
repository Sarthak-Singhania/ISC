# import mysql.connector as sql
# from datetime import datetime
# db=sql.connect(host='185.210.145.1',user='u724843278_ISC',password='ISCdatabase@1234',database='u724843278_ISC')
# cur=db.cursor(dictionary=True)
# cur.execute("select `Sports_Name`,`URL`,`Info` from `games` where `Enabled`='1' order by `Sports_Name`")
# print(cur.fetchall())
import isc_email
isc_email.email('sarthak.singhania28@gmail.com',"Badminton as ISC for 10am slot",'Confirmed','user')