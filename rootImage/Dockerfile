FROM ubuntu:22.04

ARG AWS_ACCESS_KEY_ID_TEMP
ARG AWS_SECRET_ACCESS_KEY_TEMP
ARG AWS_SESSION_TOKEN_TEMP

RUN apt update && apt install -y curl unzip

RUN  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
     unzip awscliv2.zip && \
     ./aws/install

RUN aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID_TEMP"  &&\
      aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY_TEMP"  &&\
      aws configure set aws_session_token "$AWS_SESSION_TOKEN_TEMP"