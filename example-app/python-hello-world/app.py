from flask import Flask
app = Flask(__name__)

@app.route('/<int:number>/')
def incrementer(number):
    return "Incremented number is " + str(number+1)

@app.route('/<string:name>/')
def hello(name):
    return "Hello " + name

@app.route('/name2', methods=['POST','GET'])
def hello2():
    name2=os.getenv('NAME2', 'Guest')
    return f"Hello {name2}"

app.run()
