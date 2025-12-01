FROM python:3.12.0-slim-bookworm
ENV PYTHONBUFFERED 1
ENV PYTHONWRITEBYTECODE 1
ENV APP=/app
# Change the workdir.
WORKDIR $APP
# Install the requirements
COPY requirements.txt $APP
RUN pip3 install -r requirements.txt
# Copy the rest of the files
COPY . $APP
# Create a non-root user
RUN groupadd -r appuser && useradd -r -g appuser -u 1000 appuser
# Set ownership of the app directory
RUN chown -R appuser:appuser $APP
# Make entrypoint executable
RUN chmod +x /app/entrypoint.sh
# Switch to non-root user
USER appuser
EXPOSE 8000
ENTRYPOINT ["/bin/bash","/app/entrypoint.sh"]
CMD ["gunicorn", "--bind", ":8000", "--workers", "3", "djangoproj.wsgi"]
