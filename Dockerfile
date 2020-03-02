FROM maven:3.6-slim AS builder
COPY . /support-diagnostics
WORKDIR /support-diagnostics
# some tests do not currently run correctly on non-OSX, see: https://github.com/elastic/support-diagnostics/issues/377
RUN mvn package -q -DskipTests
# TODO: Xdebug is in the shell startup script but doesnt seem to work here
CMD ["java", "-Xrunjdwp:server=y,transport=dt_socket,address=8000,suspend=y", "-Xms256m -Xmx2000m", "-jar", "/support-diagnostics/support-diagnostics-8.0.0.jar"]
