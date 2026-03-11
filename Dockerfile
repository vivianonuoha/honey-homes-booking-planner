FROM nginx:alpine

COPY handyperson-directory.html /usr/share/nginx/html/index.html
COPY index.html /usr/share/nginx/html/booking-planner.html

# Startup script: substitute $PORT into nginx config at runtime
RUN echo $'#!/bin/sh\n\
cat > /etc/nginx/conf.d/default.conf <<EOF\n\
server {\n\
  listen ${PORT:-8080};\n\
  root /usr/share/nginx/html;\n\
  index index.html;\n\
  location / { try_files \\$uri \\$uri/ =404; }\n\
}\n\
EOF\n\
exec nginx -g "daemon off;"' > /start.sh && chmod +x /start.sh

EXPOSE 8080
CMD ["/start.sh"]
