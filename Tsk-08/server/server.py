from flask import Flask, jsonify, request
from flask_cors import CORS
import json,os

app = Flask(__name__)
CORS(app)

users = {
    0:{
        'em': 'test@g.com',
        'pass': 'test',
        'name':'Test User',
        'watchls':[2]
    },
    1:{
        'em': 'test2@g.com',
        'pass': 'test2',
        'name':'Test User2',
        'watchls':[]
    }
}



@app.route('/upduser',methods=['POST'])
def ApplyChanges():
    nwuser=request.get_json()
    try:
        users[nwuser['id']]={'em':nwuser['em'],'pass':nwuser['pass'],'name':nwuser['name']}
        return jsonify({'sucess':'User updated'}),201
    except Exception:
        return jsonify({'error':Exception}),400


@app.route('/setwatchls',methods=['POST'])
def SetWatchList():
    ls = request.get_json()
    l=ls['list'].split(',')
    l2=[]
    for i in l:
        l2.append(int(i))
    users[int(ls['id'])]['watchls'] = l2
    return 'Sucess',201


@app.route('/watchls',methods=['POST'])
def UpdateWatchList():
    ls = request.get_json()
    if users[int(ls['id'])]['watchls'].count(int(ls['movie'])) == 0:
        if(not bool(ls['search'])):
            users[int(ls['id'])]['watchls'].append(ls['movie'])
            return jsonify({'mode':True}),201
        return jsonify({'mode':False}),201

    else:
        if(not bool(ls['search'])):
            users[int(ls['id'])]['watchls'].remove(int(ls['movie']))
            return jsonify({'mode':False}),201
        return jsonify({'mode':True}),201


@app.route('/comm', methods=['POST'])
def comm():
    data = request.get_json()
    file_path = os.path.join(os.getcwd(), 'server', 'Flist.json')
    try:
        with open(file_path, 'r') as path:
            file = json.load(path)
        for i in file['movies']:
            if i['id'] == int(data['movie']):
                i['comments'].append(data['comm'])

        with open(file_path, 'w') as f:
            json.dump(file, f, indent=2)

        return jsonify({'Success': 'Updated'}), 201

    except Exception as e:
        return jsonify({'error': f'{e}'}), 400


@app.route('/movies',methods=['GET'])
def ShowMov():
    f=open(os.getcwd()+'/server/Flist.json')
    return jsonify(json.load(f))


@app.route('/users',methods=['GET'])
def ShowUsers():
    users_with_str_keys = {str(key): value for key, value in users.items()}
    return jsonify(users_with_str_keys)



@app.route('/getuser', methods=['POST'])
def GetUser():
    nwuser=request.get_json()
    for i in users:
        if users[i]['em'] == nwuser['em'] and users[i]['pass']==nwuser['pass']:
            return jsonify({'id':i,'val':users[i]}),201
    else:
        return jsonify({'error':'User Not Found!'}),400





@app.route('/user', methods=['POST'])
def AddNewUser():
    user = request.get_json()
    if 'em' not in user or 'pass' not in user:
        return jsonify({'error': 'Invalid data'}), 400
    for i in users:
        if users[i]['em'] == user['em']:
            return jsonify({'error': 'User already exists'}), 400
        elif users[i]['name'] == user['name']:
            return jsonify({'error': 'Username already taken!'}), 400
    users[len(users)]={'em': user['em'], 'pass': user['pass'],'name':user['name']}
    return jsonify({'id':i,'val':users[i]}),201


if __name__ == '__main__':
    app.run(debug=True, port=8080)
