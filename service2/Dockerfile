FROM python:3.13-slim

RUN echo "Building for architecture: $(dpkg --print-architecture)"

RUN apt-get update && apt-get install -y --no-install-recommends curl 

RUN groupadd --system service2 && useradd --system --create-home --no-log-init -g service2 service2

RUN ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "arm64" ]; then \
        curl -sL https://github.com/openfaas/of-watchdog/releases/download/0.10.7/fwatchdog-arm64 -o /usr/local/bin/fwatchdog; \
    elif [ "$ARCH" = "amd64" ]; then \
        curl -sL https://github.com/openfaas/of-watchdog/releases/download/0.10.7/fwatchdog-amd64 -o /usr/local/bin/fwatchdog; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi \
    && chmod +x /usr/local/bin/fwatchdog

WORKDIR /home/service2
COPY entrypoint.py .

RUN pip install requests

RUN chown -R service2:service2 /home/service2

USER service2

ENV fprocess="python entrypoint.py"
EXPOSE 8080
CMD [ "fwatchdog" ]