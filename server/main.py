from flask import Flask, request, make_response
from flask_cors import CORS, cross_origin
from flask_mysqldb import MySQL
from datetime import datetime
from firebase_admin import auth, credentials
from functools import wraps
import MySQLdb.cursors as cur
import pandas as pd
import firebase_admin
import secrets
import string

app = Flask(__name__)
cors = CORS(app)

app.config['CORS_HEADERS'] = 'Content-Type'
app.config['MYSQL_HOST'] = '185.210.145.1'
app.config['MYSQL_USER'] = 'u724843278_ISC'
app.config['MYSQL_PASSWORD'] = 'ISCdatabase@1234'
app.config['MYSQL_DB'] = 'u724843278_ISC'
app.config['JSON_SORT_KEYS'] = False

mysql = MySQL(app)


def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        if 'x-access-token' in request.headers:
            token = request.headers['x-access-token']
        if not token:
            return make_response({'message': 'token is missing'}), 403
        try:
            if firebase_admin._apps:
                data=auth.verify_id_token(token)
            else:
                cred=credentials.Certificate("cred_singhania.json")
                firebase_admin.initialize_app(cred)
                data=auth.verify_id_token(token)
        except:
            return make_response({'message': 'token in invalid'}), 403
        return f(*args, **kwargs)

    return decorated


@app.route('/games', defaults={'game': None})
@app.route('/games/<game>', methods=['GET'])
def games(game):
    cursor = mysql.connection.cursor(cur.DictCursor)
    cursor.execute("select `Sports_Name`,`URL` from `games` order by `Sports_Name` and `Enabled`='1'")
    sports = {i['Sports_Name']: i['URL'] for i in cursor.fetchall()}
    if game:
        return sports[game.title()]
    else:
        return sports


@app.route('/max-person', methods=['GET'])
def max_num():
    cursor = mysql.connection.cursor(cur.DictCursor)
    cursor.execute('select `Sports_Name`,`Max_Person` from games')
    num = {i['Sports_Name']: i['Max_Person'] for i in cursor.fetchall()}
    return num


@app.route('/slots/<game>', methods=['GET'])
@token_required
def slots(game):
    cursor = mysql.connection.cursor(cur.DictCursor)
    game = game.title().replace(' ', '_')
    cursor.execute(f'select * from `{game}`')
    a = cursor.fetchall()
    d = {i: {} for i in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']}
    for i in d:
        for x in a:
            d[i][x['Slots']] = x[i]
    return make_response({game.replace('_',' '): d})


@app.route('/book', methods=['POST'])
@cross_origin()
@token_required
def book():
    x = request.get_json()
    cursor = mysql.connection.cursor(cur.DictCursor)
    sports_name = x['sports_name'].title().replace(' ', '_')
    slot = x['slot']
    day = pd.to_datetime(x['date'], dayfirst=True).day_name()
    cursor.execute('select Booking_ID from bookings')
    ids = [i['Booking_ID'] for i in cursor.fetchall()]
    booking_id = ''.join(secrets.choice(string.ascii_uppercase + string.digits) for i in range(9))
    if booking_id in ids:
        booking_id = ''.join(secrets.choice(string.ascii_uppercase + string.digits) for i in range(9))
    date = datetime.strptime(x['date'], "%d-%m-%Y").strftime("%Y-%m-%d")
    cnt = 0
    cursor.execute(f"update {sports_name} set {day}={day}-1 where `Slots`='{slot}'")
    mysql.connection.commit()
    for i in x['student_details']:
        if cnt == 0:
            confirm = 1
        else:
            confirm = 0
        com = 'INSERT INTO bookings (Student_Name, SNU_ID, Game, Date, Slot, Booking_ID, Confirm) VALUES (%s,%s,%s,%s,%s,%s,%s)'
        val = (
            str(i), str(x['student_details'][i]), str(sports_name), str(date), str(slot), str(booking_id), str(confirm))
        cursor.execute(com, val)
        mysql.connection.commit()
        cnt += 1
    return str(booking_id)


@app.route('/get_bookings/<snu_id>', defaults={'booking_id': None})
@app.route('/get_bookings/<snu_id>/<booking_id>', methods=['GET'])
@token_required
def get_bookings(snu_id, booking_id):
    cursor = mysql.connection.cursor(cur.DictCursor)
    date = datetime.today().strftime('%Y-%m-%d')
    if booking_id:
        cursor.execute(
            f"select `Game`,`Date`,`Slot`,`Student_Name`,`Confirm`,`SNU_ID` from `bookings` where `Booking_ID`='{booking_id}' and `Cancelled`='0'")
        a = cursor.fetchall()
        if a[0]['Slot'][-2:].lower() == 'pm':
            url = 'https://firebasestorage.googleapis.com/v0/b/snuisc.appspot.com/o/image%204.png?alt=media&token=454af3da-b739-4ad2-ba6f-ce86ad311496'
        else:
            url = 'https://firebasestorage.googleapis.com/v0/b/snuisc.appspot.com/o/image%201.png?alt=media&token=1514e4e1-6c9f-4f06-ba66-3185deeb97de'
        b = {'game': a[0]['Game'], 'date': str(a[0]['Date'].strftime('%d/%m/%Y')), 'slot': a[0]['Slot'], 'name': [],
             'url': url}
        for i in a:
            if i['Confirm']:
                b['name'].append(i['Student_Name'])
                b['confirm'] = i['Confirm']
            if i['SNU_ID'][:len(snu_id)] == snu_id:
                b['confirm'] = i['Confirm']
        return b
    else:
        cursor.execute(
            f"select `Student_Name`,`Booking_ID`,`Date`,`Slot`,`Game`,`Confirm` from `bookings` where `SNU_ID`='{snu_id}' and `Date`>={date} and `Cancelled`='0'")
        bookings = cursor.fetchall()
        if len(bookings) > 0:
            for i in bookings:
                i['Date'] = str(i['Date'].strftime('%d/%m/%Y'))
                ids = i['Booking_ID']
                cursor.execute(
                    f"select count(`SNU_ID`) as num from bookings where `Booking_ID`='{ids}' and `Cancelled`='0'")
                i['Count'] = cursor.fetchall()[0]['num']
            return make_response({'message': bookings})
        else:
            return make_response({'message': []})


@app.route('/confirm', methods=['POST'])
@cross_origin()
@token_required
def confirm():
    x = request.get_json()
    snu_id = x['snu_id']
    booking_id = x['booking_id']
    cursor = mysql.connection.cursor(cur.DictCursor)
    cursor.execute(f"select * from bookings where `SNU_ID`='{snu_id}' and `Booking_ID`='{booking_id}'")
    det = cursor.fetchone()
    sports_name = det['Game']
    slot = det['Slot']
    day = pd.to_datetime(det['Date'], dayfirst=True).day_name()
    cursor.execute(f"update bookings set `Confirm`='1' where `SNU_ID`='{snu_id}' and `Booking_ID`='{booking_id}'")
    mysql.connection.commit()
    cursor.execute(f"update `{sports_name}` set {day}={day}-1 where Slots='{slot}'")
    mysql.connection.commit()
    return 'Booking confirmed'


@app.route('/reject', methods=['POST'])
@cross_origin()
@token_required
def reject():
    x = request.get_json()
    snu_id = x['snu_id']
    booking_id = x['booking_id']
    date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cursor = mysql.connection.cursor(cur.DictCursor)
    cursor.execute(
        f"update bookings set `Confirm`='0', `Cancelled`='1', `Cancellation_Date`='{date}' where `SNU_ID`='{snu_id}' and `Booking_ID`='{booking_id}'")
    mysql.connection.commit()
    return 'Booking cancelled'


@app.route('/cancel', methods=['POST'])
@cross_origin()
@token_required
def cancel():
    x = request.get_json()
    snu_id = x['snu_id']
    booking_id = x['booking_id']
    cursor = mysql.connection.cursor(cur.DictCursor)
    cursor.execute(f"select * from bookings where `SNU_ID`='{snu_id}' and `Booking_ID`='{booking_id}'")
    det = cursor.fetchone()
    sports_name = det['Game']
    slot = det['Slot']
    day = pd.to_datetime(det['Date'], dayfirst=True).day_name()
    date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cursor.execute(
        f"update bookings set `Confirm`='0', `Cancelled`='1', `Cancellation_Date`='{date}' where `SNU_ID`='{snu_id}' and `Booking_ID`='{booking_id}'")
    mysql.connection.commit()
    cursor.execute(f"update `{sports_name}` set {day}={day}+1 where Slots='{slot}'")
    mysql.connection.commit()
    # if round((datetime.strptime(str(datetime.now().strftime('%Y-%m-%d'))+' '+slot[:slot.find('-')],'%Y-%m-%d %I:%M%p')-datetime.now()).total_seconds()/60)<60:
    #     cursor.execute(f"select `SNU_ID` from `Blacklist`")
    #     names=[i['SNU_ID'] for i in cursor.fetchall()]
    #     if snu_id in names:
    #         cursor.execute(f"update `Blacklist` set `Cancellation_Num`=`Cancellation_Num`+1 where `SNU_ID`='{snu_id}'")
    #     else:
    return 'Booking cancelled'


@app.route('/pending/<snu_id>', methods=['GET'])
@token_required
def pending(snu_id):
    cursor = mysql.connection.cursor(cur.DictCursor)
    date = datetime.today().strftime('%Y-%m-%d')
    cursor.execute(
        f"select `Booking_ID`,`Student_Name`,`Game` from `bookings` where `SNU_ID`='{snu_id}' and `Date`>={date} and `Confirm`='0' and `Cancelled`=0")
    l1 = cursor.fetchall()
    for i in l1:
        cursor.execute(f"select `Student_Name` from `bookings` where `Booking_ID`='{i['Booking_ID']}' limit 1")
        a = cursor.fetchone()
        i['First_name'] = a['Student_Name']
    return make_response({'message': l1})


@app.route('/admin-bookings/<game>/<date>/<slot>', methods=['GET'])
@token_required
def admin_bookings(game, date, slot):
    if request.headers['admin-header'].title()=='Yes':
        cursor = mysql.connection.cursor(cur.DictCursor)
        date = datetime.strptime(date, '%d-%m-%Y').strftime('%Y-%m-%d')
        cursor.execute(
            f"select `Student_Name`,`SNU_ID` from `bookings` where `Game`='{game.title().replace(' ','_')}' and `Slot`='{slot}' and `Date`='{date}' and `Confirm`='1'")
        bookings = cursor.fetchall()
        return make_response({'message': bookings})
    else:
        return make_response({'message': 'You cannot access since you are not an admin'}), 403


@app.route('/stop',methods=['POST'])
@token_required
def stop():
    x=request.get_json()
    cursor = mysql.connection.cursor(cur.DictCursor)
    if request.headers['admin-header'].title()=='Yes':
        if x['category']=='game':
            game=x['game'].title().replace(' ','_')
            cursor.execute(f"update `games` set `Enabled`='0' where `Sports_Name`='{game}' ")
            mysql.connection.commit()
            return make_response({'message':f'booking stopped for {game}'})
        elif x['category']=='date':
            game=x['game'].title().replace(' ','_')
            day=pd.to_datetime(x['date']).day_name()
            cursor.execute(f"update `{game}` set `{day}`='0'")
            mysql.connection.commit()
            return make_response({'message':f'booking stopped for {game} for the day {x["date"]}'})
        elif x['category']=='slot':
            game=x['game'].title().replace(' ','_')
            day=pd.to_datetime(x['date']).day_name()
            slot=x['slot'].lower()
            cursor.execute(f"update `{game}` set `{day}`='0' where `Slots`='{slot}'")
            mysql.connection.commit()
            return make_response({'message':f'booking stopped for {game} for the day {x["date"]} for {slot} slot'})
    else:
        return make_response({'message': 'You cannot access since you are not an admin'}), 403


@app.route('/unstop',methods=['POST'])
@token_required
def unstop():
    x=request.get_json()
    cursor = mysql.connection.cursor(cur.DictCursor)
    if request.headers['admin-header'].title()=='Yes':
        if x['category']=='game':
            game=x['game'].title().replace(' ','_')
            cursor.execute(f"update `games` set `Enabled`='1' where `Sports_Name`='{game}' ")
            mysql.connection.commit()
            return make_response({'message':f'booking started for {game}'})
        elif x['category']=='date':
            game=x['game'].title().replace(' ','_')
            day=pd.to_datetime(x['date']).day_name()
            cursor.execute(f"select `Max_Person` from `games` where `Sports_Name`='{game}'")
            a=cursor.fetchone()['Max_Person']
            cursor.execute(f"update `{game}` set `{day}`='{a}'")
            mysql.connection.commit()
            return make_response({'message':f'booking started for {game} for the day {x["date"]}'})
        elif x['category']=='slot':
            game=x['game'].title().replace(' ','_')
            day=pd.to_datetime(x['date']).day_name()
            slot=x['slot'].lower()
            cursor.execute(f"select `Max_Person` from `games` where `Sports_Name`='{game}'")
            a=cursor.fetchone()['Max_Person']
            cursor.execute(f"update `{game}` set `{day}`='{a}' where `Slots`='{slot}'")
            mysql.connection.commit()
            return make_response({'message':f'booking started for {game} for the day {x["date"]} for {slot} slot'})
    else:
        return make_response({'message': 'You cannot access since you are not an admin'}), 403

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080, debug=True)
