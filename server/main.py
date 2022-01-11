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
    cursor.execute('select `Sports_Name`,`URL` from `games` order by `Sports_Name`')
    sports={i['Sports_Name']:i['URL'] for i in cursor.fetchall()}
    if game:
        return sports[game.title()]
    else:
        return sports

@app.route('/max-person',methods=['GET'])
def max_num():
    cursor=mysql.connection.cursor(cur.DictCursor)
    cursor.execute('select `Sports_Name`,`Max_Person` from games')
    num={i['Sports_Name']:i['Max_Person'] for i in cursor.fetchall()}
    return num

@app.route('/slots/<game>',methods=['GET'])
def slots(game):
    cursor=mysql.connection.cursor(cur.DictCursor)
    slots={}
    aa={}
    game=game.title().replace(' ','_')
    for x in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']:
        cursor.execute(f"select * from `{game}`")
        d={}
        for i in cursor.fetchall():
            d[i['Slots']]=i[x]
        aa[x]=d
    slots[game]=aa
    return {game:slots[game]}

@app.route('/book',methods=['POST'])
@cross_origin()
def book():
    x=request.get_json()
    cursor=mysql.connection.cursor(cur.DictCursor)
    sports_name=x['sports_name'].title().replace(' ','_')
    slot=x['slot']
    day=pd.to_datetime(x['date'],dayfirst=True).day_name()
    cursor.execute('select Booking_ID from bookings')
    ids=[i['Booking_ID'] for i in cursor.fetchall()]
    booking_id=''.join(secrets.choice(string.ascii_uppercase + string.digits) for i in range(9))
    if booking_id in ids:
        booking_id=''.join(secrets.choice(string.ascii_uppercase + string.digits) for i in range(9))
    date=datetime.strptime(x['date'], "%d/%m/%Y").strftime("%Y-%m-%d")
    cnt=0
    cursor.execute(f"update {sports_name} set {day}={day}-1 where `Slots`='{slot}'")
    mysql.connection.commit()
    for i in x['student_details']:
        if cnt==0:
            confirm=1
        else:
            confirm=0
        com='INSERT INTO bookings (Student_Name, SNU_ID, Game, Date, Slot, Booking_ID, Confirm) VALUES (%s,%s,%s,%s,%s,%s,%s)'
        val=(str(i),str(x['student_details'][i]),str(sports_name),str(date),str(slot),str(booking_id),str(confirm))
        cursor.execute(com,val)
        mysql.connection.commit()
        cnt+=1
    return str(booking_id)

@app.route('/get_bookings/<snu_id>',defaults={'booking_id':None})
@app.route('/get_bookings/<snu_id>/<booking_id>',methods=['GET'])
def get_bookings(snu_id,booking_id):
    cursor=mysql.connection.cursor(cur.DictCursor)
    date=datetime.today().strftime('%Y-%m-%d')
    if booking_id:
        cursor.execute(f"select `Game`,`Date`,`Slot`,`Student_Name`,`Confirm`,`SNU_ID` from `bookings` where `Booking_ID`='{booking_id}' and `Cancelled`='0'")
        a=cursor.fetchall()
        if a[0]['Slot'][-2:].lower()=='pm':
            url='https://firebasestorage.googleapis.com/v0/b/snuisc.appspot.com/o/image%204.png?alt=media&token=454af3da-b739-4ad2-ba6f-ce86ad311496'
        else:
            url='https://firebasestorage.googleapis.com/v0/b/snuisc.appspot.com/o/image%201.png?alt=media&token=1514e4e1-6c9f-4f06-ba66-3185deeb97de'
        b={'game':a[0]['Game'],'date':str(a[0]['Date'].strftime('%d/%m/%Y')),'slot':a[0]['Slot'],'name':[],'url':url}
        for i in a:
            if i['Confirm']:
                b['name'].append(i['Student_Name'])
                b['confirm']=i['Confirm']
            if i['SNU_ID'][:len(snu_id)]==snu_id:            
                b['confirm']=i['Confirm']
        return b
    else:
        cursor.execute(f"select `Student_Name`,`Booking_ID`,`Date`,`Slot`,`Game`,`Confirm` from `bookings` where `SNU_ID`='{snu_id}' and `Date`>={date} and `Cancelled`='0'")
        bookings=cursor.fetchall()
        if len(bookings)>0:
            for i in bookings:
                i['Date']=str(i['Date'].strftime('%d/%m/%Y'))
                ids=i['Booking_ID']
                cursor.execute(f"select count(`SNU_ID`) as num from bookings where `Booking_ID`='{ids}' and `Cancelled`='0'")
                i['Count']=cursor.fetchall()[0]['num']
            return make_response({'status':'success', 'message':bookings})
        else:
            return make_response({'status':'success','message':[]})
    
@app.route('/confirm',methods=['POST'])
@cross_origin()
def confirm():
    x=request.get_json()
    snu_id=x['snu_id']
    booking_id=x['booking_id']
    cursor=mysql.connection.cursor(cur.DictCursor)
    cursor.execute(f"select * from bookings where `SNU_ID`='{snu_id}' and `Booking_ID`='{booking_id}'")
    det=cursor.fetchone()
    sports_name=det['Game']
    slot=det['Slot']
    day=pd.to_datetime(det['Date'],dayfirst=True).day_name()
    cursor.execute(f"update bookings set `Confirm`='1' where `SNU_ID`='{snu_id}' and `Booking_ID`='{booking_id}'")
    mysql.connection.commit()
    cursor.execute(f"update `{sports_name}` set {day}={day}-1 where Slots='{slot}'")
    mysql.connection.commit()
    return 'Booking confirmed'

@app.route('/reject',methods=['POST'])
@cross_origin()
def reject():
    x=request.get_json()
    snu_id=x['snu_id']
    booking_id=x['booking_id']
    date=datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cursor=mysql.connection.cursor(cur.DictCursor)
    cursor.execute(f"update bookings set `Confirm`='0', `Cancelled`='1', `Cancellation_Date`='{date}' where `SNU_ID`='{snu_id}' and `Booking_ID`='{booking_id}'")
    mysql.connection.commit()
    return 'Booking cancelled'

@app.route('/cancel',methods=['POST'])
@cross_origin()
def cancel():
    x=request.get_json()
    snu_id=x['snu_id']
    booking_id=x['booking_id']
    cursor=mysql.connection.cursor(cur.DictCursor)
    cursor.execute(f"select * from bookings where `SNU_ID`='{snu_id}' and `Booking_ID`='{booking_id}'")
    det=cursor.fetchone()
    sports_name=det['Game']
    slot=det['Slot']
    day=pd.to_datetime(det['Date'],dayfirst=True).day_name()
    date=datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cursor.execute(f"update bookings set `Confirm`='0', `Cancelled`='1', `Cancellation_Date`='{date}' where `SNU_ID`='{snu_id}' and `Booking_ID`='{booking_id}'")
    mysql.connection.commit()
    cursor.execute(f"update `{sports_name}` set {day}={day}+1 where Slots='{slot}'")
    mysql.connection.commit()
    return 'Booking cancelled'

@app.route('/pending/<snu_id>',methods=['GET'])
def pending(snu_id):
    cursor=mysql.connection.cursor(cur.DictCursor)
    date=datetime.today().strftime('%Y-%m-%d')
    cursor.execute(f"select `Booking_ID`,`Student_Name`,`Game`,`Date`,`Slot` from `bookings` where `SNU_ID`='{snu_id}' and `Date`>={date} and `Confirm`='0' and `Cancelled`=0")
    l1=cursor.fetchall()
    for i in l1:
        i['Date']=i['Date'].strftime('%d/%m/%Y')
        i['Slot']=i['Slot'][:i['Slot'].find('-')].upper()
    return make_response({'status':'success','message':l1})



if __name__=="__main__":
    app.run(debug=True)