FROM node:8-alpine

COPY package.json package-lock.json ./
RUN npm ci
COPY test.js ./
CMD node test.js