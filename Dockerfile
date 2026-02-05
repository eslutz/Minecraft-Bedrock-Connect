# Multi-stage build for BedrockConnect on Raspberry Pi (ARM64)
# Uses Eclipse Temurin JRE for ARM64 compatibility

FROM eclipse-temurin:21-jre

# Create application directory
RUN mkdir -p /app

# Download the latest BedrockConnect JAR
ADD https://github.com/Pugmatt/BedrockConnect/releases/latest/download/BedrockConnect-1.0-SNAPSHOT.jar /app/BedrockConnect-1.0-SNAPSHOT.jar

# Set working directory
WORKDIR /app

# Expose UDP port 19132 (Minecraft Bedrock default port)
EXPOSE 19132/udp

# Optional: Create volumes for persistent data
VOLUME ["/app/players", "/app"]

# Set JVM memory limits appropriate for Raspberry Pi
# Adjust -Xms and -Xmx based on your Pi's available RAM
# For Pi 4 with 4GB+: use 1G/2G
# For Pi 4 with 2GB: use 512M/1G
# For Pi 3 or lower RAM: use 256M/512M
ENV JAVA_OPTS="-Xms512M -Xmx1G"

# Run BedrockConnect
# You can pass additional configuration via environment variables with BC_ prefix
# or mount a config.yml file to /app/config.yml
CMD ["sh", "-c", "java $JAVA_OPTS -jar BedrockConnect-1.0-SNAPSHOT.jar"]
