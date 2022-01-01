from flask import Flask, request, jsonify
from flask_cors import CORS, cross_origin
import pymongo

client=pymongo.MongoClient("mongodb+srv://sarthak_singhania:databaseforisc@isc.p6whh.mongodb.net/Games?retryWrites=true&w=majority")
col_games=client['Games']['games']

app=Flask(__name__)
cors=CORS(app)

app.config['CORS_HEADERS']='Content-Type'

@app.route('/games',defaults={'game':None})
@app.route('/games/<game>',methods=['GET'])
def games(game):
    x=col_games.find()
    sports={}
    for i in x:
        sports[i['sports_name']]=i['image_url']
    if game:
        return sports[game.capitalize()]
    else:
        return sports

@app.route('/max-person',methods=['GET'])
def max_num():
    x=col_games.find()
    num={}
    for i in x:
        num[i['sports_name']]=i['max_person']
    return num

@app.route('/slots',defaults={'game':None})
@app.route('/slots/<game>',methods=['GET'])
def slots(game):
    x=col_games.find()
    slots={}
    for i in x:
        slots[i['sports_name']]=list(i['slots'].keys())
    if game:
        return {game:slots[game.capitalize()]}
    else:
        return slots

@app.route('/book',methods=['POST'])
@cross_origin()
def book():
    x=request.get_json()
    

if __name__=="__main__":
    app.run()