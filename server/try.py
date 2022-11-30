import mysql.connector as sql
db=sql.connect(host='68.183.244.199',user='u724843278_ISC',password='ISCdatabase@1234',database='u724843278_ISC')
cur=db.cursor(dictionary=True)
cur.execute('select * from bookings')
bookings=cur.fetchall()
print(bookings)