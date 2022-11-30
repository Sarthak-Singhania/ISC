import mysql.connector as sql
from datetime import datetime, timedelta
db=sql.connect(host='185.210.145.1',user='u724843278_ISC',password='ISCdatabase@1234',database='u724843278_ISC')
cur=db.cursor(dictionary=True)
date=(datetime.now()-timedelta(days=7)).strftime('%Y-%m-%d %H:%M:%S')
cur.execute(f"delete from `blacklist` where `Date`<='{date}'")
db.commit()