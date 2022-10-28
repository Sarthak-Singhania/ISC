from datetime import datetime, timedelta
# import mysql.connector as sql
# db=sql.connect(host='185.210.145.1',user='u724843278_ISC',password='ISCdatabase@1234',database='u724843278_ISC')
# cur=db.cursor(dictionary=True)

def checking(check,sports_name,slot,x,cur):
    if datetime.now().strftime('%A')=='Sunday' and datetime.strptime(datetime.now().strftime('%I:%M%p'),'%I:%M%p')>datetime.strptime('09:30pm','%I:%M%p'):
        start=(datetime.now()).strftime('%Y-%m-%d')
        end=(datetime.now()+timedelta(days=7)).strftime('%Y-%m-%d')
    else:
        start_day=datetime.today()-timedelta(days=datetime.today().weekday())
        start=(start_day).strftime('%Y-%m-%d')
        end=(start_day+timedelta(days=6)).strftime('%Y-%m-%d')
    errors={}
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
    return errors