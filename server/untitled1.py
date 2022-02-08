from flask import Flask, request,make_response
app=Flask(__name__)

@app.route('/hello')
def hello():
    return make_response({'message':request.args.get('list').split(',')})

if __name__=='__main__':
    app.run(debug=True)