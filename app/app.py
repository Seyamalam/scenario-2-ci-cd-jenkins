"""
Simple Flask Demo Application for CI/CD Pipeline
"""
from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        'message': 'Hello World! API Avengers CI/CD Pipeline Demo',
        'status': 'success',
        'version': '1.0.0'
    })

@app.route('/health')
def health():
    return jsonify({
        'status': 'healthy',
        'service': 'demo-app'
    }), 200

@app.route('/info')
def info():
    return jsonify({
        'app': 'API Avengers Demo',
        'environment': os.getenv('ENV', 'development'),
        'python_version': '3.9+'
    })

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)
