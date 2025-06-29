# Stage 1: Build the JAR with Maven
FROM maven:3.8.3-openjdk-17 AS builder

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY . .
RUN mvn clean install -DskipTests=true

# Rename the actual jar to expensesapp.jar (adjust the JAR name here)
RUN cp target/*.jar target/expensesapp.jar

# Stage 2: Create a minimal runtime image
FROM openjdk:17-alpine

WORKDIR /app

# Copy the JAR from the builder stage
COPY --from=builder /app/target/expensesapp.jar .

# Start the app
CMD ["java", "-jar", "expensesapp.jar"]

