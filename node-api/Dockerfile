FROM node:20-alpine3.17 AS build

COPY . .

EXPOSE 3000

##
FROM build AS dev

RUN npm install && npm install -g nodemon

CMD ["nodemon", "src/index.js"]

##
FROM build as prod

RUN npm ci --production

CMD ["node", "src/index.js"]
