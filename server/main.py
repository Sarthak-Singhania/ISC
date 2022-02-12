from flask import Flask, request, make_response
from flask_cors import CORS, cross_origin
from flask_mysqldb import MySQL
from flask_limiter import Limiter, util
from datetime import datetime, timedelta
from firebase_admin import auth, credentials
from functools import wraps
import MySQLdb.cursors as cur
from mysql.connector import errors
import firebase_admin
import secrets
import string
import isc_email

application = app = Flask(__name__)
cors = CORS(app)

limiter = Limiter(
    application,
    key_func=util.get_remote_address,
    default_limits=["200 per day", "50 per hour"]
)

app.config['CORS_HEADERS'] = 'Content-Type'
app.config['MYSQL_HOST'] = '185.210.145.1'
app.config['MYSQL_USER'] = 'u724843278_ISC'
app.config['MYSQL_PASSWORD'] = 'ISCdatabase@1234'
app.config['MYSQL_DB'] = 'u724843278_ISC'
app.config['JSON_SORT_KEYS'] = False

mysql = MySQL(app)

day_number={'Monday':0,'Tuesday':1,'Wednesday':2,'Thursday':3,'Friday':4,'Saturday':5,'Sunday':6}

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


@app.get('/games')
def games():
    cursor = mysql.connection.cursor(cur.DictCursor)
    if request.headers['admin-header'].title()=='Yes':
        cursor.execute("select `Sports_Name`,`URL`,`Enabled`,`Info` from `games` order by `Sports_Name`")
        sports = [{'game':i['Sports_Name'],'url':i['URL'],'isEnabled':bool(i['Enabled']),'info':i['Info'].split('\\n')} for i in cursor.fetchall()]
        return make_response({'message':sports})
    else:
        cursor.execute("select `Sports_Name`,`URL`,`Info` from `games` where `Enabled`='1' order by `Sports_Name`")
        sports = [{'game':i['Sports_Name'],'url':i['URL'],'info':i['Info'].split('\\n')} for i in cursor.fetchall()]
        return make_response({'message':sports})


@app.get('/max-person')
def max_num():
    cursor = mysql.connection.cursor(cur.DictCursor)
    cursor.execute('select `Sports_Name`,`Max_Person` from games')
    num = {i['Sports_Name']: i['Max_Person'] for i in cursor.fetchall()}
    return num


@app.get('/slots')
@token_required
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
        return make_response({request.args.get('game').title(): d,'isEnabled':isEnabled})
    elif request.headers['admin-header'].title()=='No':
        if request.args.get('pos')=='1':
            cursor.execute(f"select `Max_Days` from `games` where `Sports_Name`='{game}'")
            max_days=cursor.fetchone()['Max_Days']
            cursor.execute(f"select * from `{game}` where `Slots`='Enabled'")
            isEnabled={i: False for i in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']}
            a=cursor.fetchone()
            for i in isEnabled:
                isEnabled[i]=bool(a[i])
            return make_response({'max_days':max_days,'isEnabled':isEnabled})
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
                        print(x)
                        if x['Slots'] in b[i.title()]:
                            slots_user[i][x['Slots']+' (Team Training)']=0
                        else:
                            slots_user[i][x['Slots']] = x[i]
                    else:
                        slots_user[i][x['Slots']] = x[i]
            return make_response({request.args.get('game').title():slots_user})
        else: make_response({'message':'invalid args'}),403
    else:
        make_response({'message':'invalid args'}),403
        


@app.post('/book')
@cross_origin()
@token_required
def book():
    x = request.get_json()
    cursor = mysql.connection.cursor(cur.DictCursor)
    sports_name = x['sports_name'].title().replace(' ', '_')
    slot = x['slot']
    cursor.execute('select `Booking_ID` from bookings')
    ids = [i['Booking_ID'] for i in cursor.fetchall()]
    cursor.execute("select `SNU_ID` from blacklist")
    blacklist=[i['SNU_ID'] for i in cursor.fetchall()]
    message={}
    start_day=datetime.today()-timedelta(days=datetime.today().weekday())
    start=(start_day).strftime('%Y-%m-%d')
    end=(start_day+timedelta(days=6)).strftime('%Y-%m-%d')
    for i in x['Bookings']:
        cnt=0
        day=i
        date=(datetime.now()+timedelta(day_number[day]-datetime.now().weekday())).strftime('%Y-%m-%d')
        cursor.execute(f"select `SNU_ID` from `bookings` where `Game`='{sports_name}' and `Date`='{date}' and `Cancelled`='0'")
        duplicate=[i['SNU_ID'] for i in cursor.fetchall()]
        booking_id = ''.join(secrets.choice(string.ascii_uppercase + string.digits) for i in range(9))
        if booking_id in ids: booking_id = ''.join(secrets.choice(string.ascii_uppercase + string.digits) for i in range(9))
        for j in x['Bookings'][i]:
            cursor.execute(f"SELECT count(*) AS 'Booking_Num',`games`.`Max_Days` FROM `bookings` JOIN `games` ON `bookings`.`Game`=`games`.`Sports_Name` where `bookings`.`Date`>='{start}' and `bookings`.`Date`<='{end}' and `bookings`.`SNU_ID`='{x['Bookings'][i][j]}' and `bookings`.`Game`='{sports_name}' and `bookings`.`Confirm`='1'")
            Booking_Num=cursor.fetchone()
            if Booking_Num['Max_Days'] is None:
                cursor.execute(f"select `Max_Days` from `games` where `Sports_Name`='{sports_name}'")
                Booking_Num['Max_Days']=int(cursor.fetchone()['Max_Days'])
            print(Booking_Num)
            if x['Bookings'][i][j] not in duplicate and x['Bookings'][i][j] not in blacklist and Booking_Num['Booking_Num']<Booking_Num['Max_Days']:
                try:
                    if cnt == 0:
                        cursor.execute(f"update `{sports_name}` set `{day}`=`{day}`-1 where `Slots`='{slot}'")
                        confirmed = 1
                        # isc_email.email(str(x['Bookings'][i][j]),f"{sports_name} at ISC for {slot} slot",'Confirmed',str(j))
                    else: confirmed = 0
                    com = 'INSERT INTO bookings (`Student_Name`, `SNU_ID`, `Game`, `Date`, `Slot`, `Booking_ID`, `Confirm`) VALUES (%s,%s,%s,%s,%s,%s,%s)'
                    val = (
                        str(j), str(x['Bookings'][i][j]), str(sports_name), str(date), str(slot), str(booking_id), str(confirmed))
                    cursor.execute(com, val)
                    mysql.connection.commit()
                    cnt += 1
                    if 'Confirmed' not in message:
                        message['Confirmed']=[]
                    message['Confirmed'].append(f'Confirmed for {day} and booking id is {booking_id}')
                    flag='confirmed'
                except errors.DataError:
                    flag='slots finished'
                    if flag not in message:
                        message[flag]={i:[]}
                    message[flag][i].append(f'student number {cnt}')
            else:
                flag=''
                if x['Bookings'][i][j] in blacklist:
                    flag='blacklist'
                elif Booking_Num['Booking_Num']==Booking_Num['Max_Days']:
                    flag=f"You have already booked for {Booking_Num['Max_Days']} days"
                else: flag='duplicate'
                if flag not in message:
                    message[flag]={i:[]}
                message[flag][i].append(f'student number {cnt}')
                break
    return make_response({'message':message,'status':flag})


@app.route('/get_bookings/<snu_id>', defaults={'booking_id': None})
@app.route('/get_bookings/<snu_id>/<booking_id>',methods=['GET'])
@token_required
def get_bookings(snu_id, booking_id):
    cursor = mysql.connection.cursor(cur.DictCursor)
    date = datetime.now().strftime('%Y-%m-%d')
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
        cursor.execute(f"select `Student_Name` from `bookings` where `Booking_ID`='{booking_id}' limit 1")
        a = cursor.fetchone()
        b['First_name'] = a['Student_Name']
        return b
    else:
        cursor.execute(
            f"select `Student_Name`,`Booking_ID`,`Date`,`Slot`,`Game`,`Confirm` from `bookings` where `SNU_ID`='{snu_id}' and `Date`>='{date}' and `Cancelled`='0'")
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


@app.post('/confirm')
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
    day = det['Date'].strftime('%A')
    cursor.execute(f"update bookings set `Confirm`='1' where `SNU_ID`='{snu_id}' and `Booking_ID`='{booking_id}'")
    mysql.connection.commit()
    try:
        cursor.execute(f"update `{sports_name}` set {day}={day}-1 where Slots='{slot}'")
        mysql.connection.commit()
    except errors.DataError:
        request.post('/cancel',json={'snu_id':snu_id,'booking_id':booking_id},headers={'x-access-token':request.headers['x-access-token']})
        return make_response({'message':'All slots have been filled your booking has been cancelled'})
    # isc_email.email(x['snu_id'],f"{sports_name} at ISC for {slot} slot",'Confirmed','you')
    return make_response({'message':'Booking confirmed'})


@app.post('/reject')
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


@app.post('/cancel')
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
    day = det['Date'].strftime('%A')
    date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cursor.execute(
        f"update bookings set `Confirm`='0', `Cancelled`='1', `Cancellation_Date`='{date}' where `SNU_ID`='{snu_id}' and `Booking_ID`='{booking_id}'")
    mysql.connection.commit()
    cursor.execute(f"update `{sports_name}` set {day}={day}+1 where Slots='{slot}'")
    mysql.connection.commit()
    # isc_email.email(x['snu_id'],f"{sports_name} at ISC for {slot} slot",'Cancelled','you')
    return 'Booking cancelled'


@app.get('/pending/<snu_id>')
@token_required
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
@token_required
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
@token_required
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
@token_required
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
@token_required
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
@token_required
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
@token_required
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
@token_required
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


# @app.methods('/team-training',methods=['POST','GET'])
# @token_required
# def team_training():
#     cursor=mysql.connection.cursor(cur.DictCursor)
#     if request.method=='POST':
#         x=request.get_json()
#         if request.args.get('option').lower=='on':
#             com='insert into team_training (`Game`,`Slot`,`Day`) values (%s,%s,%s)'
#             val=(x['game'],x['slot'],x['day'])
#             cursor.execute(com,val)
#             mysql.connection.commit()
#             return make_response({'message':'team training enabled'})
#         elif request.args.get('option').lower=='off':
#             cursor.execute(f"delete from `team_training` where `Game`='{x['game']}' and `Slot`='{x['slot']}' and `Day`='{x['day']}'")
#             mysql.connection.commit()


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080, debug=True)
