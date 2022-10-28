from flask import Flask, request, make_response
from flask_cors import CORS, cross_origin
from flask_mysqldb import MySQL
from flask_limiter import Limiter, util
from datetime import datetime, timedelta
from firebase_admin import auth, credentials
from functools import wraps
from MySQLdb import OperationalError
import MySQLdb.cursors as cur
import pandas as pd
import firebase_admin
import secrets
import string
import checking
#import isc_email

application = app = Flask(__name__)
cors = CORS(app)

limiter = Limiter(
    application,
    key_func=util.get_remote_address,
    default_limits=["200 per day", "50 per hour"],
    storage_uri="memory://"
)

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
            return make_response({'message': 'token is invalid'}), 403
        return f(*args, **kwargs)

    return decorated

@app.get('/')
def home():
    return make_response({'meesage':'welcome'}),200


@app.get('/games')
def games():
    cursor = mysql.connection.cursor(cur.DictCursor)
    if request.headers['admin-header'].title()=='Yes':
        cursor.execute("select `Sports_Name`,`URL`,`Enabled`,`Info` from `games` order by `Sports_Name`")
        sports = [{'game':i['Sports_Name'],'url':i['URL'],'isEnabled':bool(i['Enabled']),'info':i['Info'].split('\\n')} for i in cursor.fetchall()]
        return make_response({'message':sports}), 200
    else:
        cursor.execute("select `Sports_Name`,`URL`,`Info` from `games` where `Enabled`='1' order by `Sports_Name`")
        sports = [{'game':i['Sports_Name'],'url':i['URL'],'info':i['Info'].split('\\n')} for i in cursor.fetchall()]
        return make_response({'message':sports}), 200


@app.get('/max-person')
def max_num():
    cursor = mysql.connection.cursor(cur.DictCursor)
    cursor.execute('select `Sports_Name`,`Max_Person` from games')
    num = {i['Sports_Name']: i['Max_Person'] for i in cursor.fetchall()}
    return num, 200


@app.get('/slots')
# @token_required
def slots():
    cursor = mysql.connection.cursor(cur.DictCursor)
    game = request.args.get('game').title().replace(' ', '_')
    if request.headers['admin-header'].title()=='Yes':
        cursor.execute(f'select * from `{game}`')
        a = cursor.fetchall()
        d = {i: {} for i in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']}
        isEnabled={i: False for i in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']}
        for i in d:
            for x in a[:-1]:
                d[i][x['Slots']] = x[i]
            isEnabled[i]=bool(a[-1][i])
        return make_response({request.args.get('game').title(): d,'isEnabled':isEnabled}), 200
    elif request.headers['admin-header'].title()=='No':
        if request.args.get('pos')=='1':
            cursor.execute(f"select `Max_Days` from `games` where `Sports_Name`='{game}'")
            max_days=cursor.fetchone()['Max_Days']
            cursor.execute(f"select * from `{game}` where `Slots`='Enabled'")
            isEnabled={i: False for i in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']}
            a=cursor.fetchone()
            for i in isEnabled:
                isEnabled[i]=bool(a[i])
            return make_response({'max_days':max_days,'isEnabled':isEnabled}), 200
        elif request.args.get('pos')=='2':
            days=request.args.get('days')[1:-1]
            arg=' and '.join([i+'!=0' for i in days.split(', ')])
            cursor.execute(f"select {days}, Slots from `{game}` where {arg}")
            a=cursor.fetchall()
            cursor.execute(f"select `Slot`,`Day` from `team_training` where `Game`='{request.args.get('game').title()}'")
            b={i['Day']:i['Slot'] for i in cursor.fetchall()}
            slots_user={i: {} for i in days.split(', ')}
            for i in slots_user:
                for x in a[:-1]:
                    if i.title() in b:
                        if x['Slots'] in b[i.title()]:
                            slots_user[i][x['Slots']+' (Team Training)']=0
                        else:
                            slots_user[i][x['Slots']] = x[i]
                    else:
                        slots_user[i][x['Slots']] = x[i]
            return make_response({request.args.get('game').title():slots_user}), 200
        else: make_response({'message':'invalid args'}),403
    else:
        make_response({'message':'invalid args'}),403


@app.post('/book')
@cross_origin()
#@token_required
def book():
    x=request.get_json()
    cursor = mysql.connection.cursor(cur.DictCursor)
    sports_name = x['sports_name'].title().replace(' ', '_')
    slot = x['slot']
    message={}
    check_all=checking.checking(x['Check'],sports_name,slot,x,cursor)
    if len(check_all)==0:
        cnt=0
        for i in x['Bookings']:
            cnt2=0
            booking_id = ''.join(secrets.choice(string.ascii_uppercase + string.digits) for i in range(9))
            cursor.execute(f"select exists(select * from `bookings` where `Booking_ID`='{booking_id}') as 'booking_id'")
            if bool(cursor.fetchone()['booking_id']): booking_id = ''.join(secrets.choice(string.ascii_uppercase + string.digits) for _ in range(9))
            date=datetime.strptime(i, '%Y-%m-%d')
            day=date.strftime('%A')
            for j in x['Bookings'][i]:
                # if len(checking(x['Check']))==0:
                try:
                    if cnt2 == 0:
                        cursor.execute(f"update `{sports_name}` set `{day}`=`{day}`-1 where `Slots`='{slot}'")
                        message[cnt]=booking_id
                        confirmed = 1
                        mysql.connection.commit()
                        # isc_email.email(str(x['Bookings'][i][j]),f"{sports_name} at ISC for {slot} slot",'Confirmed',str(j))
                    else: confirmed = 0
                    com = 'INSERT INTO bookings (`Student_Name`, `SNU_ID`, `Game`, `Date`, `Slot`, `Booking_ID`, `Confirm`) VALUES (%s,%s,%s,%s,%s,%s,%s)'
                    val = (
                        str(j), str(x['Bookings'][i][j]), str(sports_name), str(date), str(slot), str(booking_id), str(confirmed))
                    cursor.execute(com, val)
                    mysql.connection.commit()
                    cnt2 += 1
                except OperationalError:
                    message[cnt]='All slots have finished'
            cnt+=1
        return make_response({'message':message})
    else:
        return make_response({'errors':check_all})


@app.route('/get_bookings/<snu_id>', defaults={'booking_id': None})
@app.route('/get_bookings/<snu_id>/<booking_id>',methods=['GET'])
#@token_required
def get_bookings(snu_id, booking_id):
    cursor = mysql.connection.cursor(cur.DictCursor)
    date = datetime.now().strftime('%Y-%m-%d')
    if booking_id:
        cursor.execute(
            f"select `Game`,`Date`,`Slot`,`Student_Name`,`Confirm`,`SNU_ID` from `bookings` where `Booking_ID`='{booking_id}' and `Cancelled`='0'")
        a = cursor.fetchall()
        b = {'game': a[0]['Game'], 'date': str(a[0]['Date'].strftime('%d/%m/%Y')), 'slot': a[0]['Slot'], 'name': []}
        for i in a:
            if i['Confirm']:
                b['name'].append(i['Student_Name'])
                b['confirm'] = i['Confirm']
            if i['SNU_ID'][:len(snu_id)] == snu_id:
                b['confirm'] = i['Confirm']
        cursor.execute(f"select `Student_Name` from `bookings` where `Booking_ID`='{booking_id}' limit 1")
        a = cursor.fetchone()
        b['First_name'] = a['Student_Name']
        return b, 200
    else:
        cursor.execute(
            f"select `Student_Name`,`Booking_ID`,`Date`,`Slot`,`Game`,`Confirm`,`Present` from `bookings` where `SNU_ID`='{snu_id}' and `Date`>='{date}' and `Cancelled`='0'")
        bookings = cursor.fetchall()
        if len(bookings) > 0:
            for i in bookings:
                i['Date'] = str(i['Date'].strftime('%d/%m/%Y'))
                ids = i['Booking_ID']
                cursor.execute(
                    f"select count(`SNU_ID`) as num from bookings where `Booking_ID`='{ids}' and `Cancelled`='0'")
                i['Count'] = cursor.fetchone()['num']
            return make_response({'message': bookings}), 200
        else:
            return make_response({'message': []}), 200


@app.post('/confirm')
@cross_origin()
#@token_required
def confirm():
    x = request.get_json()
    snu_id = x['snu_id']
    booking_id = x['booking_id']
    cursor = mysql.connection.cursor(cur.DictCursor)
    cursor.execute(f"select * from bookings where `SNU_ID`='{snu_id}' and `Booking_ID`='{booking_id}'")
    det = cursor.fetchone()
    sports_name = det['Game']
    slot = det['Slot']
    day = det['Date'].strftime('%A')
    date=datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cursor.execute(f"select exists(select * from `bookings` where `SNU_ID`='{snu_id}' and `Date`='{det['Date']}' and `Cancelled`='0' and `Booking_ID`!='{booking_id}') as duplicate")
    duplicate=bool(cursor.fetchone()['duplicate'])
    cursor.execute(f"select exists(select * from `blacklist` where `SNU_ID`='{snu_id}') as blacklist")
    blacklist=bool(cursor.fetchone()['blacklist'])
    if not duplicate and not blacklist :
        try:
            cursor.execute(f"update `{sports_name}` set {day}={day}-1 where Slots='{slot}'")
            mysql.connection.commit()
            cursor.execute(f"update bookings set `Confirm`='1' where `SNU_ID`='{snu_id}' and `Booking_ID`='{booking_id}'")
            mysql.connection.commit()
            message='Booking confirmed'
        except OperationalError:
            cursor.execute(
                f"update bookings set `Confirm`='0', `Cancelled`='1', `Cancellation_Date`='{date}' where `SNU_ID`='{snu_id}' and `Booking_ID`='{booking_id}'")
            mysql.connection.commit()
            message='All slots have been filled, your booking has been cancelled'
    else:
        if blacklist:
            message='You have been blacklisted'
        elif duplicate:
            message='You are already have a booking for this day'
    # isc_email.email(x['snu_id'],f"{sports_name} at ISC for {slot} slot",'Confirmed','you')
    return make_response({'message':message}), 200


@app.post('/reject')
@cross_origin()
#@token_required
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


@app.post('/cancel')
@cross_origin()
#@token_required
def cancel():
    x = request.get_json()
    snu_id = x['snu_id']
    booking_id = x['booking_id']
    cursor = mysql.connection.cursor(cur.DictCursor)
    cursor.execute(f"select * from bookings where `SNU_ID`='{snu_id}' and `Booking_ID`='{booking_id}'")
    det = cursor.fetchone()
    sports_name = det['Game']
    slot = det['Slot']
    day = det['Date'].strftime('%A')
    date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    # if (datetime.strptime(slot[:slot.find('-')],'%I:%M%p')-timedelta(hours=1))>datetime.strptime(datetime.now().strftime('%I:%M%p'),'%I:%M%p') or det['Date']>datetime.date(datetime.now()):
    cursor.execute(
        f"update bookings set `Confirm`='0', `Cancelled`='1', `Cancellation_Date`='{date}' where `SNU_ID`='{snu_id}' and `Booking_ID`='{booking_id}'")
    mysql.connection.commit()
    cursor.execute(f"update `{sports_name}` set {day}={day}+1 where Slots='{slot}'")
    mysql.connection.commit()
    return make_response({'message':'Your booking has been cancelled.'})
    # else:
        # return make_response({'message':'Booking can be cancelled only till 1 hour before the slot.'})
    # isc_email.email(x['snu_id'],f"{sports_name} at ISC for {slot} slot",'Cancelled','you')
    


@app.get('/pending/<snu_id>')
#@token_required
def pending(snu_id):
    cursor = mysql.connection.cursor(cur.DictCursor)
    date = datetime.today().strftime('%Y-%m-%d')
    cursor.execute(
        f"select `Booking_ID`,`Student_Name`,`Game` from `bookings` where `SNU_ID`='{snu_id}' and `Date`>='{date}' and `Confirm`='0' and `Cancelled`=0")
    l1 = cursor.fetchall()
    for i in l1:
        cursor.execute(f"select `Student_Name` from `bookings` where `Booking_ID`='{i['Booking_ID']}' limit 1")
        a = cursor.fetchone()
        i['First_name'] = a['Student_Name']
    return make_response({'message': l1})


@app.get('/admin-bookings/<game>/<date>/<slot>')
#@token_required
def admin_bookings(game, date, slot):
    if request.headers['admin-header'].title()=='Yes':
        cursor = mysql.connection.cursor(cur.DictCursor)
        booking_date = datetime.strptime(date, '%d-%m-%Y').strftime('%Y-%m-%d')
        day=datetime.strptime(date, '%d-%m-%Y').strftime('%A')
        cursor.execute(
            f"select `Student_Name`,`SNU_ID`,`Booking_ID` from `bookings` where `Game`='{game.title().replace(' ','_')}' and `Slot`='{slot}' and `Date`='{booking_date}' and `Confirm`='1'")
        bookings = cursor.fetchall()
        enabled=True
        if len(bookings)==0:
            cursor.execute(f"select `{day}` from `{game.title().replace(' ','_')}` where `Slots`='{slot}'")
            if cursor.fetchone()[day]==0:
                enabled=False
        return make_response({'message': bookings,'isEnabled':enabled})
    else:
        return make_response({'message': 'You cannot access since you are not an admin'}), 403


@app.post('/stop')
#@token_required
def stop():
    x=request.get_json()
    cursor = mysql.connection.cursor(cur.DictCursor)
    today=datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    if request.headers['admin-header'].title()=='Yes':
        if x['category']=='game':
            game=x['game']
            date=datetime.now().strftime('%Y-%m-%d')
            cursor.execute(f"update `games` set `Enabled`='0' where `Sports_Name`='{x['game'].title()}'")
            mysql.connection.commit()
            cursor.execute(f"update `bookings` set `Cancelled`=1, `Cancellation_Date`='{today}', `Confirm`=0 where `Game`='{game}' and `Date`>='{date}'")
            mysql.connection.commit()
            cursor.execute(f"update `{game.title().replace(' ','_')}` set `Monday`='0',`Tuesday`='0',`Wednesday`='0',`Thursday`='0',`Friday`='0',`Saturday`='0',`Sunday`='0'")
            mysql.connection.commit()
            print('band ho gaya game',x)
            return make_response({'message':f'booking stopped for {x["game"].title()}'})
        elif x['category']=='date':
            game=x['game'].title().replace(' ','_')
            day=datetime.strptime(x['date'], '%d-%m-%Y').strftime('%A')
            date=datetime.strptime(x['date'], '%d-%m-%Y').strftime('%Y-%m-%d')
            cursor.execute(f"update `{game}` set `{day}`='0'")
            mysql.connection.commit()
            cursor.execute(f"update `bookings` set `Cancelled`=1, `Cancellation_Date`='{today}', `Confirm`=0 where `Game`='{game}' and `Date`='{date}'")
            mysql.connection.commit()
            cursor.execute(f"update `{game}` set `{day}`='0' where `Slots`='Enabled'")
            mysql.connection.commit()
            print('band ho gaya date',x)
            return make_response({'message':f'booking stopped for {x["game"].title()} for the day {x["date"]}'})
        elif x['category']=='slot':
            game=x['game'].title().replace(' ','_')
            day=datetime.strptime(x['date'], '%d-%m-%Y').strftime('%A')
            print(day)
            slot=x['slot'].lower()
            date=datetime.strptime(x['date'], '%d-%m-%Y').strftime('%Y-%m-%d')
            cursor.execute(f"update `{game}` set `{day}`='0' where `Slots`='{slot}'")
            mysql.connection.commit()
            cursor.execute(f"update `bookings` set `Cancelled`=1, `Cancellation_Date`='{today}', `Confirm`=0 where `Game`='{game}' and `Date`='{date}' and `Slot`='{slot}'")
            mysql.connection.commit()
            print('band ho gaya slot',x)
            return make_response({'message':f'booking stopped for {x["game"].title()} for the day {x["date"]} for {slot} slot'})
    else:
        return make_response({'message': 'You cannot access since you are not an admin'}), 403


@app.post('/unstop')
#@token_required
def unstop():
    x=request.get_json()
    cursor = mysql.connection.cursor(cur.DictCursor)
    if request.headers['admin-header'].title()=='Yes':
        if x['category']=='game':
            game=x['game'].title().replace(' ','_')
            cursor.execute(f"update `games` set `Enabled`='1' where `Sports_Name`='{x['game'].title()}'")
            mysql.connection.commit()
            cursor.execute(f"select `Capacity` from `games` where `Sports_Name`='{x['game'].title()}'")
            a=cursor.fetchone()['Capacity']
            cursor.execute(f"update `{game.title().replace(' ','_')}` set `Monday`='{a}',`Tuesday`='{a}',`Wednesday`='{a}',`Thursday`='{a}',`Friday`='{a}',`Saturday`='{a}',`Sunday`='{a}'")
            mysql.connection.commit()
            cursor.execute(f"update `{game.title().replace(' ','_')}` set `Monday`='1',`Tuesday`='1',`Wednesday`='1',`Thursday`='1',`Friday`='1',`Saturday`='1',`Sunday`='1' where `Slots`='Enabled'")
            mysql.connection.commit()
            print('chaloo ho gaya game',x)
            return make_response({'message':f'booking started for {x["game"].title()}'})
        elif x['category']=='date':
            game=x['game'].title().replace(' ','_')
            day=datetime.strptime(x['date'], '%d-%m-%Y').strftime('%A')
            cursor.execute(f"select `Capacity` from `games` where `Sports_Name`='{game}'")
            a=cursor.fetchone()['Capacity']
            cursor.execute(f"update `{game}` set `{day}`='{a}'")
            mysql.connection.commit()
            cursor.execute(f"update `{game}` set `{day}`='1' where `Slots`='Enabled'")
            mysql.connection.commit()
            print('chaloo ho gaya date',x)
            return make_response({'message':f'booking started for {x["game"].title()} for the day {x["date"]}'})
        elif x['category']=='slot':
            game=x['game'].title().replace(' ','_')
            day=datetime.strptime(x['date'], '%d-%m-%Y').strftime('%A')
            slot=x['slot'].lower()
            cursor.execute(f"select `Capacity` from `games` where `Sports_Name`='{game}'")
            a=cursor.fetchone()['Capacity']
            cursor.execute(f"update `{game}` set `{day}`='{a}' where `Slots`='{slot}'")
            mysql.connection.commit()
            print('chaloo ho gaya slot',x)
            return make_response({'message':f'booking started for {x["game"].title()} for the day {x["date"]} for {slot} slot'})
    else:
        return make_response({'message': 'You cannot access since you are not an admin'}), 403


@app.get('/booking-count')
#@token_required
def booking_count():
    cursor = mysql.connection.cursor(cur.DictCursor)
    if request.args.get('category').lower()=='game':
        game=request.args.get('game').title().replace(' ','_')
        date=datetime.now().strftime('%Y-%m-%d')
        cursor.execute(f"select count(`SNU_ID`) as Num from `bookings` where `Date`>='{date}' and `Game`='{game}' and `Confirm`=1")
        return make_response({'message':str(cursor.fetchone()['Num'])})
    elif request.args.get('category').lower()=='date':
        game=request.args.get('game').title().replace(' ','_')
        date=datetime.strptime(request.args.get('date'),'%d-%m-%Y').strftime('%Y-%m-%d')
        cursor.execute(f"select count(`SNU_ID`) as Num from `bookings` where `Game`='{game}' and `Date`='{date}'")
        return make_response({'message':str(cursor.fetchone()['Num'])})
    elif request.args.get('category').lower()=='slot':
        game=request.args.get('game').title().replace(' ','_')
        date=datetime.strptime(request.args.get('date'),'%d-%m-%Y').strftime('%Y-%m-%d')
        slot=request.args.get('slot')
        cursor.execute(f"select count(`SNU_ID`) as Num from `bookings` where `Game`='{game}' and `Date`='{date}' and `Slot`='{slot}'")
        return make_response({'message':str(cursor.fetchone()['Num'])})


@app.post('/present')
#@token_required
def present():
    cursor=mysql.connection.cursor(cur.DictCursor)
    x=request.get_json()
    cursor.execute(f"update `bookings` set `Present`='1' where `SNU_ID`='{x['snu_id']}' and `Booking_ID`='{x['booking_id']}'")
    mysql.connection.commit()
    cursor.execute(f"select exists(select * from blacklist where `SNU_ID`='{x['snu_id']}' and `Booking_ID`='{x['booking_id']}') as bool")
    if cursor.fetone()['bool']:
        cursor.execute(f"delete from `blacklist` where `SNU_ID`='{x['snu_id']}'")
    return make_response({'message':f"{x['name']} has been marked present"})


@app.post('/absent')
#@token_required
def absent():
    cursor=mysql.connection.cursor(cur.DictCursor)
    x=request.get_json()
    cursor.execute(f"update `bookings` set `Present`='0' where `SNU_ID`='{x['snu_id']}' and `Booking_ID`='{x['booking_id']}'")
    mysql.connection.commit()
    com="INSERT INTO `blacklist`(`Student_Name`, `SNU_ID`, `Date`, `Booking_ID`) VALUES (%s,%s,%s,%s)"
    val=(str(x['name']),str(x['snu_id']),str(datetime.now().strftime('%Y-%m-%d %H:%M:%S')),str(x['booking_id']))
    cursor.execute(com,val)
    mysql.connection.commit()
    return make_response({'message':f"{x['name']} has been marked absent"})


@app.route('/slot-capacity-change',methods=['GET','POST'])
#@token_required
def slot_capacity_change():
    cursor=mysql.connection.cursor(cur.DictCursor)
    if request.headers['admin-header'].title()=='Yes':
        if request.method=='GET':
            game=request.args.get('game').title().replace(' ','_')
            day=datetime.strptime(request.args.get('date',type=str),'%d-%m-%Y').strftime('%A')
            slot=request.args.get('slot')
            cursor.execute(f"select `{day}` as 'Capacity' from `{game}` where `Slots`='{slot}'")
            return make_response({'message':int(cursor.fetchone()['Capacity'])})
        elif request.method=='POST':
            x=request.get_json()
            game=x['game'].title().replace(' ','_')        
            day=datetime.strptime(x['date'],'%d-%m-%Y').strftime('%A')
            date=datetime.strptime(x['date'],'%d-%m-%Y').strftime('%Y-%m-%d')
            cursor.execute(f"select `Capacity` from `games` where `Sports_Name`='{x['game']}'")
            capacity=int(x['capacity'])
            slot=x['slot']
            cap=int(cursor.fetchone()['Capacity'])
            cursor.execute(f"select count(*) as num from `bookings` where `Game`='{game}' and `Date`='{date}' and `Slot`='{slot}' and `Confirm`='1'")
            bookingNum=cursor.fetchone()['num']
            if cap-bookingNum>=capacity:
                cursor.execute(f"update `{game}` set `{day}`='{capacity}' where `Slots`='{slot}'")
                mysql.connection.commit()
                message='Capacity changed'
            else:
                message=f'Entered number is greater than capacity, maximum capacity can be {cap}'
            return make_response({'message':message})
    else:
        return make_response({'message': 'You cannot access since you are not an admin'}), 403


@app.route('/team-training',methods=['POST','GET'])
#@token_required
def team_training():
    cursor=mysql.connection.cursor(cur.DictCursor)
    if request.method=='POST':
        x=request.get_json()
        if request.args.get('option').lower=='on':
            com='insert into team_training (`Game`,`Slot`,`Day`) values (%s,%s,%s)'
            val=(x['game'],x['slot'],x['day'])
            cursor.execute(com,val)
            mysql.connection.commit()
            return make_response({'message':'team training enabled'})
        elif request.args.get('option').lower=='off':
            cursor.execute(f"delete from `team_training` where `Game`='{x['game']}' and `Slot`='{x['slot']}' and `Day`='{x['day']}'")
            mysql.connection.commit()


@app.get('/time')
def time():
    return make_response({'resetHour':21,'resetDay':7,'resetMinute':30})


@app.get('/faq')
#@token_required
def faq():
    cursor=mysql.connection.cursor(cur.DictCursor)
    cursor.execute("select `Question`, `Answer` from faq")
    faqs={i['Question']:i['Answer'] for i in cursor.fetchall()}
    return make_response({'message':faqs})


@app.post('/download-data')
#@token_required
def download_data():
    cursor=mysql.connection.cursor(cur.DictCursor)
    if request.headers['admin-header'].title()=='Yes':
        x=request.get_json()
        start=datetime.strptime(x['start'],'%d-%m-%Y').strftime('%Y-%m-%d')
        end=datetime.strptime(x['end'],'%d-%m-%Y').strftime('%Y-%m-%d')
        date=datetime.now()
        if datetime.now()-timedelta(weeks=52)<=datetime.strptime(x['start'],'%d-%m-%Y'):
            cursor.execute(f"select * from `bookings` where `Date`>='{start}' and `Date`<'{end}'")
            df=pd.DataFrame(cur.fetchall())
            df=df.set_index('ID')
            df.to_excel(f'{date}.xlsx')
            return make_response({'message':'file sent on email'})
        else:
            return make_response({'message':'you have exceeded the date range'})
    else:
        return make_response({'message': 'You cannot access since you are not an admin'}), 403

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
