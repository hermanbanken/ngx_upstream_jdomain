FROM alpine

RUN apk add curl
CMD sh -c "while true; do curl -sS http://nginx; echo ""; sleep 1; done"
