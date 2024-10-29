FROM node:22-alpine

USER 1000:1000
WORKDIR /app

COPY package.json .
RUN npm install

EXPOSE 8000
# live reload
EXPOSE 35729

ENTRYPOINT ["npx", "reveal-md"]
CMD ["--watch", "--port", "8000", "/slides"]
