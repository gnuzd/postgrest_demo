<script>
	import { Plus } from '@lucide/svelte';
	import Button from './Button.svelte';
	import ChannelItem from './ChannelItem.svelte';
	import Input from './Input.svelte';
	import { modal } from './modal';
	import CreateChannelModal from './CreateChannelModal.svelte';
	import { page } from '$app/state';

	const { channels, me } = $props();

	let list = $state(channels);

	import { onMount } from 'svelte';

	onMount(() => {
		// Connect to the Fastify WebSocket server
		let ws = new WebSocket('ws://localhost:3000/ws');
		ws.onopen = () => {
			console.log('Connected to WebSocket server.');

			// Send a message to the server to specify the channel
			const topicMessage = { topic: 'channels' };
			ws.send(JSON.stringify(topicMessage));
		};

		ws.onmessage = (event) => {
			const message = JSON.parse(event.data);
			console.log('Received message from server:', message);
			if (message.topic === 'channels' && message.new.user_id !== me.id)
				list = [...list, message.new];
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

<div class="flex flex-col h-full">
	<div class="px-4 py-3 flex gap-1.5 items-center w-full">
		<div class="flex-1">
			<Input placeholder="Search" class="bg-base-100" />
		</div>
		<Button
			class="btn-square btn-ghost"
			onclick={() =>
				modal.open(CreateChannelModal, {
					dismissible: true,
					title: 'Create Channel',
					props: { onClose: (data) => (list = [data, ...list]) }
				})}
		>
			<Plus />
		</Button>
	</div>

	<ul class="list px-2">
		{#each list as item}
			<ChannelItem data={item} active={item.id === page.url.searchParams.get('channel')} />
		{/each}
	</ul>
</div>
