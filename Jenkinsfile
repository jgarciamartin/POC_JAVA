pipeline {
    agent any

    environment {
        IMAGE_NAME = 'hola-mundo'
        CONTAINER_NAME = 'hola-mundo'
        PORT = '8000'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                echo "🧹 Limpiando workspace..."
                deleteDir()
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/jgarciamartin/POC_JAVA.git'
            }
        }

        stage('Build Maven Project') {
            steps {
                echo "📦 Compilando proyecto Maven..."
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Construyendo imagen Docker..."
                bat "docker build -t %IMAGE_NAME%:latest ."
            }
        }

        stage('Stop Old Container') {
            steps {
                echo "⏹ Deteniendo contenedor antiguo si existe..."
                bat """
                    @echo off
                    set CONTAINER_ID=
                    for /F "tokens=*" %%i in ('docker ps -q -f "name=%CONTAINER_NAME%"') do set CONTAINER_ID=%%i
                    if defined CONTAINER_ID (
                        docker stop %CONTAINER_ID%
                        docker rm %CONTAINER_ID%
                    ) else (
                        echo No existe contenedor con nombre %CONTAINER_NAME%
                    )
                """
            }
        }

        stage('Run Docker Container') {
            steps {
                echo "🏃‍♂️ Ejecutando contenedor..."
                bat "docker run -d --name %CONTAINER_NAME% -p %PORT%:8000 %IMAGE_NAME%:latest"
            }
        }
    }

    post {
        success {
            echo "✅ Despliegue completado. La app está corriendo en http://localhost:%PORT%"
        }
        failure {
            echo "❌ Error en el pipeline"
        }
    }
}
