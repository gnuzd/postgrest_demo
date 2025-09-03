<script lang="ts">
	import { onMount } from 'svelte';
	import ChatInput from './ChatInput.svelte';
	import MessageList from './MessageList.svelte';
	import { page } from '$app/state';

	const { messages, me } = $props();
	let list = $state(messages);

	onMount(() => {
		// Connect to the Fastify WebSocket server
		let ws = new WebSocket('ws://localhost:3000/ws');
		ws.onopen = () => {
			console.log('Connected to WebSocket server.');

			// Send a message to the server to specify the channel
			const topicMessage = { topic: 'messages' };
			ws.send(JSON.stringify(topicMessage));
		};

		ws.onmessage = (event) => {
			const message = JSON.parse(event.data);
			console.log('Received message from server:', message);
			if (
				message.topic === 'messages' &&
				me.id !== message.new.user_id &&
				message.new.channel_id === page.url.searchParams.get('channel')
			)
				list = [message.new, ...list];
		};

		ws.onclose = () => {
			console.log('WebSocket connection closed.');
		};

		return () => {
			// Clean up the connection when the component is unmounted
			ws.close();
		};
	});
</script>

<div class="p-2 flex flex-col h-full">
	<div class="flex-1">
		<MessageList messages={list} {me} />
	</div>

	<ChatInput onSend={(message) => (list = [message, ...list])} />
</div>
