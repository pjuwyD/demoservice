FROM python:3.13-slim

RUN echo "Building for architecture: $(dpkg --print-architecture)"

RUN apt-get update && apt-get install -y --no-install-recommends curl 

RUN ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "arm64" ]; then \
        curl -sL https://github.com/openfaas/of-watchdog/releases/download/0.10.7/fwatchdog-arm64 -o /usr/bin/fwatchdog; \
    elif [ "$ARCH" = "amd64" ]; then \
        curl -sL https://github.com/openfaas/of-watchdog/releases/download/0.10.7/fwatchdog-amd64 -o /usr/bin/fwatchdog; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi \
    && chmod +x /usr/bin/fwatchdog

ENV fprocess="python entrypoint.py"
COPY entrypoint.py /

RUN pip install requests

EXPOSE 8080
CMD [ "fwatchdog" ]