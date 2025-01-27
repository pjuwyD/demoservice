FROM python:3.13-slim

RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && curl -sL https://github.com/openfaas/of-watchdog/releases/download/0.10.7/fwatchdog-arm64 > /usr/bin/fwatchdog \
    && chmod +x /usr/bin/fwatchdog\
    && rm -rf /var/lib/apt/lists/*

ENV fprocess="python entrypoint.py"
COPY entrypoint.py /

RUN pip install requests

EXPOSE 8080
CMD [ "fwatchdog" ]