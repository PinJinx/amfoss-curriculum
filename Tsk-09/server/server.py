from flask import Flask,jsonify,request
import json,os


app = Flask(__name__)



@app.route("/validate",methods = ['POST'])
def CheckUser():
    f = open(os.curdir+'/users.json')
    data = json.load(f)
    result = request.get_json()
    for i in data['users']:
        if result['em'] == i['email'] and result['pass'] == i['password']:
            return jsonify({
                'user':i
                }),200
    else:
        return jsonify({
            'error':'Invalid Credentials'
            }),400




@app.route("/register",methods=['POST'])
def Register():
    f = open(os.curdir+'/users.json')
    data = json.load(f)
    result = request.get_json()
    for i in data['users']:
        if i['email'] == result['em'] and result['pass'] == i['password']:
            return jsonify({
                'error':'User Already Exist'
                }),400
    else:
        f.close()
        f = open(os.curdir+'/users.json',"w")
        data['users'].append({
            'name':result['name'],
            'email':result['em'],
            'password':result['pass'],
            'money':200
        })
        user={'name':result['name'],
            'email':result['em'],
            'password':result['pass'],
            'money':200
            }
        data['collection'][result['name']] = []
        json.dump(data,f)
        f.close()
        return jsonify({
                'user':user
                }),200




@app.route("/update",methods=['POST'])
def Updt():
    f = open(os.curdir+'/users.json')
    data = json.load(f)
    result = request.get_json()
    user={}
    for i in data['users']:
        if i['email'] == result['oldem']:
            i['email'] = result['em']
            i['name'] = result['name']
            i['password'] = result['pass']
            user=i
            break
    else:
        return jsonify({
            'error':'User Not Found'
        }),400
    f.close()
    f = open(os.curdir+'/users.json',"w")
    json.dump(data,f)
    f.close()
    return jsonify({
            'user': user
        }),200

@app.route("/collection",methods=['POST'])
def Collec():
    f = open(os.curdir+'/users.json')
    data = json.load(f)
    result = request.get_json()
    if data['collection'].get(result['name']) != None:
        return jsonify({
            'collection': data['collection'][result['name']]
        }),200

    else:
        return jsonify({
            'error':'User Not Found'
        }),400

@app.route("/trade",methods=['GET'])
def GetTrade():
    f = open(os.curdir+'/users.json')
    data = json.load(f)
    return jsonify({
        'trades': data['trade']
    }),200

@app.route("/sell",methods=['POST'])
def SellTrade():
    f = open(os.curdir+'/users.json')
    data = json.load(f)
    result = request.get_json()
    try:
        data['collection'][result['name']].remove(result['url'])
        print(result['url'])
        data['trade'].append(
            {
            "trader":result['name'],
            "price":str(result['price']),
            "url":result['url']
            }
        )
        for i in data['users']:
            if(i['name']==result['name']):#user
                i['money'] += int(result['price'])
                user=i
        f.close()
        with open(os.curdir+'/users.json',"w") as f:
            json.dump(data,f)
        return jsonify({
            'user': user
        }),200
    except Exception as e:
        return jsonify({
            'error': e
        }),400


@app.route('/store',methods=['POST'])
def DrawRandom():
    import random
    cards=[]
    f = open(os.curdir+'/store.json')
    data = json.load(f)
    result = request.get_json()
    user={}
    if(result['type']=='common'):
        for i in range(5):
            a = random.randint(1,100)
            if(a == 1):
                cards.append(data['legend'][random.randrange(len(data['legend']))])
            elif a ==3 or a == 2:
                cards.append(data['rare'][random.randrange(len(data['rare']))])
            else:
                cards.append(data['common'][random.randrange(len(data['common']))])
    elif(result['type']=='rare'):
        for i in range(5):
            a = random.randint(1,100)
            if(a >= 95):
                cards.append(data['legend'][random.randrange(len(data['legend']))])
            elif a >= 67:
                cards.append(data['rare'][random.randrange(len(data['rare']))])
            else:
                cards.append(data['common'][random.randrange(len(data['common']))])
    elif(result['type']=='legend'):
        for i in range(5):
            a = random.randint(1,100)
            if(a >= 72):
                cards.append(data['legend'][random.randrange(len(data['legend']))])
            elif a >= 22:
                cards.append(data['rare'][random.randrange(len(data['rare']))])
            else:
                cards.append(data['common'][random.randrange(len(data['common']))])
    else:
        return jsonify({
            'error': 'Not valid'
        }),400
    f.close()
    f = open(os.curdir+'/users.json')
    data = json.load(f)

    for i in data['users']:
        if(i['name']==result['user']):#user
            i['money'] -= int(result['price'])
            user=i
    data['collection'][result['user']].extend(cards)
    f.close()

    with open(os.curdir+'/users.json',"w") as f:
        json.dump(data,f)
    return jsonify({
        'cards':cards,
        'user':user
    }),200


@app.route("/buy",methods=['POST'])
def BuyTrade():
    f = open(os.curdir+'/users.json')
    data = json.load(f)
    result = request.get_json()
    try:
        user={}
        data['collection'][result['user']].append(result['url'])
        data['trade'].remove(
            {
            "trader":result['name'],
            "price":str(result['price']),
            "url":result['url']
            }
        )
        for i in data['users']:
            if(i['name']==result['user']):#user
                i['money'] -= int(result['price'])
                user=i
        f.close()
        with open(os.curdir+'/users.json',"w") as f:
            json.dump(data,f)
        return jsonify({
            'user': user
        }),200
    except Exception as e:
        return jsonify({
            'error': e
        }),400







if __name__ == "__main__":
    app.run(debug = True, port=8080)