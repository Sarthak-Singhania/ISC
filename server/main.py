from flask import Flask, request, make_response
from flask_cors import CORS, cross_origin
from flask_mysqldb import MySQL
from datetime import datetime
import MySQLdb.cursors as cur
import pandas as pd
import secrets
import string

app=Flask(__name__)
cors=CORS(app)

app.config['CORS_HEADERS']='Content-Type'
app.config['MYSQL_HOST']='185.210.145.1'
app.config['MYSQL_USER']='u724843278_ISC'
app.config['MYSQL_PASSWORD']='ISCdatabase@1234'
app.config['MYSQL_DB']='u724843278_ISC'
app.config['JSON_SORT_KEYS'] = False

mysql=MySQL(app)

@app.route('/games',defaults={'game':None})
@app.route('/games/<game>',methods=['GET'])
def games(game):
    cursor=mysql.connection.cursor(cur.DictCursor)
    cursor.execute('select * from `games` order by `Sports_Name`')
    sports={i['Sports_Name']:i['URL'] for i in cursor.fetchall()}
    if game:
        return sports[game.title()]
    else:
        return sports

@app.route('/max-person',methods=['GET'])
def max_num():
    cursor=mysql.connection.cursor(cur.DictCursor)
    cursor.execute('select * from games')
    num={i['Sports_Name']:i['Max_Person'] for i in cursor.fetchall()}
    return num

@app.route('/slots',defaults={'game':None})
@app.route('/slots/<game>',methods=['GET'])
def slots(game):
    cursor=mysql.connection.cursor(cur.DictCursor)
    cursor.execute('select sports_name from games')
    games=[i['sports_name'].replace(' ','_') for i in cursor.fetchall()]
    slots={}
    for j in games:
        aa={}
        for x in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']:
            cursor.execute(f'select * from {j}')
            d={}
            for i in cursor.fetchall():
                d[i['Slots']]=i[x]
            aa[x]=d
        slots[j.replace('_',' ')]=aa
    if game:
        return {game.title():slots[game.title()]}
    else:
        return slots

@app.route('/book',methods=['POST'])
@cross_origin()
def book():
    x=request.get_json()
    cursor=mysql.connection.cursor(cur.DictCursor)
    sports_name=x['sports_name'].title().replace(' ','_')
    slot=x['slot']
    day=pd.Timestamp(x['date']).day_name()
    cursor.execute('select Booking_ID from bookings')
    ids=[i['Booking_ID'] for i in cursor.fetchall()]
    booking_id=''.join(secrets.choice(string.ascii_uppercase + string.digits) for i in range(9))
    if booking_id in ids:
        booking_id=''.join(secrets.choice(string.ascii_uppercase + string.digits) for i in range(9))
    date=datetime.strptime(x['date'], "%d/%m/%Y").strftime("%Y-%m-%d")
    for i in x['student_details']:
        com='INSERT INTO bookings (Student_Name, SNU_ID, Game, Date, Slot, Booking_ID) VALUES (%s,%s,%s,%s,%s,%s)'
        val=(str(i),str(x['student_details'][i]),str(sports_name),str(date),str(slot),str(booking_id))
        cursor.execute(com,val)
        mysql.connection.commit()
    num=len(x['student_details'])
    cursor.execute(f"update `{sports_name}` set {day}={day}-{num} where Slots='{slot}'")
    mysql.connection.commit()
    return str(booking_id)

@app.route('/get_bookings/<snu_id>',methods=['GET'])
def get_bookings(snu_id):
    cursor=mysql.connection.cursor(cur.DictCursor)
    date=datetime.today().strftime('%Y-%m-%d')
    cursor.execute(f"select * from `bookings` where `SNU_ID`='{snu_id}' and `Date`>={date}")
    bookings=[i for i in cursor.fetchall()]
    if len(cursor.fetchall())<0:
        return ''
    else:
        return make_response({'status':'success', 'message':bookings})

# @app.route('/cancel',methods=['POST'])
# def cancel(booking_id):
    

if __name__=="__main__":
    app.run(debug=True)