FROM ontotext/graphdb:10.7.3

USER root
COPY nginx/local-certs/cert.pem $JAVA_HOME/lib/security
RUN \
    cd $JAVA_HOME/lib/security \
    && keytool -keystore cacerts -storepass changeit -noprompt -trustcacerts -importcert -alias ldapcert -file cert.pem
