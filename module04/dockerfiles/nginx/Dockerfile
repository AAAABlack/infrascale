# Use the official Nginx Alpine image for minimal size (~40MB)
# Alpine Linux uses musl libc instead of glibc, keeping the image tiny
FROM nginx:1.25-alpine

# Remove the default configuration shipped with the Nginx image
RUN rm /etc/nginx/conf.d/default.conf

# Copy our custom configuration into the container
COPY nginx.conf /etc/nginx/nginx.conf

# Document the listening port
EXPOSE 80

# Nginx runs as the nginx user by default in the official image
# The CMD is inherited from the base image:
# ["nginx", "-g", "daemon off;"]
