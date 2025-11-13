"""
Unit tests for the Flask demo application
"""
import pytest
import sys
import os

# Add the app directory to the path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app import app

@pytest.fixture
def client():
    """Create a test client for the Flask app"""
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_home_endpoint(client):
    """Test the home endpoint returns success"""
    response = client.get('/')
    assert response.status_code == 200
    json_data = response.get_json()
    assert json_data['status'] == 'success'
    assert 'Hello World' in json_data['message']

def test_health_endpoint(client):
    """Test the health endpoint"""
    response = client.get('/health')
    assert response.status_code == 200
    json_data = response.get_json()
    assert json_data['status'] == 'healthy'
    assert json_data['service'] == 'demo-app'

def test_info_endpoint(client):
    """Test the info endpoint"""
    response = client.get('/info')
    assert response.status_code == 200
    json_data = response.get_json()
    assert 'app' in json_data
    assert json_data['app'] == 'API Avengers Demo'

def test_invalid_endpoint(client):
    """Test that invalid endpoints return 404"""
    response = client.get('/invalid')
    assert response.status_code == 404
