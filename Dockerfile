FROM maven:3.6-slim AS builder
COPY . /support-diagnostics
WORKDIR /support-diagnostics
# some tests do not currently run correctly on non-OSX, see: https://github.com/elastic/support-diagnostics/issues/377
RUN mvn package -q -DskipTests

FROM openjdk:11-slim
COPY --from=builder /support-diagnostics/target/lib /support-diagnostics/lib
COPY --from=builder /support-diagnostics/target/support-diagnostics-8.0.0.jar /support-diagnostics/support-diagnostics-8.0.0.jar
# TODO: Xdebug is in the shell startup script but doesnt seem to work here
# TODO: Invalid initial heap size: -Xms256m -Xmx2000m
CMD ["java","-jar","/support-diagnostics/support-diagnostics-8.0.0.jar"]
