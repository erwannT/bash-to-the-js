FROM root:latest

# The port that your application listens to.
EXPOSE 8000

WORKDIR /app

# Prefer not to run as root.
#USER deno

# These steps will be re-run upon each file change in your working directory:
COPY . .
# Compile the main app so that it doesn't need to be compiled each startup/entry.
RUN deno cache index.ts

ENV DB_HOSTNAME=""
ENV DB_USER=""
ENV DB_NAME=""
ENV DB_PASSWORD=""

CMD ["run", "--allow-net", "--allow-read", "--allow-sys","--allow-env",  "index.ts"]