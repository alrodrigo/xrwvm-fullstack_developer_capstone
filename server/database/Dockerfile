FROM node:18.12.1-bullseye-slim

WORKDIR /app

RUN npm install -g npm@9.1.3

COPY package.json .
COPY app.js .
COPY review.js .
COPY dealership.js .
COPY inventory.js .
COPY data/dealerships.json ./data/
COPY data/reviews.json ./data/
COPY data/car_records.json ./data/

RUN npm install

# Create a non-root user with a unique UID
RUN groupadd -r nodeuser && useradd -r -g nodeuser -u 1001 nodeuser
RUN chown -R nodeuser:nodeuser /app

# Switch to non-root user
USER nodeuser

EXPOSE 3030

CMD [ "node", "app.js" ]
