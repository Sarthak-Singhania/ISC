import mysql.connector as sql
from datetime import datetime
from mysql.connector import errors
db=sql.connect(host='localhost',user='u724843278_ISC',password='ISCdatabase@1234',database='u724843278_ISC')
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
            if datetime.strptime(x[:x.find('-')],'%I:%M%p')<datetime.strptime(datetime.now().strftime('%I:%M%p'),'%I:%M%p'):
                cur.execute(f"update `{i}` set `{day}`='0' where `Slots`='{x}'")
                db.commit()