# API Avengers CI/CD Pipeline Demo

A complete CI/CD pipeline implementation for the API Avengers Preliminary Round showcasing automated build, test, package, deploy, and health-check stages.

## 📋 Project Overview

This project demonstrates a fully functional CI/CD pipeline that:
- ✅ Builds a Flask demo web application
- ✅ Runs automated unit tests
- ✅ Packages the app as a Docker image
- ✅ Deploys locally using Docker Compose
- ✅ Verifies application health with automated checks

## 🏗️ Architecture

```
┌─────────────┐     ┌──────────┐     ┌─────────┐     ┌──────────┐     ┌─────────────┐
│  Checkout   │ --> │  Build   │ --> │  Test   │ --> │ Package  │ --> │   Deploy    │
│   (SCM)     │     │  (pip)   │     │(pytest) │     │ (Docker) │     │  (Compose)  │
└─────────────┘     └──────────┘     └─────────┘     └──────────┘     └──────────────┘
                                                                              │
                                                                              v
                                                                      ┌──────────────┐
                                                                      │ Health Check │
                                                                      │   (Script)   │
                                                                      └──────────────┘
```

## 📂 Project Structure

```
.
├── app/
│   ├── app.py              # Flask application with health endpoint
│   ├── test_app.py         # Unit tests (pytest)
│   └── requirements.txt    # Python dependencies
├── Dockerfile              # Container image definition
├── docker-compose.yml      # Container orchestration
├── Jenkinsfile            # Declarative CI/CD pipeline
├── healthcheck.sh         # Health verification script
├── .dockerignore          # Docker build exclusions
├── .gitignore            # Git exclusions
└── README.md             # This file
```

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose installed
- Python 3.9+ (for local testing)
- Jenkins (optional, for running the pipeline)
- Git

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd <repo-name>
```

### 2. Test Locally (Without Jenkins)

#### Run the Application

```bash
# Install dependencies
cd app
pip install -r requirements.txt

# Run the app
python app.py
```

Visit `http://localhost:5000` to see the app running.

#### Run Tests

```bash
cd app
pytest test_app.py -v
```

#### Build and Deploy with Docker

```bash
# Build Docker image
docker build -t api-avengers-demo:latest -f Dockerfile ./app

# Deploy with Docker Compose
docker-compose up -d

# Check health
chmod +x healthcheck.sh
./healthcheck.sh
```

## 🔄 Jenkins Pipeline

### Pipeline Stages

1. **Checkout**: Clone the source code from SCM
2. **Build**: Install Python dependencies
3. **Test**: Run unit tests with pytest
4. **Package**: Build Docker image
5. **Deploy**: Deploy container with Docker Compose
6. **Health Check**: Verify application is running and healthy

### Running the Pipeline

1. Install Jenkins (see bonus section below)
2. Create a new Pipeline job
3. Point to this repository
4. Jenkins will automatically detect the `Jenkinsfile`
5. Run the pipeline

### Expected Output

```
Stage View:
[Checkout] ✓ --> [Build] ✓ --> [Test] ✓ --> [Package] ✓ --> [Deploy] ✓ --> [Health Check] ✓

Console Output:
=== Stage 1: Checking out code ===
=== Stage 2: Building application ===
=== Stage 3: Running unit tests ===
=== Stage 4: Building Docker image ===
=== Stage 5: Deploying with Docker Compose ===
=== Stage 6: Verifying application health ===

✓ ALL HEALTH CHECKS PASSED
Application is healthy and ready to serve requests!
```

## 🔍 Application Endpoints

- `GET /` - Home endpoint (Hello World message)
- `GET /health` - Health check endpoint (returns healthy status)
- `GET /info` - Application information

### Example Responses

**Health Endpoint:**
```json
{
  "status": "healthy",
  "service": "demo-app"
}
```

**Home Endpoint:**
```json
{
  "message": "Hello World! API Avengers CI/CD Pipeline Demo",
  "status": "success",
  "version": "1.0.0"
}
```

## 🏥 Health Check Script

The `healthcheck.sh` script performs comprehensive verification:

1. ✅ Container running check
2. ✅ Docker health status check
3. ✅ HTTP health endpoint verification (with retries)
4. ✅ Application endpoints validation

Run manually:
```bash
chmod +x healthcheck.sh
./healthcheck.sh
```

## 🎁 Bonus: Jenkins in Docker (Docker-in-Docker)

### Setup Jenkins with Docker Support

```bash
# Create Jenkins directory
mkdir jenkins_home

# Run Jenkins with Docker socket mounted
docker run -d \
  --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd)/jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts

# Install Docker CLI in Jenkins container
docker exec -u root jenkins sh -c "apt-get update && apt-get install -y docker.io"

# Get initial admin password
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### Access Jenkins

1. Open `http://localhost:8080`
2. Enter the initial admin password
3. Install suggested plugins
4. Create admin user
5. Create a new Pipeline job pointing to this repository

## 🧪 Testing the Pipeline

### Manual Testing Steps

1. **Build Stage Test:**
   ```bash
   cd app && pip install -r requirements.txt
   ```

2. **Test Stage Test:**
   ```bash
   cd app && pytest test_app.py -v
   ```

3. **Package Stage Test:**
   ```bash
   docker build -t api-avengers-demo:latest -f Dockerfile ./app
   docker images | grep api-avengers-demo
   ```

4. **Deploy Stage Test:**
   ```bash
   docker-compose up -d
   docker-compose ps
   ```

5. **Health Check Test:**
   ```bash
   ./healthcheck.sh
   ```

## 📊 Key Features

### Application Features
- ✅ RESTful API with Flask
- ✅ Health monitoring endpoint
- ✅ JSON responses
- ✅ Environment configuration
- ✅ Containerized deployment

### CI/CD Features
- ✅ Declarative Jenkinsfile
- ✅ Automated testing with pytest
- ✅ Docker containerization
- ✅ Docker Compose orchestration
- ✅ Automated health verification
- ✅ Pipeline status reporting
- ✅ Cleanup on failure

### DevOps Best Practices
- ✅ Infrastructure as Code
- ✅ Automated testing
- ✅ Container health checks
- ✅ Graceful error handling
- ✅ Comprehensive logging
- ✅ Resource cleanup

## 🐛 Troubleshooting

### Container won't start
```bash
# Check logs
docker-compose logs

# Restart services
docker-compose down
docker-compose up -d
```

### Health check fails
```bash
# Check if port is accessible
curl http://localhost:5000/health

# Check container status
docker ps
docker inspect api-avengers-demo
```

### Pipeline fails in Jenkins
- Ensure Docker is available in Jenkins
- Check Jenkins has permissions to run Docker commands
- Verify Docker socket is mounted correctly

## 🧹 Cleanup

```bash
# Stop and remove containers
docker-compose down

# Remove Docker image
docker rmi api-avengers-demo:latest

# Clean up Docker system
docker system prune -f
```

## 📝 Deliverables Checklist

- ✅ Jenkinsfile (Declarative pipeline with all stages)
- ✅ Dockerfile (Container image definition)
- ✅ docker-compose.yml (Container orchestration)
- ✅ app/ directory (Flask application source code)
- ✅ healthcheck.sh (Health verification script)
- ✅ Unit tests (pytest test suite)
- ✅ README.md (Complete documentation)

## 🎯 Pipeline Success Criteria

All stages must complete successfully:
1. ✅ Code checkout from repository
2. ✅ Dependencies installed
3. ✅ All unit tests pass
4. ✅ Docker image built successfully
5. ✅ Container deployed and running
6. ✅ Health check returns 200 OK
7. ✅ All endpoints responding correctly

## 📸 Screenshots

Screenshots should capture:
1. Jenkins pipeline view showing all green stages
2. Console output showing successful execution
3. Health check passing with all validations
4. Application running at http://localhost:5000

## 👨‍💻 Author

**API Avengers Preliminary Round Submission**
- Email: seyamalam41@gmail.com
- Project: CI/CD Deployment Pipeline

## 📄 License

This is a demo project created for the API Avengers Preliminary Round.

## 🙏 Acknowledgments

- Flask framework for the web application
- Docker for containerization
- Jenkins for CI/CD automation
- pytest for testing framework

---

**Status:** ✅ All deliverables complete and tested

**Pipeline Status:** ✅ Build → Test → Package → Deploy → Health Check → SUCCESS
