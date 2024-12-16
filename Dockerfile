# Step 1: Use an official Maven image to build the project
FROM docker.io/maven:3.9.9-eclipse-temurin-21 AS build

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy the project files into the container
COPY . .

# Step 4: Build the project using Maven to create a WAR file
RUN mvn clean package

# Step 5: Use Tomcat image to deploy the WAR
FROM docker.io/tomcat:jdk21

# Step 6: Set the working directory inside the Tomcat container
WORKDIR /usr/local/tomcat/webapps

# Step 7: Copy the built WAR file from the Maven build stage into Tomcat's webapps folder
COPY --from=build /app/target/nano.war /usr/local/tomcat/webapps/ROOT.war

# Step 8: Expose the port that Tomcat listens on
EXPOSE 8080

# Step 9: Set the command to run Tomcat
CMD ["catalina.sh", "run"]
