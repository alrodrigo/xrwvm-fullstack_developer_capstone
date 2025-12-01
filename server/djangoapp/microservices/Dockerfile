FROM python:3.9.18-slim-bookworm

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
COPY . .

# Download NLTK data
RUN python3 -c "import nltk; nltk.download('vader_lexicon')"

# Create a non-root user
RUN groupadd -r flaskuser && useradd -r -g flaskuser -u 1000 flaskuser
RUN chown -R flaskuser:flaskuser /app

# Switch to non-root user
USER flaskuser

EXPOSE 5000

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
