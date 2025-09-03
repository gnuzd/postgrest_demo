// Import the framework and instantiate it
import Fastify from 'fastify';
import websocket from '@fastify/websocket';
import createSubscriber from 'pg-listen';

const fastify = Fastify({
  logger: true,
});

const subscriber = createSubscriber({
  connectionString: 'postgres://authenticator:password@localhost:5432/app_db',
});

fastify.register(websocket);

const activeChannels = new Set();

// The WebSocket route
fastify.register(async function (fastify) {
  fastify.get('/ws', { websocket: true }, (socket, _req) => {
    // When a new client connects, handle it here.
    socket.on('message', (message: any) => {
      try {
        // Assuming the client sends a JSON object with a 'topic' key
        const { topic } = JSON.parse(message.toString());

        if (topic && !activeChannels.has(topic)) {
          // Only set up a listener if we aren't already listening to this topic
          subscriber.listenTo(topic);
          fastify.log.info(`Now listening for new messages on channel: ${topic}`);

          subscriber.notifications.on(topic, (payload) => {
            const notificationMessage = JSON.stringify({ ...payload, topic });
            fastify.log.info(`New message received from PostgreSQL on channel '${topic}':`, payload);

            // Broadcast the new message to all connected WebSocket clients.
            fastify.websocketServer.clients.forEach((client: any) => {
              if (client.readyState === 1) {
                client.send(notificationMessage);
              }
            });
          });

          // Add the new topic to our set of active channels
          activeChannels.add(topic);
        } else if (topic && activeChannels.has(topic)) {
          fastify.log.info(`Already listening to channel: ${topic}. No new listener will be created.`);
        }
      } catch (err: any) {
        fastify.log.error('Failed to parse message from client or invalid topic:', err);
      }
      // fastify.log.info(`Received a message from a client: ${message}`);
    });
  });
});

// Listen to PostgreSQL NOTIFY and broadcast to all connected clients
subscriber
  .connect()
  // .then(() => {
  //   subscriber.listenTo('channels');
  //   fastify.log.info('Listening for new messages on chat_channel');
  //
  //   subscriber.notifications.on('channels', (payload) => {
  //     const message = JSON.stringify(payload);
  //     fastify.log.info('New message received from PostgreSQL:', payload);
  //
  //     // Broadcast the new message to all connected WebSocket clients.
  //     fastify.websocketServer.clients.forEach((client: any) => {
  //       if (client.readyState === 1) {
  //         // Check if the client is open
  //         client.send(message);
  //       }
  //     });
  //   });
  // })
  .catch((err) => fastify.log.error('Failed to connect to PostgreSQL:', err));

fastify.get('/', async function handler() {
  return { hello: 'world' };
});

// Run the server!
try {
  await fastify.listen({ port: 3000 });
} catch (err) {
  fastify.log.error(err);
  process.exit(1);
}

