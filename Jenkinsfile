pipeline {
    agent any

    environment {
        IMAGE_NAME = 'hola-mundo'
        CONTAINER_NAME = 'hola-mundo'
        PORT = '8000'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/jgarciamartin/POC_JAVA.git'
            }
        }

        stage('Build Maven Project') {
            steps {
                // Compila el proyecto y genera el JAR
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Construye la imagen Docker
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Stop Old Container') {
            steps {
                // Para y elimina el contenedor viejo si está corriendo
                sh """
                if [ \$(docker ps -q -f name=${CONTAINER_NAME}) ]; then
                    docker stop ${CONTAINER_NAME}
                    docker rm ${CONTAINER_NAME}
                fi
                """
            }
        }

        stage('Run Docker Container') {
            steps {
                // Ejecuta el contenedor con puerto mapeado
                sh "docker run -d --name ${CONTAINER_NAME} -p ${PORT}:8000 ${IMAGE_NAME}:latest"
            }
        }
    }

    post {
        success {
            echo "✅ Despliegue completado. La app está corriendo en http://localhost:${PORT}"
        }
        failure {
            echo "❌ Error en el pipeline"
        }
    }
}
