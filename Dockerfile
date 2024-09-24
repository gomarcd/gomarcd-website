FROM hugomods/hugo:exts-0.134.3@sha256:3c0dc6865ed250d61d55bf9ba8174f58058e8425ea2d056b0fe237bc3ecb7813 as builder

WORKDIR /app

# copy Hugo project from host machine into docker image
COPY . .
RUN hugo

FROM nginx:alpine3.20@sha256:a5127daff3d6f4606be3100a252419bfa84fd6ee5cd74d0feaca1a5068f97dcf

COPY --from=builder /app/public /usr/share/nginx/html

# www to non-www redirect
RUN sed -i 's|server {|server {\n    if ($host ~* ^www\.(.*)) { return 301 $scheme://$1$request_uri; }|' /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
