pipeline {
  agent any

  environment {
    FRONTEND_IMAGE = "abuabddullah/mern-frontend:1.0"
    BACKEND_IMAGE  = "abuabddullah/mern-backend:1.0"
    PORT = "5000"
    MONGO_URI = "mongodb://mongo:27017/taskdb"
  }

  stages {
    stage('Clean Workspace') {
      steps {
        echo "🧹 Cleaning old workspace..."
        deleteDir()
      }
    }

    stage('Checkout Code') {
      steps {
        echo "📦 Cloning repository from GitHub..."
        // 👉 If your repo is PUBLIC:
        git branch: 'main', url: 'https://github.com/abuabddullah/devops-asif.git'

        // 👉 If your repo is PRIVATE, comment the above line and use this one:
        // git branch: 'main', credentialsId: 'github-credentials-id', url: 'https://github.com/abuabddullah/devops-asif.git'
      }
    }

    stage('Prepare .env') {
      steps {
        echo "⚙️ Creating .env file for backend..."
        sh '''
          mkdir -p server
          cat > server/.env <<EOF
PORT=$PORT
MONGO_URI=$MONGO_URI
EOF
        '''
      }
    }

    stage('Build Docker Images') {
      steps {
        echo "🐳 Building Docker images..."
        sh '''
          echo "Building backend image..."
          docker build -t $BACKEND_IMAGE ./server

          echo "Building frontend image..."
          docker build -t $FRONTEND_IMAGE ./client --build-arg VITE_API_URL=http://localhost:5000/api
        '''
      }
    }

    stage('Run with Docker Compose') {
      steps {
        echo "🚀 Running MERN stack with Docker Compose..."
        sh '''
          docker compose down || true
          docker compose up -d
          echo "✅ Containers running:"
          docker ps
        '''
      }
    }

    stage('Show Logs') {
      steps {
        echo "📋 Showing container logs..."
        sh '''
          echo "===== Backend Logs ====="
          docker logs backend || true

          echo "===== Frontend Logs ====="
          docker logs frontend || true
        '''
      }
    }
  }

  post {
    success {
      echo "🎉 Build completed successfully!"
    }
    failure {
      echo "❌ Build failed. Please check the logs above."
    }
  }
}
