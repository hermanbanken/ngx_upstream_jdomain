FROM alpine

RUN apk add curl
CMD sh -c "while true; do curl -sSi http://nginx; echo ""; sleep 1; done"
