<script lang="ts">
	import ChatInput from './ChatInput.svelte';
	import MessageList from './MessageList.svelte';

	const { messages, me } = $props();
	let list = $state(messages);
</script>

<div class="p-2 flex flex-col h-full">
	<div class="flex-1">
		<MessageList {messages} {me} />
	</div>

	<ChatInput onSend={(message) => (list = [message, ...list])} />
</div>
