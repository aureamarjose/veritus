FROM nginx
RUN apt-get update -qq && apt-get install -y apache2-utils
ENV RAILS_ROOT /var/www/inspira
WORKDIR $RAILS_ROOT
RUN mkdir -p $RAILS_ROOT/log
COPY nginx/app.conf /tmp/docker_example.nginx
RUN envsubst '$RAILS_ROOT' < /tmp/docker_example.nginx > /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD [ "nginx", "-g", "daemon off;" ]
