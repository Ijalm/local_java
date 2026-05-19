# =========================
# Build Stage
# =========================
FROM maven:3.8.6-openjdk-8 AS build

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY . .

RUN mvn clean package -DskipTests

# =========================
# Runtime Stage
# =========================
FROM tomcat:8.5-jdk8

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/shopping-cart.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
