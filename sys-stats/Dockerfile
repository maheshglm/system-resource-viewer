ARG NODE_IMAGE=node:16-alpine
ARG NGINX_IMAGE=nginx:1.21.6

FROM ${NODE_IMAGE} AS builder

LABEL maintainer="Mahesh maheshglm@gmail.com"

WORKDIR /app

COPY package.json ./

RUN npm install

COPY . ./

RUN npm run build

FROM ${NGINX_IMAGE}

COPY --from=builder /app/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app/nginx/default.conf /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/html

RUN chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d

RUN touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid    

# Remove default nginx static resources
RUN rm -rf ./*

COPY --from=builder /app/build .

# Copy .env file and shell script to container
COPY ./env.sh .
COPY .env .

# Make shell script executable
RUN chmod +x env.sh

RUN chown -R nginx:nginx .

USER nginx

EXPOSE 8080

ENTRYPOINT ["/bin/sh", "-c", "/usr/share/nginx/html/env.sh && nginx -g \"daemon off;\""]