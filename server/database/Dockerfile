FROM node:18.12.1-bullseye-slim

WORKDIR /app

RUN npm install -g npm@9.1.3

# Copy package.json and install dependencies
COPY package.json .
RUN npm install

# Copy all application files
COPY app.js .
COPY review.js .
COPY dealership.js .
COPY inventory.js .

# Copy data files directly to /app (where app.js expects them)
COPY data/reviews.json .
COPY data/dealerships.json .
COPY data/car_records.json .

# Create a non-root user with a unique UID
RUN groupadd -r nodeuser && useradd -r -g nodeuser -u 1001 nodeuser
RUN chown -R nodeuser:nodeuser /app

# Switch to non-root user
USER nodeuser

EXPOSE 3030

CMD [ "node", "app.js" ]
