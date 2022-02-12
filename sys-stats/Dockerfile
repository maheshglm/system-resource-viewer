ARG NODE_IMAGE=node:lts-alpine3.14
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

RUN chown -R nginx:nginx .

USER nginx

EXPOSE 8080

ENTRYPOINT ["nginx", "-g", "daemon off;"]