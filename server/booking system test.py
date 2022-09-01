import mysql.connector as sql
from datetime import datetime, timedelta
from mysql.connector import OperationalError
import secrets
import string
db=sql.connect(host='68.183.244.199',user='u724843278_ISC',password='ISCdatabase@1234',database='u724843278_ISC')
cur=db.cursor(dictionary=True)
x={"sports_name":"Football","slot":"6:00pm-8:00pm","Bookings":{"2022-2-24":{"Tushar Mishra":"tm217@snu.edu.in","Sarthak Singhania":"ss878@snu.edu.in"}},"Check":{"tm217@snu.edu.in":["2022-2-24"],"ss878@snu.edu.in":["2022-2-24"]}}

sports_name = x['sports_name'].title().replace(' ', '_')
slot = x['slot']
message={}
# def checking(check):
if datetime.now().strftime('%A')=='Sunday' and datetime.strptime(datetime.now().strftime('%I:%M%p'),'%I:%M%p')>datetime.strptime('09:30pm','%I:%M%p'):
    start=(datetime.now()).strftime('%Y-%m-%d')
    end=(datetime.now()+timedelta(days=7)).strftime('%Y-%m-%d')
else:
    start_day=datetime.today()-timedelta(days=datetime.today().weekday())
    start=(start_day).strftime('%Y-%m-%d')
    end=(start_day+timedelta(days=6)).strftime('%Y-%m-%d')
errors={}
check=x['Check']
for i in check:
    date=datetime.date(datetime.now())
    cur.execute(f"select `Date` from `bookings` where `SNU_ID`='{i}' and `Date`>='{date}' and `Game`='{sports_name}' and `Cancelled`='0' group by `Date`")
    dates=[ll['Date'].strftime('%Y-%m-%d') for ll in cur.fetchall()]
    booked_dates=[ll for ll in check[i] if datetime.strptime(ll, '%Y-%m-%d').strftime('%Y-%m-%d') in dates]
    cur.execute(f"select exists(select * from `blacklist` where `SNU_ID`='{i}') as blacklist")
    blacklist=bool(cur.fetchone()['blacklist'])
    cur.execute(f"SELECT count(*) AS 'num',`games`.`Max_Days` FROM `bookings` JOIN `games` ON `bookings`.`Game`=`games`.`Sports_Name` where `bookings`.`Date`>='{start}' and `bookings`.`Date`<='{end}' and `bookings`.`SNU_ID`='{i}' and `bookings`.`Game`='{sports_name}' and `bookings`.`Cancelled`='0'")
    Booking_Num=cur.fetchone()
    if Booking_Num['Max_Days'] is None:
        cur.execute(f"select * from `games` where `Sports_Name`='{sports_name}'")
        Booking_Num['Max_Days']=int(cur.fetchone()['Max_Days'])
    print(booked_dates)
    for j in check[i]:
        day=datetime.strptime(j,'%Y-%m-%d').strftime('%A')
        cur.execute(f"select `{day}` from `{sports_name}` where `Slots`='{slot}'")
        slots_left=cur.fetchone()[day]
        if slots_left<len(x['Bookings'][j]):
            flag='finished'
            if flag not in errors:
                errors[flag]={i:[]}
            if i not in errors[flag]:
                errors[flag][i]=[]
            errors[flag][i].append(j)
    if booked_dates:
        flag='duplicate'
        if flag not in errors:
            errors[flag]={}
        errors[flag][i]=booked_dates
        # print(flag)
    elif blacklist:
        flag='blacklist'
        if flag not in errors:
            errors[flag]={}
        errors[flag][i]=check[i]
        # print(flag)
    elif (len(check[i])+Booking_Num['num'])>Booking_Num['Max_Days']:
        flag='exceeded'
        if flag not in errors:
            errors[flag]={}
        errors[flag][i]=check[i][len(check[i])-Booking_Num['num']:]
        # print(flag)
    else:
        pass
#     return errors
# check_all=checking(x['Check'])
# if len(check_all)==0:
#     for i in x['Bookings']:
#         cnt=0
#         booking_id = ''.join(secrets.choice(string.ascii_uppercase + string.digits) for i in range(9))
#         cur.execute(f"select exists(select * from `bookings` where `Booking_ID`='{booking_id}') as 'booking_id'")
#         if bool(cur.fetchone()['booking_id']): booking_id = ''.join(secrets.choice(string.ascii_uppercase + string.digits) for _ in range(9))
#         date=datetime.strptime(i, '%Y-%m-%d')
#         day=date.strftime('%A')
#         for j in x['Bookings'][i]:
#             # if len(checking(x['Check']))==0:
#             try:
#                 if cnt == 0:
#                     cur.execute(f"update `{sports_name}` set `{day}`=`{day}`-1 where `Slots`='{slot}'")
#                     message=booking_id
#                     flag='confirmed'
#                     confirmed = 1
#                     db.commit()
#                     # isc_email.email(str(x['Bookings'][i][j]),f"{sports_name} at ISC for {slot} slot",'Confirmed',str(j))
#                 else: confirmed = 0
#                 com = 'INSERT INTO bookings (`Student_Name`, `SNU_ID`, `Game`, `Date`, `Slot`, `Booking_ID`, `Confirm`) VALUES (%s,%s,%s,%s,%s,%s,%s)'
#                 val = (
#                     str(j), str(x['Bookings'][i][j]), str(sports_name), str(date), str(slot), str(booking_id), str(confirmed))
#                 cur.execute(com, val)
#                 db.commit()
#                 cnt += 1
#             except OperationalError:
#                 message[cnt]='All slots have finished'
#     return make_response({'message':message})
# else:
#     return make_response({'message':message, 'errors':errors})