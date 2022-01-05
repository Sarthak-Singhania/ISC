import pymongo
client=pymongo.MongoClient("mongodb+srv://sarthak_singhania:databaseforisc@isc.p6whh.mongodb.net/Games?retryWrites=true&w=majority")
# col=client['Games']['games']
col=client['Booking']['booking']
x=col.find()
slots={}
col.update_one({
    'sports_name':'Gym'
    },
    {
     '$set':{
         'slots.$.Monday.6am-7am.availabity':19
         }
     }
    )
# for i in x:
#     d={}
#     for z in i['slots']:
#         d2={}
#         for j in i['slots'][z]:
#             if i['slots'][z][j]['availabity']>0:
#                 d2[j]='active'
#             else:
#                 d2[j]='full'
#         d[z]=d2
#     slots[i['sports_name']]=d

# {'Badminton':{
#     '30/12/2021':{
#         '4pm-5pm':{
#             'Availability':20,
#             'Data':{
#                 's_name':'roll_no'
#                 }
#             }
#         }
#     }
# }