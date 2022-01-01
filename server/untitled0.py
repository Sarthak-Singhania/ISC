import pymongo
client=pymongo.MongoClient("mongodb+srv://sarthak_singhania:databaseforisc@isc.p6whh.mongodb.net/Games?retryWrites=true&w=majority")
col=client['Games']['games']
x=col.find()
slots={}

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