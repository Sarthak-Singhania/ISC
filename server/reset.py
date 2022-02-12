import mysql.connector as sql
db=sql.connect(host='185.210.145.1',user='u724843278_ISC',password='ISCdatabase@1234',database='u724843278_ISC')
cur=db.cursor(dictionary=True)
cur.execute('select `Sports_Name`,`Capacity` from `games`')
games={i['Sports_Name'].title().replace(' ','_'):i['Capacity'] for i in cur.fetchall()}
for i in games:
    cur.execute(f"update {i} set `Monday`='{games[i]}',`Tuesday`='{games[i]}',`Wednesday`='{games[i]}',`Thursday`='{games[i]}',`Friday`='{games[i]}',`Saturday`='{games[i]}',`Sunday`='{games[i]}'")
    db.commit()
    cur.execute(f"update {i} set `Monday`='1',`Tuesday`='1',`Wednesday`='1',`Thursday`='1',`Friday`='1',`Saturday`='1',`Sunday`='1' where `Slots`='Enabled'")
    db.commit()