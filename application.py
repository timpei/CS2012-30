import os
import sqlite3
from flask import Flask, render_template, request, jsonify
import db

DATABASE = 'db/flashcard.db'

DEBUG = True
app = Flask(__name__)
app.config.from_object(__name__)

@app.route('/')
def login():
	return render_template('login.html')


if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)