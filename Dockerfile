FROM nginx:alpine

# Copy our nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy pre-built React static files
COPY build/ /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
