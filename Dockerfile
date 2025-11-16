# ---------- Stage 1: Build ----------
# Imagen con Maven y JDK 17
FROM maven:3.9.5-eclipse-temurin-17 AS build

# Directorio de trabajo
WORKDIR /app

# Copiamos pom y descargamos dependencias
COPY pom.xml .
COPY src ./src

# Construimos el proyecto (salta tests para acelerar)
RUN mvn clean package -DskipTests

# ---------- Stage 2: Runtime ----------
# Imagen ligera con solo JDK 17
FROM eclipse-temurin:17-jdk-alpine

# Directorio de la app
WORKDIR /app

# Copiamos el JAR compilado del stage anterior
COPY --from=build /app/target/hola-mundo-1.0.0.jar app.jar

# Exponemos el puerto 8000
EXPOSE 8000

# Comando para ejecutar la app
CMD ["java", "-jar", "app.jar"]
