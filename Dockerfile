FROM httpd:2.4
RUN apt-get update && apt-get install -y pandoc
COPY ./usr-local-apache2 /usr/local/apache2/
RUN echo 'Include local.conf' >> /usr/local/apache2/conf/httpd.conf

