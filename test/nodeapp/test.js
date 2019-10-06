const app = require("express")();
const { hostname } = require("os");

app.get("/", (_, res) => res.send(`Hello from ${hostname()}`));
const server = app.listen(80, () => console.log("Listening"));

let count = 1;
server.on("connection", (socket) => {
	const connectionId = count++;
	const name = `${socket.remoteAddress}:${socket.remotePort} <-> ${socket.localAddress}:${socket.localPort} (id ${connectionId})`;
	console.log(`Socket ${name} opened`);
	socket.on("close", (hadErr) => console.log(`Socket ${name} closed`));
});

process.on("SIGTERM", () => process.exit(0));